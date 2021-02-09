#!/usr/bin/env bash
set -euo pipefail

echo $TRAVIS_TAG > VERSION
echo $TRAVIS_COMMIT > REVISION

for required_dependency in yq
do
  type $required_dependency > /dev/null
done

# Add any additional options you need as an environment variable named DOCKER_BUILD_OPTIONS
echo "$DOCKER_PASSWORD" | docker login -u travisci --password-stdin venuenext-docker.jfrog.io
docker build -f ./Dockerfile ${DOCKER_BUILD_OPTIONS:-} -t venuenext-docker.jfrog.io/eksutils:${TRAVIS_TAG} .
docker push venuenext-docker.jfrog.io/eksutils:${TRAVIS_TAG}
