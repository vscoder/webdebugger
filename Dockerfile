FROM python:3.11-alpine3.18

ARG YOUR_ENV

ENV YOUR_ENV=${YOUR_ENV} \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.5.1


WORKDIR /app
COPY poetry.lock pyproject.toml /app/

# Deps and requirements:
RUN apk add --no-cache --virtual .build-deps \
    gcc \
    libffi-dev \
    musl-dev \
    openssl-dev \
    rust cargo \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir "poetry==$POETRY_VERSION" \
    && poetry config virtualenvs.create false \
    && poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi \
    && apk del .build-deps

COPY . /app

ENV APP_VERSION=0.12.5 \
    APP_DELAY=0 \
    APP_BGCOLOR=white \
    APP_NO_CSS=false \
    SENTRY_DSN=""

EXPOSE 8080

CMD [ "gunicorn", "-w", "2", "--bind", "0.0.0.0:8080", "webdebugger.main:app" ]
#CMD gunicorn -w 2 --bind 0.0.0.0:8080 webdebugger.main:app
