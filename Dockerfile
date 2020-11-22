FROM python:3.7-alpine3.12

ARG YOUR_ENV

ENV YOUR_ENV=${YOUR_ENV} \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.0.3


WORKDIR /app
COPY poetry.lock pyproject.toml /app/

# Deps and requirements:
RUN apk add --no-cache --virtual .build-deps \
    gcc==9.3.0-r2 \
    libffi-dev==3.3-r2 \
    musl-dev==1.1.24-r10 \
    openssl-dev==1.1.1g-r0 \
    && pip install "poetry==$POETRY_VERSION" \
    && poetry config virtualenvs.create false \
    && poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi \
    && apk del .build-deps

COPY . /app

ENV APP_VERSION=0.10.0 \
    APP_DELAY=0 \
    APP_BGCOLOR=white \
    SENTRY_DSN=""

EXPOSE 8080

CMD [ "gunicorn", "-w", "2", "--bind", "0.0.0.0:8080", "webdebugger.main:app" ]
#CMD gunicorn -w 2 --bind 0.0.0.0:8080 webdebugger.main:app
