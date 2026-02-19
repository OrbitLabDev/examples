# Orbit Lab — PHP (OpenLiteSpeed) + WordPress
# Open-source LiteSpeed; no license key required. WordPress in image; wp-config.php generated at startup from env.

FROM litespeedtech/openlitespeed:latest

# Install deps for downloading WordPress + running WP-CLI
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    php-cli \
    php-mysql \
    && rm -rf /var/lib/apt/lists/*

ENV DOCUMENT_ROOT=/var/www/vhosts/localhost/html
WORKDIR /var/www/vhosts

# Install WP-CLI (used by the platform for managed operations)
RUN curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp \
    && wp --info --allow-root

# Download and install WordPress (remove base image's html so WordPress ends up at html/, not html/wordpress/)
ARG WORDPRESS_VERSION=6.7.2
RUN rm -rf localhost/html \
    && curl -sSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" | tar -xzf - -C /tmp \
    && mv /tmp/wordpress localhost/html \
    && chown -R nobody:nogroup localhost/html

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/local/lsws/bin/lswsctrl", "start"]

EXPOSE 7080 80 443
