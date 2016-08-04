FROM php:fpm

WORKDIR /var/www/public

COPY php.ini /usr/local/etc/php/

RUN apt-get update

# Mysql
RUN docker-php-ext-install pdo_mysql

# Mcrypt extension
RUN apt-get install -y libmcrypt-dev
RUN docker-php-ext-install mcrypt

# Intl extension
RUN apt-get install -y libicu-dev
RUN docker-php-ext-install intl

# Bcmath extension
RUN docker-php-ext-install bcmath

# Mbstring extension
# TODO: Ya esta extension esta anadida por defecto
RUN docker-php-ext-install mbstring

# Zip extension
RUN apt-get install -y libssl-dev
RUN docker-php-ext-install zip

# Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Mongodb
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"

# Needed for composer
RUN apt-get install -y git

# Needed to run php tasks
RUN apt-get install -y git cron
RUN service cron start

# Permissions
RUN usermod -u 1000 www-data

# Needed to edit files
RUN export TERM=xterm
