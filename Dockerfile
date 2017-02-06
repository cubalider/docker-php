FROM php:7.1.1-fpm-alpine

RUN apk add --no-cache \
    # Needed for mcrypt extension
    libmcrypt-dev \
    # Needed for intl extension
    icu-dev \
    # Needed for zip extension
    zlib-dev \
    # Needed for xdebug
    g++ make autoconf \
    # Needed for mongodb
    openssl-dev

RUN docker-php-ext-install mcrypt intl bcmath zip pdo_mysql

# Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Mongodb
RUN pecl install mongodb && docker-php-ext-enable mongodb
