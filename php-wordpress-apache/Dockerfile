# Orbit Lab — PHP (Apache) + WordPress
# WordPress is installed in the image; wp-config.php is generated at startup from env.

FROM php:8.2-apache-bookworm

# Install system deps and PHP extensions for WordPress
# zlib1g-dev required for gd; libjpeg62-turbo-dev is the Debian package for JPEG support
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev \
    zlib1g-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    ca-certificates \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    mysqli pdo pdo_mysql zip gd mbstring exif intl opcache \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI (used by the platform for managed operations)
RUN curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp \
    && wp --info --allow-root

# Enable Apache rewrite and .htaccess for WordPress permalinks
RUN a2enmod rewrite
COPY wordpress-allowoverride.conf /etc/apache2/conf-available/
RUN a2enconf wordpress-allowoverride

ENV APACHE_DOCUMENT_ROOT=/var/www/html
WORKDIR /var/www/html

# Download and install WordPress (clear default docroot so WordPress is the only content)
ARG WORDPRESS_VERSION=6.7.2
RUN find /var/www/html -mindepth 1 -delete 2>/dev/null || true \
    && curl -sSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" | tar -xzf - -C /var/www \
    && mv /var/www/wordpress/* /var/www/html/ \
    && rmdir /var/www/wordpress \
    && chown -R www-data:www-data /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

EXPOSE 80
