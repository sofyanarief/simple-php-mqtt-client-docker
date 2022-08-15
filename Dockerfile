FROM debian:buster-slim

LABEL description="Simple PHP-MQTT Client Build With PHP 7 & SQLite For Storing Subscibed MQTT Topics"
MAINTAINER Sofyan Arief <sofyan.89@gmail.com>

RUN echo "deb http://kebo.pens.ac.id/debian/ buster main contrib non-free" > /etc/apt/sources.list
RUN echo "deb http://kebo.pens.ac.id/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://kebo.pens.ac.id/debian-security/ buster/updates main contrib non-free" >> /etc/apt/sources.list

RUN apt update
RUN apt install -y curl wget gnupg2 ca-certificates lsb-release apt-transport-https
RUN apt install -y lsb-release apt-transport-https ca-certificates wget
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/sury-php-repo.list
RUN apt update
RUN apt install -y apache2 libapache2-mod-php7.4 libapache2-mod-fcgid php7.4 php7.4-fpm php7.4-opcache php7.4-curl php7.4-common php7.4-cli php7.4-mbstring php7.4-sqlite3 git curl wget zip unzip sqlite3 supervisor nano
RUn a2enmod actions fcgid alias proxy_fcgi

RUN rm /etc/apache2/sites-available/000-default.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

RUN service php7.4-fpm start
RUN mkdir -p /var/www/php-mqtt-client

RUN cd /var/www/php-mqtt-client && git clone https://github.com/sofyanarief/simple-php-mqtt-client.git .
RUN cd /var/www/php-mqtt-client && composer require php-mqtt/client && composer install

COPY mqtt-client-subs.sh /var/www/php-mqtt-client/mqtt-client-subs.sh

RUN mkdir -p /var/www/php-mqtt-client/app
COPY index.php /var/www/php-mqtt-client/index.php

WORKDIR /var/www/php-mqtt-client

RUN chown www-data:www-data -R /var/www/php-mqtt-client
RUN chmod +x /var/www/php-mqtt-client/mqtt-client-subs.sh

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
