# webdebugger

[![Build Status](https://travis-ci.org/vscoder/webdebugger.svg?branch=master)](https://travis-ci.org/vscoder/webdebugger)

This webb app show HTTP headers and other useful information

## How to run

### Docker

Just run docker container from Docker Hub

```shell
docker run -p 8080:8080 vscoder/webdebugger:latest
```
And now open webdebugger at http://localhost:8080/

## Configuration

### Environment variables

App behavior variables:
- `APP_DELAY` reply delay, seconds
- `APP_BGCOLOR` set web-page background color. Default `white`
- `APP_NO_CSS` disable loading external CSS or JS resources (usebla inside of isolated environments). Available values: one of `'true', 'yes', '1'` is `True`, every other value is `False`.

Sentry-related variables:
- `SENTRY_DSN` sentry DSN to send traces. Default empty
TODO:

### Routes

Webdebugger process these URI paths

- `/hello` - always return `Hello World! ^_^`
- `/healthz` - always return `OK`
- `/env/<env_var>` - return value of uppercased os environment variable `env_var`
- `/` and `/<path:path>` - are all other URI paths. Return request and os environment variables.

## Development

### Requirements

First, you must have `make` installed, to simplify all the operations.
If you haven't, see [Makefile](Makefile) for corresponding commands.

Then, you must have `poetry` installed. See https://python-poetry.org/docs/

Or just run 
```shell
make install_poetry
```

After that, install dependencies
```shell
make requirements
```
or
```shell
poetry install --local
```

### Run tests

#### pycodestyle

```shell
make pycodestyle
```
or
```shell
poetry run pycodestyle webdebugger/
```

#### pytest

```shell
make pytest
```
or
```shell
poetry run pytest -v
```

#### hadolint (lint Dockerfile)

```shell
make hadolint
```

## Version control

This project use sematic versioning. See [semver](https://semver.org/)

For increasee version, use corresponding Makefile targets
- `version` - get version
- `version-patch` - increase version patch number
- `version-minor` - increase minor version
- `version-major` - increase major version

**NOTE:** All chacges must be committed. All these actions, except `version`, create new commit and add tag with version number.

## Sentry integration

TODO

## Run in docker container

### Run with docker-compose

- `docker-compose up`

App will be available on you'r IP port `8000`

### Variables (`make` args)

Make args are the same as environment variables

### Commands (`make` targets)

Build image
```shell
make build
```

Build image and run tests
```shell
make docker-pytest
```

Run container
```shell
make docker-run
```

Run shell inside container
```shell
make docker-shell
```

## Author

Aleksey Koloskov <vsyscoder@gmail.com>
