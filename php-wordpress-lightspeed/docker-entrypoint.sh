#!/bin/bash
set -e
DOCROOT="/var/www/vhosts/localhost/html"
WPCONTENT="${DOCROOT}/wp-content"
PAAS_DATA="/app/data"

# On OrbitLab PaaS, persistent volume is mounted at /app/data. Point uploads (and plugins/themes) there.
if [ -d "$PAAS_DATA" ] && [ -w "$PAAS_DATA" ]; then
  for dir in uploads plugins themes; do
    mkdir -p "${PAAS_DATA}/${dir}"
    if [ "$dir" != "uploads" ] && [ -d "${WPCONTENT}/${dir}" ] && [ -z "$(ls -A "${PAAS_DATA}/${dir}" 2>/dev/null)" ]; then
      cp -an "${WPCONTENT}/${dir}/." "${PAAS_DATA}/${dir}/"
    fi
    if [ -e "${WPCONTENT}/${dir}" ] && [ ! -L "${WPCONTENT}/${dir}" ]; then
      rm -rf "${WPCONTENT}/${dir}"
    fi
    if [ ! -L "${WPCONTENT}/${dir}" ]; then
      ln -s "${PAAS_DATA}/${dir}" "${WPCONTENT}/${dir}"
    fi
  done
  chown -R nobody:nogroup "$PAAS_DATA"
fi

# Generate wp-config.php from env (MYSQL_* from compose or from OrbitLab PaaS project env)
if [ ! -f "${DOCROOT}/wp-config.php" ]; then
  # Fetch WordPress salts; in PaaS (isolated network) DNS may be unavailable, so fall back to placeholders
  WP_KEY=$(curl -sSL --connect-timeout 5 https://api.wordpress.org/secret-key/1.1/salt/ 2>/dev/null) || true
  if [ -z "$WP_KEY" ]; then
    WP_KEY="define('AUTH_KEY',         '$(openssl rand -base64 24)');
define('SECURE_AUTH_KEY',  '$(openssl rand -base64 24)');
define('LOGGED_IN_KEY',    '$(openssl rand -base64 24)');
define('NONCE_KEY',        '$(openssl rand -base64 24)');
define('AUTH_SALT',        '$(openssl rand -base64 24)');
define('SECURE_AUTH_SALT', '$(openssl rand -base64 24)');
define('LOGGED_IN_SALT',   '$(openssl rand -base64 24)');
define('NONCE_SALT',       '$(openssl rand -base64 24)');"
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
${WP_KEY}
define('WP_DEBUG', false);
if ( ! defined( 'ABSPATH' ) ) { define( 'ABSPATH', __DIR__ . '/' ); }
require_once ABSPATH . 'wp-settings.php';
EOF
  chown nobody:nogroup "${DOCROOT}/wp-config.php"
fi

exec "$@"
