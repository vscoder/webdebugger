import argparse
import logging
import os
from pprint import pformat
from time import sleep

import bottle
import sentry_sdk
from bottle import Bottle, jinja2_view, request, route, run
from sentry_sdk.integrations.bottle import BottleIntegration

FORMAT = '%(message)s'
logging.basicConfig(format=FORMAT)
logger = logging.getLogger(__name__)

bottle.TEMPLATE_PATH.insert(0, "%s/views" % (os.path.dirname(__file__)))


@route('/hello')
def hello():
    return "Hello World! ^_^"


@route('/healthz')
def healthz():
    return "OK"


@route('/exception')
def exception():
    raise Exception("test exception generated")


@route('/env/<env_var>')
def env_var(env_var):
    """
    Return the value of <env_var> os environment variable
    """
    var_value = os.environ.get(env_var.upper())
    return var_value


@route('/')
@route('/<path:path>')
@jinja2_view('info')
def path(path="/"):
    """
    Render main template with lot of request and os information
    """
    # Sleep if defined
    timeout = os.getenv('APP_DELAY')
    if timeout:
        sleep(int(timeout))

    # Collect info
    bottle_env = dict(request.environ)
    os_env = dict(os.environ)

    for var, value in bottle_env.items():
        logger.warning(f'{var} = {value}')
    logger.warning('-'*16)

    return dict(path=path, os_env=os_env, bottle_env=bottle_env)


def main():
    parser = argparse.ArgumentParser(description="Display HTTP headers")
    parser.add_argument("--host", "-H", type=str,
                        default="0.0.0.0", help="listen host")
    parser.add_argument("--port", "-p", type=int,
                        default=8080, help="listen port")
    args = parser.parse_args()

    run(host=args.host, port=args.port, debug=True, reloader=True)


if __name__ == '__main__':
    main()


# Sentry integration args
sentry_dsn = os.getenv('SENTRY_DSN')
release = os.getenv('APP_VERSION')
if sentry_dsn:
    sentry_sdk.init(
        dsn=sentry_dsn,
        release=f"webdebugger@{release}",
        integrations=[BottleIntegration()]
    )

app = bottle.default_app()
