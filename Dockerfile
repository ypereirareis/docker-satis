FROM ubuntu:14.04

MAINTAINER Yannick Pereira-Reis <yannick.pereira.reis@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install common libs
RUN apt-get update && apt-get install -y \
	nano \
	git \
	curl \
	wget \
	build-essential \
	software-properties-common \
	python-software-properties

RUN apt-get update
RUN add-apt-repository -y ppa:ondrej/php5
RUN add-apt-repository -y ppa:nginx/stable

RUN apt-get update && apt-get install -y --force-yes \
	php5 \
	php5-mcrypt \
	php5-tidy \
	php5-cli \
	php5-common \
	php5-curl \
	php5-intl \
	php5-fpm \
	php-apc

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini

RUN apt-get install -y --force-yes nginx

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
RUN ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Display version information
RUN php --version
RUN composer --version

# Install Satis and Satisfy
RUN composer create-project composer/satis --stability=dev --keep-vcs
RUN git clone https://github.com/ypereirareis/satisfy.git && composer install --working-dir=satisfy

ADD scripts/crontab /etc/cron.d/satis-cron
RUN chmod 0644 /etc/cron.d/satis-cron
RUN touch /var/log/satis-cron.log

ADD config.php /satisfy/app/config.php
RUN chmod -R 777 /satisfy

VOLUME ["/app"]

WORKDIR /app

CMD ["/bin/bash", "./scripts/startup.sh"]

EXPOSE 80
EXPOSE 443
