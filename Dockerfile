FROM ubuntu:15.10

MAINTAINER Yannick Pereira-Reis <yannick.pereira.reis@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --force-yes --no-install-recommends \
	build-essential \
	software-properties-common \
	cron \
	nano \
	git \
	curl \
	supervisor \
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
	npm \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini \
	&& sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini \
	&& echo "daemon off;" >> /etc/nginx/nginx.conf \
	&& sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf \
	&& sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

ADD nginx/default   /etc/nginx/sites-available/default

# Install nodejs
RUN npm install express serve-static

# Install ssh key
RUN mkdir -p /root/.ssh/ && touch /root/.ssh/known_hosts

# Install Composer
# Install prestissimo
# Install Satis and Satisfy
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
	&& /usr/local/bin/composer global require hirak/prestissimo \
	&& /usr/local/bin/composer create-project playbloom/satisfy:dev-master --stability=dev \
	&& chmod -R 777 /satisfy \
	&& rm -rf /root/.composer/cache/*

ADD scripts /app/scripts

ADD scripts/crontab /etc/cron.d/satis-cron
ADD config.json /app/config.json
ADD server.js /app/server.js
ADD config.php /satisfy/app/config.php

RUN chmod 0644 /etc/cron.d/satis-cron \
	&& touch /var/log/satis-cron.log \
	&& chmod 777 /app/config.json \
	&& chmod 777 /app/server.js \
	&& chmod +x /app/scripts/startup.sh

ADD supervisor/0-install.conf /etc/supervisor/conf.d/0-install.conf
ADD supervisor/1-cron.conf /etc/supervisor/conf.d/1-cron.conf
ADD supervisor/2-nginx.conf /etc/supervisor/conf.d/2-nginx.conf
ADD supervisor/3-php.conf /etc/supervisor/conf.d/3-php.conf
ADD supervisor/4-node.conf /etc/supervisor/conf.d/4-node.conf

WORKDIR /app

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

EXPOSE 80
EXPOSE 443

