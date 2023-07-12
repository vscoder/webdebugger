import argparse
import os
import sys
from pprint import pformat
from time import sleep

import sentry_sdk
from flask import Flask, render_template, request
from sentry_sdk.integrations.flask import FlaskIntegration

# import metrics
from prometheus_flask_exporter import PrometheusMetrics

# import logging
from logging.config import dictConfig

from opentelemetry import trace
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
# https://opentelemetry-python-contrib.readthedocs.io/en/latest/instrumentation/flask/flask.html
from opentelemetry.instrumentation.flask import FlaskInstrumentor
# https://opentelemetry-python-contrib.readthedocs.io/en/latest/instrumentation/logging/logging.html
from opentelemetry.instrumentation.logging import LoggingInstrumentor
# https://opentelemetry-python-contrib.readthedocs.io/en/latest/instrumentation/jinja2/jinja2.html
from opentelemetry.instrumentation.jinja2 import Jinja2Instrumentor


import webdebugger

###
# OpenTelemetry initialization
###
resource = Resource.create({"service.name": "webdebugger"})
provider = TracerProvider(resource=resource)
# More about OTLPSpanExporter:
#   https://opentelemetry-python.readthedocs.io/en/latest/exporter/otlp/otlp.html
#   https://opentelemetry.io/docs/concepts/sdk-configuration/otlp-exporter-configuration/
# Endpoint may be configured with env OTEL_EXPORTER_OTLP_ENDPOINT
processor = BatchSpanProcessor(OTLPSpanExporter())
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)


###
# Logging instrumentatipn
###
# Configure log format and send all logs to sys.stdout
dictConfig({
    'version': 1,
    'formatters': {'default': {
        'format': '%(asctime)s %(levelname)s [%(name)s] [%(filename)s:%(lineno)d] [trace_id=%(otelTraceID)s span_id=%(otelSpanID)s resource.service.name=%(otelServiceName)s trace_sampled=%(otelTraceSampled)s] - %(message)s',
    }},
    'handlers': {'wsgi': {
        'class': 'logging.StreamHandler',
        'stream': sys.stdout,
        'formatter': 'default'
    }},
    'root': {
        'level': 'INFO',
        'handlers': ['wsgi']
    }
})

# Instrument logging
# https://opentelemetry-python-contrib.readthedocs.io/en/latest/instrumentation/logging/logging.html
LoggingInstrumentor().instrument()

# Flask init
app = Flask(__name__)
# Metrics init
# metrics = PrometheusMetrics(app)
metrics = PrometheusMetrics(app, defaults_prefix='webdebugger', default_labels={'trace_id': lambda x: trace.get_current_span().context.trace_id})

# Instrument flask and jinja2
# https://opentelemetry-python-contrib.readthedocs.io/en/latest/instrumentation/flask/flask.html
FlaskInstrumentor().instrument_app(app)
# https://opentelemetry-python-contrib.readthedocs.io/en/latest/instrumentation/jinja2/jinja2.html
Jinja2Instrumentor().instrument()

metrics.info('webdebugger_app_info', 'Application info', version=webdebugger.version())

@app.route('/hello')
def hello():
    return "Hello World! ^_^"


@app.route('/healthz')
def healthz():
    return "OK"


@app.route('/exception')
def exception():
    raise Exception("test exception generated")


@app.route('/env/<env_var>')
def env_var(env_var):
    """
    Return the value of <env_var> os environment variable
    """
    var_value = os.environ.get(env_var.upper())
    return var_value


@app.route('/')
@app.route('/<path:path>')
def path(path="/"):
    """
    Render main template with lot of request and os information
    """
    # Sleep if defined
    timeout = os.getenv('APP_DELAY')
    if timeout:
        sleep(int(timeout))

    # Collect info
    flask_env = dict(request.environ)
    os_env = dict(os.environ)

    for var, value in flask_env.items():
        app.logger.info(f'{var} = {value}')
    app.logger.info('-'*16)

    return render_template('info.html', path=path, os_env=os_env, flask_env=flask_env)


def main():
    parser = argparse.ArgumentParser(description="Display HTTP headers")
    parser.add_argument("--host", "-H", type=str,
                        default="0.0.0.0", help="listen host")
    parser.add_argument("--port", "-p", type=int,
                        default=8080, help="listen port")
    args = parser.parse_args()

    app.run(host=args.host, port=args.port, debug=True, use_reloader=False)


if __name__ == '__main__':
    main()


# Sentry integration args
sentry_dsn = os.getenv('SENTRY_DSN')
release = os.getenv('APP_VERSION')
if sentry_dsn:
    sentry_sdk.init(
        dsn=sentry_dsn,
        release=f"webdebugger@{release}",
        integrations=[FlaskIntegration()]
    )
