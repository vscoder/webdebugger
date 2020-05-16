FROM python:3.7.6-alpine3.11

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
RUN apk add --no-cache --virtual .build-deps gcc==9.2.0-r4 libffi-dev==3.2.1-r6 musl-dev==1.1.24-r2 openssl-dev==1.1.1g-r0 \
    && pip install "poetry==$POETRY_VERSION" \
    && poetry config virtualenvs.create false \
    && poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi \
    && apk del .build-deps

COPY . /app

ENV APP_VERSION=0.8.1 \
    APP_DELAY=0 \
    APP_PORT=8080

EXPOSE ${APP_PORT}

#CMD ["gunicorn", "-w", "1", "--bind", "0.0.0.0:${APP_PORT}", "webdebugger.main:app"]
CMD gunicorn -w 2 --bind 0.0.0.0:${APP_PORT} webdebugger.main:app
