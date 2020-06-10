FROM node:12.16.3-buster-slim
LABEL maintainer='Huy Dang <theguest268@gmail.com>'

# Installs git, unoconv and Japanese fonts
RUN apt-get update && apt-get -y install \
    apt-utils \
    locales \
    git \
    unoconv=0.7-1.1 \
    # ttf-wqy-zenhei \
    # fonts-arphic-ukai \
    # fonts-arphic-uming \
    # fonts-indic \
    fonts-takao \
    fonts-ipafont \
    fonts-ipaexfont \
    fonts-mona \
    # fonts-vlgothic \
    fonts-unfonts-core \
    # fonts-noto-cjk \
    # fonts-noto-cjk-extra \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get -qyy clean

# Install locale
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# Clone the repo
RUN git clone https://github.com/zrrrzzt/tfk-api-unoconv.git unoconvservice

# Change working directory
WORKDIR /unoconvservice

# Install dependencies
RUN npm install --production

# Env variables
ENV SERVER_PORT 3000
ENV PAYLOAD_MAX_SIZE 1048576
ENV TIMEOUT_SERVER 120000
ENV TIMEOUT_SOCKET 140000

# Expose 3000
EXPOSE 3000

# Startup
ENTRYPOINT /usr/bin/unoconv --listener --server=0.0.0.0 --port=2002 & node standalone.js