#!/bin/bash -ex

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

if [ "${DOCKER_VERSION}" = "" -o "${CHROME_VERSION}" = "" ]; then
  echo "Invalid arguments."
  echo "bash ${0} <docker_version> <chrome_version>"
  exit 1
fi

cd $SCRIPT_DIR/package
if [ ! -f google-chrome-stable_${CHROME_VERSION}_amd64.deb ]; then
	wget --no-check-certificate https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb
fi

cd $SCRIPT_DIR

if [ ! "${DOCKER_USER}" = "" -a ! "${DOCKER_PASS}" = "" ]; then
  docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
else
  docker login
fi

docker build -t selenium-side-runner-chrome --build-arg CHROME_VERSION=${CHROME_VERSION} .
docker tag selenium-side-runner-chrome:latest nakazii/selenium-side-runner-chrome:${DOCKER_VERSION}

docker push nakazii/selenium-side-runner-chrome:${DOCKER_VERSION}

docker image rm -f nakazii/selenium-side-runner-chrome
docker image rm -f selenium-side-runner-chrome

yes | docker system prune --volumes
yes | docker builder prune
