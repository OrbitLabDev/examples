# Orbit Lab — PHP Starter (OpenLiteSpeed)
# A minimal PHP application on OpenLiteSpeed. No database required.

FROM litespeedtech/openlitespeed:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    php-cli \
    php-curl \
    php-json \
    php-mbstring \
    && rm -rf /var/lib/apt/lists/*

ENV DOCUMENT_ROOT=/var/www/vhosts/localhost/html
WORKDIR /var/www/vhosts

# Remove default content and copy application files
RUN rm -rf localhost/html
COPY public/ localhost/html/
RUN chown -R nobody:nogroup localhost/html

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/local/lsws/bin/lswsctrl", "start"]

EXPOSE 7080 80 443
