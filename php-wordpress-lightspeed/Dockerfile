# Orbit Lab — PHP (LiteSpeed) + WordPress
# WordPress is installed in the image; wp-config.php is generated at startup from env.

FROM litespeedtech/litespeed:latest

# Install curl for downloading WordPress
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV DOCUMENT_ROOT=/var/www/vhosts/localhost/html
WORKDIR /var/www/vhosts

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

EXPOSE 7080 7443
