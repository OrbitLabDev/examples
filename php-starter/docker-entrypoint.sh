#!/bin/bash
set -e

DOCROOT="/var/www/vhosts/localhost/html"

# Ensure correct ownership
chown -R nobody:nogroup "$DOCROOT"

echo "[php-starter] Starting OpenLiteSpeed…"
exec "$@"
