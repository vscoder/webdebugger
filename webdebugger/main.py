import os
import argparse
from pprint import pformat

import bottle
from bottle import Bottle, run, request, template, route, view

bottle.TEMPLATE_PATH.insert(0, "%s/views" % (os.path.dirname(__file__)) )

@route('/hello')
def hello():
    return "Hello World!"

@route('/')
@route('/<path:path>')
@view('info')
def path(path="/"):
    bottle_env = dict(request.environ)
    os_env = dict(os.environ)
    #import ipdb; ipdb.set_trace()
    return dict(path=path, os_env=os_env, bottle_env=bottle_env)


def main():
    parser = argparse.ArgumentParser(description="Display HTTP headers")
    parser.add_argument("--host", "-H", type=str, default="0.0.0.0", help="listen host")
    parser.add_argument("--port", "-p", type=int, default=8080, help="listen port")
    args = parser.parse_args()

    run(host=args.host, port=args.port, debug=True, reloader=True)


if __name__ == '__main__':
    main()

app = bottle.default_app()
