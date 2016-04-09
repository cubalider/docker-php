FROM php:fpm

WORKDIR /var/www/public

COPY php.ini /usr/local/etc/php/

RUN apt-get update

# Mcrypt extension
RUN apt-get install -y libmcrypt-dev
RUN docker-php-ext-install mcrypt

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
RUN php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
RUN php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '7228c001f88bee97506740ef0888240bd8a760b046ee16db8f4095c0d8d525f2367663f22a46b48d072c816e7fe19959') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Needed for composer
RUN apt-get install -y git

# Needed to run php tasks
RUN apt-get install -y git cron
RUN service cron start

# Permissions
RUN usermod -u 1000 www-data
RUN chown -R www-data:www-data /var/www/app/cache
RUN chown -R www-data:www-data /var/www/app/logs

# Needed to edit files
RUN export TERM=xterm
