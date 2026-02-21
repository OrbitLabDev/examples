#!/bin/bash
set -e
DOCROOT="/var/www/html"
WPCONTENT="${DOCROOT}/wp-content"
PAAS_DATA="/app/data"

# On OrbitLab PaaS, persistent volume at /app/data. Symlink the entire WordPress docroot there so
# the app can write .htaccess, wp-config, and any core files; uploads/plugins/themes persist too.
# Trade-off: redeploying a new image does not update WordPress core; use "wp core update" or Admin > Updates.
if [ -d "$PAAS_DATA" ] && [ -w "$PAAS_DATA" ]; then
  WP_VOLUME="${PAAS_DATA}/wordpress"
  if [ ! -d "$WP_VOLUME" ] || [ -z "$(ls -A "$WP_VOLUME" 2>/dev/null)" ]; then
    cp -a /var/www/html "$WP_VOLUME"
  fi
  if [ -e "$DOCROOT" ] && [ ! -L "$DOCROOT" ]; then
    rm -rf "$DOCROOT"
  fi
  if [ ! -L "$DOCROOT" ]; then
    ln -s "$WP_VOLUME" "$DOCROOT"
  fi
  chown -R www-data:www-data "$PAAS_DATA"
fi

# Generate wp-config.php from env (MYSQL_* from compose or from OrbitLab PaaS project env)
if [ ! -f "${DOCROOT}/wp-config.php" ]; then
  # WordPress salts: must be set via env (WP_SALTS = full block of define('AUTH_KEY',...); lines)
  if [ -z "${WP_SALTS:-}" ]; then
    echo "Error: set WP_SALTS (full block of define('AUTH_KEY', ...); lines from api.wordpress.org/secret-key/1.1/salt/ or wp-config.php)" >&2
    exit 1
  fi
  cat > "${DOCROOT}/wp-config.php" << EOF
<?php
define('DB_NAME', '${MYSQL_DATABASE:-wordpress}');
define('DB_USER', '${MYSQL_USER:-wpuser}');
define('DB_PASSWORD', '${MYSQL_PASSWORD:-wppass}');
define('DB_HOST', '${MYSQL_HOST:-db}:${MYSQL_PORT:-3306}');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');
\$table_prefix = 'wp_';
${WP_SALTS}
define('WP_DEBUG', false);
if ( ! defined( 'ABSPATH' ) ) { define( 'ABSPATH', __DIR__ . '/' ); }
require_once ABSPATH . 'wp-settings.php';
EOF
  chown www-data:www-data "${DOCROOT}/wp-config.php"
fi

exec "$@"
