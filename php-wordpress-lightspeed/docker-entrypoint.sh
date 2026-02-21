#!/bin/bash
set -e
DOCROOT="/var/www/vhosts/localhost/html"
WPCONTENT="${DOCROOT}/wp-content"
PAAS_DATA="/app/data"

# On OrbitLab PaaS, persistent volume at /app/data. Symlink the entire WordPress docroot there so
# the app can write .htaccess, wp-config, and any core files; uploads/plugins/themes persist too.
if [ -d "$PAAS_DATA" ] && [ -w "$PAAS_DATA" ]; then
  WP_VOLUME="${PAAS_DATA}/wordpress"
  if [ ! -d "$WP_VOLUME" ] || [ -z "$(ls -A "$WP_VOLUME" 2>/dev/null)" ]; then
    cp -a /var/www/vhosts/localhost/html "$WP_VOLUME"
  fi
  if [ -e "$DOCROOT" ] && [ ! -L "$DOCROOT" ]; then
    rm -rf "$DOCROOT"
  fi
  if [ ! -L "$DOCROOT" ]; then
    ln -s "$WP_VOLUME" "$DOCROOT"
  fi
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

# OpenLiteSpeed: enable rewrite and .htaccess so WordPress pretty permalinks work (no index.php in URL).
# Without this, only requests to /index.php?... work; pretty URLs 404.
for vhconf in /usr/local/lsws/conf/vhosts/localhost/vhconf.conf /usr/local/lsws/conf/vhosts/localhost/vhost.conf; do
  if [ -f "$vhconf" ]; then
    # Turn rewrite on and enable loading .htaccess (Apache-style rules)
    sed -i.bak -E 's/^([[:space:]]*enable)[[:space:]]+0/\1                  1/' "$vhconf"
    sed -i -E 's/^([[:space:]]*autoLoadHtaccess)[[:space:]]+0/\1        1/' "$vhconf"
    if ! grep -q 'autoLoadHtaccess' "$vhconf"; then
      sed -i -E '/^[[:space:]]*enable[[:space:]]+1/a\
  autoLoadHtaccess        1' "$vhconf" 2>/dev/null || true
    fi
    # If vhost has no rewrite block at all, append one
    if ! grep -qE 'rewrite[[:space:]]*\{' "$vhconf"; then
      cat >> "$vhconf" << 'REWRITEEOF'

rewrite {
  enable                  1
  autoLoadHtaccess        1
}
REWRITEEOF
    fi
    break
  fi
done

exec "$@"
