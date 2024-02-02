#!/bin/bash -ex

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

if [ "${DOCKER_VERSION}" = "" -o "${CHROME_VERSION}" = "" ]; then
  echo "Invalid arguments."
  echo "bash ${0} <docker_version> <chrome_version>"
  exit 1
fi
CHROMEDRIVER_VERSION=${CHROME_VERSION%%-*}

cd $SCRIPT_DIR/packages
if [ ! -f google-chrome-stable_${CHROME_VERSION}_amd64.deb ]; then
	wget --no-check-certificate https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb
fi
if [ ! -f chromedriver_${CHROMEDRIVER_VERSION}_linux64.zip ]; then
	major=${CHROMEDRIVER_VERSION%%.*}
	if [ "$major" = "114" ]; then
		wget --no-check-certificate -O chromedriver_${CHROMEDRIVER_VERSION}_linux64.zip \
			https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip
	else
		wget --no-check-certificate -O chromedriver_${CHROMEDRIVER_VERSION}_linux64.zip \
			https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROMEDRIVER_VERSION}/linux64/chromedriver-linux64.zip
	fi
fi

cd $SCRIPT_DIR

if [ ! "${DOCKER_USER}" = "" -a ! "${DOCKER_PASS}" = "" ]; then
  docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
else
  docker login
fi

docker build -t selenium-side-runner-chrome \
--build-arg CHROME_VERSION=${CHROME_VERSION} \
--build-arg CHROMEDRIVER_VERSION=${CHROMEDRIVER_VERSION} .
docker tag selenium-side-runner-chrome:latest nakazii/selenium-side-runner-chrome:${DOCKER_VERSION}

docker push nakazii/selenium-side-runner-chrome:${DOCKER_VERSION}

docker image rm -f nakazii/selenium-side-runner-chrome
docker image rm -f selenium-side-runner-chrome

yes | docker system prune --volumes
yes | docker builder prune
