import argparse
import logging
import os
from pprint import pformat
from time import sleep

import sentry_sdk
from flask import Flask, render_template, request
from sentry_sdk.integrations.flask import FlaskIntegration

app = Flask(__name__)

FORMAT = '%(message)s'
logging.basicConfig(format=FORMAT)
logger = logging.getLogger(__name__)

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
        logger.warning(f'{var} = {value}')
    logger.warning('-'*16)

    return render_template('info.html', path=path, os_env=os_env, flask_env=flask_env)


def main():
    parser = argparse.ArgumentParser(description="Display HTTP headers")
    parser.add_argument("--host", "-H", type=str,
                        default="0.0.0.0", help="listen host")
    parser.add_argument("--port", "-p", type=int,
                        default=8080, help="listen port")
    args = parser.parse_args()

    app.run(host=args.host, port=args.port, debug=True, reloader=True)


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
