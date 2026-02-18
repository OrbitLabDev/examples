# PHP + WordPress on Apache
# For use with OrbitLab.dev or any container-based deployment

FROM php:8.2-apache

# Install system deps and PHP extensions for WordPress
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    mysqli pdo pdo_mysql zip gd mbstring exif intl opcache \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite for WordPress permalinks
RUN a2enmod rewrite

ENV APACHE_DOCUMENT_ROOT=/var/www/html
WORKDIR /var/www/html

# Optional: add WordPress or mount at runtime
# COPY . /var/www/html/

EXPOSE 80
