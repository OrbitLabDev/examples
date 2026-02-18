# PHP + WordPress on LiteSpeed

Orbit Lab example: **WordPress** on **LiteSpeed** (litespeedtech/litespeed) with **MariaDB**. WordPress is installed in the image; `wp-config.php` is generated at startup from `MYSQL_*` env vars.

## Contents

- `Dockerfile` – LiteSpeed image + WordPress install
- `docker-entrypoint.sh` – generates `wp-config.php` from env
- `docker-compose.litespeed.yml` – db + litespeed services
- `.env.example` – copy to `.env` and set `MYSQL_*`

## Usage

```bash
cp .env.example .env
# Edit .env and set MYSQL_ROOT_PASSWORD, MYSQL_PASSWORD, etc.
docker compose -f docker-compose.litespeed.yml up -d
```

- HTTP: port `7080` (or `HTTP_PORT` from `.env`, default 8080)
- HTTPS: port `7443` (or `HTTPS_PORT`, default 8443)

Then open the site and complete the WordPress setup wizard in the browser.
