FROM php:7.4-apache
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
        zsh \
        sendmail-bin \
        sendmail \
        sendmail-cf \
        m4

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

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

RUN composer global init

# Enable Apache mod_rewrite
RUN a2enmod rewrite
RUN a2enmod headers

# Server configuration overrides
ADD config/httpd.conf /etc/apache2/sites-available/000-default.conf
ADD ./config/php.ini /usr/local/etc/php/conf.d/custom.ini

# Configure composer
RUN export COMPOSER_ALLOW_SUPERUSER=1 \
  && composer global init \
  && composer global require hirak/prestissimo

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
ADD dotfiles/* /root/
ADD config/php.ini /usr/local/etc/php/conf.d/custom.ini

ENV TERM xterm-256color
ENV POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD true
