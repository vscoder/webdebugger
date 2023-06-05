#!/bin/bash
set -eux

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKER_IMAGE_NAME}:latest
docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
docker push ${DOCKER_IMAGE_NAME}:latest
