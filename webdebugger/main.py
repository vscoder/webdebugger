import argparse
from pprint import pformat

import bottle
from bottle import Bottle, run, request, template, route, view

@route('/hello')
def hello():
    return "Hello World!"

@route('/')
@route('/<path:path>')
@view('info')
def path(path="/"):
    headers = dict(request.headers)
    environ = dict(request.environ)
    #import ipdb; ipdb.set_trace()
    return dict(path=path, headers=headers, environ=environ)


def main():
    parser = argparse.ArgumentParser(description="Display HTTP headers")
    parser.add_argument("--host", "-H", type=str, default="0.0.0.0", help="listen host")
    parser.add_argument("--port", "-p", type=int, default=8080, help="listen port")
    args = parser.parse_args()

    run(app, host=args.host, port=args.port, debug=True, reloader=True)


if __name__ == '__main__':
    main()

app = bottle.default_app()
