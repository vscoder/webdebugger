#!/bin/sh

set -eu

. /venv/bin/activate

# while ! flask db upgrade
# do
#      echo "Retry..."
#      sleep 1
# done

exec gunicorn --bind 0.0.0.0:$PORT --forwarded-allow-ips='*' wsgi:app
