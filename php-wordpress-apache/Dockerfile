# Orbit Lab — PHP (Apache) + WordPress
# WordPress is installed in the image; wp-config.php is generated at startup from env.

FROM php:8.2-apache

# Install system deps and PHP extensions for WordPress
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    ca-certificates \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    mysqli pdo pdo_mysql zip gd mbstring exif intl opcache \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite for WordPress permalinks
RUN a2enmod rewrite

ENV APACHE_DOCUMENT_ROOT=/var/www/html
WORKDIR /var/www/html

# Download and install WordPress
ARG WORDPRESS_VERSION=6.7.2
RUN curl -sSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" | tar -xzf - -C /var/www \
    && mv /var/www/wordpress/* /var/www/html/ \
    && rmdir /var/www/wordpress \
    && chown -R www-data:www-data /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

EXPOSE 80
