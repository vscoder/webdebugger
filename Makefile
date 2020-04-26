DOCKER_IMAGE_NAME?=webdebugger
DOCKER_IMAGE_TAG?=local

APP_PORT?=8000
APP_DELAY?=0

INTERACTIVE:=$(shell [ -t 0 ] && echo 1)
PYTHON_37_IMAGE?=python:3.7-slim

DOCKER_USER_FLAG?=-u $(shell id -u)
DOCKER_FLAGS?=-t
ifeq ($(INTERACTIVE), 1)
DOCKER_FLAGS:=-it
endif

#
# Requirements
#
.PHONY: install_poetry
install_poetry:
	curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

.PHONY: requirements
requirements:
	poetry install --local

#
# Tests
#
.PHONY: pycodesyle
pycodesyle:
	poetry run pycodestyle webdebugger/

.PHONY: pytest
pytest:
	poetry run pytest -v
	
.PHONY: hadolint
hadolint:
	docker run --rm hadolint/hadolint:latest-alpine < ./Dockerfile

#
# Versions
#
.PHONY: version
version:
	poetry version

.PHONY: version-patch
version-patch:
	poetry run bump2version patch
	
.PHONY: version-minor
version-minor:
	poetry run bump2version minor

.PHONY: version-major
version-major:
	poetry run bump2version major

#
# Docker
#
.PHONY: build
build:
	docker build --cache-from $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

.PHONY: docker-pycodestyle
docker-pycodestyle: build
	docker run $(DOCKER_FLAGS) $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) poetry run pycodestyle webdebugger/

.PHONY: docker-pytest
docker-pytest: build
	docker run $(DOCKER_FLAGS) $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) poetry run pytest -v

.PHONY: docker-run
docker-run: build
	docker run -p $(APP_PORT):$(APP_PORT) --env APP_PORT=$(APP_PORT) --env APP_DELAY=$(APP_DELAY) $(DOCKER_FLAGS) $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

.PHONY: docker-shell
docker-shell: build
	docker run -p $(APP_PORT):$(APP_PORT) --env APP_PORT=$(APP_PORT) --env APP_DELAY=$(APP_DELAY) $(DOCKER_FLAGS) $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) sh

.PHONY: docker-version
docker-version: build
	docker run -p $(APP_PORT):$(APP_PORT) --env APP_PORT=$(APP_PORT) --env APP_DELAY=$(APP_DELAY) $(DOCKER_FLAGS) $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) poetry version
