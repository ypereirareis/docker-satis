FROM ubuntu:14.04

MAINTAINER Yannick Pereira-Reis <yannick.pereira.reis@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

# Install common libs
RUN apt-get update && apt-get install -y \
	 git \
	curl \
	wget \
	php5 \
	php5-cli \
	php5-common \
	php5-curl

RUN mkdir -p RUN mkdir /root/.ssh/

RUN touch /root/.ssh/known_hosts

RUN ssh-keyscan -t rsa gitlab.kptivestudio.com >> /root/.ssh/known_hosts

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Display version information
RUN php --version
RUN composer --version

RUN  composer create-project composer/satis --stability=dev --keep-vcs

VOLUME ["/app"]

WORKDIR /app

CMD ["/bin/bash", "./startup.sh"]
