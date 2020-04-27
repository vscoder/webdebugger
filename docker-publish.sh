#!/bin/bash
set -eu

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKER_IMAGE_NAME}:${TRAVIS_TAG}-${TRAVIS_BUILD_NUMBER}
docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKER_IMAGE_NAME}:latest
docker push ${DOCKER_IMAGE_NAME}:${TRAVIS_TAG}-${TRAVIS_BUILD_NUMBER}
docker push ${DOCKER_IMAGE_NAME}:latest
