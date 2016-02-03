FROM ubuntu:14.04

MAINTAINER Yannick Pereira-Reis <yannick.pereira.reis@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install common libs
RUN apt-get update && apt-get install -y --no-install-recommends \
	nano \
	git \
	curl \
	wget \
	supervisor \
	build-essential \
	software-properties-common \
	python-software-properties

RUN apt-get update
RUN add-apt-repository -y ppa:ondrej/php5
RUN add-apt-repository -y ppa:nginx/stable

RUN apt-get update && apt-get install -y --force-yes --no-install-recommends \
	php5 \
	php5-mcrypt \
	php5-tidy \
	php5-cli \
	php5-common \
	php5-curl \
	php5-intl \
	php5-fpm \
	php-apc \
	nginx \
	ssh \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini


RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

ADD nginx/default   /etc/nginx/sites-available/default

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs
RUN npm install express \
                serve-static

# Install ssh key
RUN mkdir -p /root/.ssh/
RUN touch /root/.ssh/known_hosts

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Satis and Satisfy
RUN composer create-project playbloom/satisfy --stability=dev

ADD scripts /app/scripts

ADD scripts/crontab /etc/cron.d/satis-cron
RUN chmod 0644 /etc/cron.d/satis-cron
RUN touch /var/log/satis-cron.log

ADD config.json /app/config.json
RUN chmod 777 /app/config.json

ADD server.js /app/server.js
RUN chmod 777 /app/server.js

ADD config.php /satisfy/app/config.php
RUN chmod -R 777 /satisfy

ADD supervisor/0-install.conf /etc/supervisor/conf.d/0-install.conf
ADD supervisor/1-cron.conf /etc/supervisor/conf.d/1-cron.conf
ADD supervisor/2-nginx.conf /etc/supervisor/conf.d/2-nginx.conf
ADD supervisor/3-php.conf /etc/supervisor/conf.d/3-php.conf
ADD supervisor/4-node.conf /etc/supervisor/conf.d/4-node.conf

RUN chmod +x /app/scripts/startup.sh

WORKDIR /app

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

EXPOSE 80
EXPOSE 443
