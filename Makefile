DOCKER_IMAGE_NAME?=webdebugger
DOCKER_IMAGE_TAG?=local
DOCKER_USERNAME?=
DOCKER_PASSWORD?=

HOST_PORT?=8000
APP_DELAY?=0
APP_BGCOLOR?=white
APP_NO_CSS=false

# Sentry
SENTRY_DSN="http://8ba829ea40a04af28f5361b836499346@192.168.128.8:19000/3"
SENTRY_ORG=sentry
SENTRY_URL=http://sentry.local:19000/
SENTRY_PROJECT=webdebugger
SENTRY_AUTH_TOKEN="1ea340b1084a4df4905f76ef97387070ec3fac6f08644fd7aabd6f74b48207ce"

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
	poetry install

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
	docker run --rm -i hadolint/hadolint:latest-alpine hadolint --ignore SC2046 --ignore DL3018 --ignore DL3013 - < ./Dockerfile

#
# Versions
#
.PHONY: version
version:
	poetry version

.PHONY: version-patch
version-patch:
	poetry run bump2version patch
	$(MAKE) version
	
.PHONY: version-minor
version-minor:
	poetry run bump2version minor
	$(MAKE) version

.PHONY: version-major
version-major:
	poetry run bump2version major
	$(MAKE) version


#
# Git
#
.PHONY: push
push:
	git push && git push --tags


#
# Sentry
#
.PHONY: sentry-release-new
sentry-release-new:
	SENTRY_URL=$(SENTRY_URL) \
	SENTRY_PROJECT=$(SENTRY_PROJECT) \
	SENTRY_AUTH_TOKEN=$(SENTRY_AUTH_TOKEN) \
	sentry-cli releases new -p $(SENTRY_PROJECT) $(SENTRY_PROJECT)@$(shell cat ./VERSION.txt)

.PHONY: sentry-set-commits
sentry-set-commits:
	SENTRY_URL=$(SENTRY_URL) \
	SENTRY_PROJECT=$(SENTRY_PROJECT) \
	SENTRY_AUTH_TOKEN=$(SENTRY_AUTH_TOKEN) \
	sentry-cli releases set-commits --auto $(SENTRY_PROJECT)@$(shell cat ./VERSION.txt)

.PHONY: sentry-release-finalize
sentry-release-finalize:
	SENTRY_URL=$(SENTRY_URL) \
	SENTRY_PROJECT=$(SENTRY_PROJECT) \
	SENTRY_AUTH_TOKEN=$(SENTRY_AUTH_TOKEN) \
	sentry-cli releases finalize $(SENTRY_PROJECT)@$(shell cat ./VERSION.txt)


#
# Docker
#
.PHONY: build
build:
	docker build --cache-from $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

.PHONY: docker-pycodestyle
docker-pycodestyle:
	docker run $(DOCKER_FLAGS) $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) poetry run pycodestyle webdebugger/

.PHONY: docker-pytest
docker-pytest:
	docker run $(DOCKER_FLAGS) $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) poetry run pytest -v

.PHONY: docker-run
docker-run:
	docker run -p $(HOST_PORT):8080 --env APP_DELAY=$(APP_DELAY) --env APP_BGCOLOR=$(APP_BGCOLOR) --env APP_NO_CSS=$(APP_NO_CSS) --env SENTRY_DSN=$(SENTRY_DSN) $(DOCKER_FLAGS) $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

.PHONY: docker-shell
docker-shell:
	docker run -p $(HOST_PORT):8080 --env APP_DELAY=$(APP_DELAY) --env APP_BGCOLOR=$(APP_BGCOLOR) --env APP_NO_CSS=$(APP_NO_CSS) $(DOCKER_FLAGS) $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) sh

.PHONY: docker-version
docker-version:
	docker run -p $(HOST_PORT):8080 --env APP_DELAY=$(APP_DELAY) --env APP_BGCOLOR=$(APP_BGCOLOR) --env APP_NO_CSS=$(APP_NO_CSS) $(DOCKER_FLAGS) $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) poetry version

.PHONY: docker-publish
docker-publish:
	./docker-publish.sh
