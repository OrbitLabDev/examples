#!/bin/bash
set -e
DOCROOT="/var/www/html"

# Generate wp-config.php from env (MYSQL_* from compose)
if [ ! -f "${DOCROOT}/wp-config.php" ]; then
  WP_KEY=$(curl -sSL https://api.wordpress.org/secret-key/1.1/salt/)
  cat > "${DOCROOT}/wp-config.php" << EOF
<?php
define('DB_NAME', '${MYSQL_DATABASE:-wordpress}');
define('DB_USER', '${MYSQL_USER:-wpuser}');
define('DB_PASSWORD', '${MYSQL_PASSWORD:-wppass}');
define('DB_HOST', '${MYSQL_HOST:-db}');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');
\$table_prefix = 'wp_';
${WP_KEY}
define('WP_DEBUG', false);
if ( ! defined( 'ABSPATH' ) ) { define( 'ABSPATH', __DIR__ . '/' ); }
require_once ABSPATH . 'wp-settings.php';
EOF
  chown www-data:www-data "${DOCROOT}/wp-config.php"
fi

exec "$@"
