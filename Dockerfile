FROM php:8.0.0RC5-apache
MAINTAINER Cory Collier <cory@mck7.io>

RUN apt -y update \
    && apt -y upgrade \
    && apt -y install \
        libpng-dev \
        libgmp-dev \
        zlib1g-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libxslt-dev \
        libjpeg-dev \
        libcurl4 \
        libzip-dev \
        less \
        vim \
        curl \
        rsync \
        git \
        ca-certificates \
        sqlite3 \
        libsqlite3-dev \
        less \
        zsh

# Add all of the php specific packages
RUN docker-php-source extract \
    && docker-php-ext-configure gd \
        --with-freetype=/usr/include/ \
        --with-jpeg=/usr/include/ \
        --enable-gd-jis-conv \
    && docker-php-ext-install \
        gmp \
        bcmath \
        exif \
        gd \
        mysqli \
        pcntl \
        pdo \
        pdo_mysql \
        pdo_sqlite \
        xsl \
        zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite headers

# Server configuration overrides
ADD config/httpd.conf /etc/apache2/sites-available/000-default.conf
ADD ./config/php.ini /usr/local/etc/php/conf.d/custom.ini

# Shell stuff
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
ADD dotfiles/* /root/

ENV TERM xterm-256color
ENV POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD true

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

RUN pecl install xdebug
