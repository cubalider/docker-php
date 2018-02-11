FROM php:7.2.2-fpm-alpine3.7

RUN apk update

RUN apk add --no-cache \
    # Needed for intl extension
    icu-dev \
    # Needed for zip extension
    zlib-dev \
    # Needed for xdebug
    g++ make autoconf \
    # Needed for mongodb
    openssl-dev pcre-dev

RUN docker-php-ext-install intl bcmath zip pdo_mysql

# Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Mongodb
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Gd
RUN apk add --no-cache \
    freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev
RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
RUN apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev
