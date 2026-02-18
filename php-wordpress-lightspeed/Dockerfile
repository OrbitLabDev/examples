# PHP + WordPress on LiteSpeed (OpenLiteSpeed)
# For use with OrbitLab.dev or any container-based deployment

FROM litespeedtech/openlitespeed:latest

# Install PHP and common WordPress dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    php \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-zip \
    php-intl \
    && rm -rf /var/lib/apt/lists/*

# Document root for WordPress
ENV DOCUMENT_ROOT=/var/www/vhosts/localhost/html

# Optional: add WordPress or mount at runtime
# COPY . ${DOCUMENT_ROOT}/

EXPOSE 80 7080
