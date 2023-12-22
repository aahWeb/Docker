FROM php:8.3-apache

# On peut également modifier les PATH
ENV PATH "$PATH:/root/.composer/vendor/bin"

# PDO 
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Composer
RUN apt-get update && apt-get install -y zip unzip
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installation de PsySH
RUN composer global require psy/psysh:@stable