FROM php:5.6
MAINTAINER Michał Mleczko <michal.mleczko@connectmedica.com>

RUN apt-get update && apt-get install -y php5-mysql php5-odbc mysql-client zlib1g-dev libmcrypt-dev libicu-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure intl && \
    docker-php-ext-install -j$(nproc) zip mysql mysqli pdo pdo_mysql mcrypt mbstring opcache intl

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Install Xdebug
RUN curl -fsSL 'https://xdebug.org/files/xdebug-2.4.0.tgz' -o xdebug.tar.gz \
    && mkdir -p xdebug \
    && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
    && rm xdebug.tar.gz \
    && ( \
    cd xdebug \
    && phpize \
    && ./configure --enable-xdebug \
    && make -j$(nproc) \
    && make install \
    ) \
    && rm -r xdebug \
    && docker-php-ext-enable xdebug

RUN echo "date.timezone=Europe/Warsaw" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini
