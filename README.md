selenium-side-runner
=======

# DockerHubにイメージをPushする

````
docker login
#  login: nakazii
#  pass : _______

docker image rm -f nakazii/selenium-side-runner-chrome
docker image rm -f selenium-side-runner-chrome
docker build . -t selenium-side-runner-chrome
docker tag selenium-side-runner-chrome:latest nakazii/selenium-side-runner-chrome:102.0.0

docker push nakazii/selenium-side-runner-chrome:102.0.0
````
