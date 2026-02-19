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
  chown nobody:nogroup "${DOCROOT}/wp-config.php"
fi

exec "$@"
