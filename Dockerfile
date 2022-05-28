# ubuntuイメージを利用する
FROM ubuntu:20.04

RUN apt-get update

# タイムゾーンのセット
RUN apt-get install -y tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# wget,gnupg,zipのインストール
RUN apt-get -y install wget gnupg zip unzip

# seleniumのインストール
RUN apt-get install -y nodejs npm

RUN npm install --global yarn
RUN yarn global add selenium-side-runner

# Chromeが2022.05.24 102.0.5005.61がリリースされたため動かない by 2022.05.27
# nodejsがchromedriver@102.0.5005.61に対応されたら有効にする最新にする
#RUN cd /usr/local/lib/; wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#RUN apt-get -y install /usr/local/lib/google-chrome-stable_current_amd64.deb
#RUN yarn global add chromedriver

#COPY packages/google-chrome-stable_102_0_5005_61_amd64.deb /usr/local/lib/
#RUN apt-get -y install /usr/local/lib/google-chrome-stable_102_0_5005_61_amd64.deb

COPY packages/google-chrome-stable_71_0_3578_80_amd64.deb /usr/local/lib/
RUN apt-get -y install /usr/local/lib/google-chrome-stable_71_0_3578_80_amd64.deb

COPY packages/chromedriver /usr/local/lib/chromedriver
RUN cd /usr/local/lib/chromedriver; yarn
RUN cd /usr/local/bin; ln -s ../lib/chromedriver/bin/chromedriver

#RUN npm install -g geckodriver --unsafe-perm=true --allow-root