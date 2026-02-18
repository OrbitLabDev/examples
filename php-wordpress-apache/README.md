# PHP + WordPress on Apache

Orbit Lab example: **WordPress** on **Apache** (PHP 8.2) with **MariaDB**. WordPress is installed in the image; `wp-config.php` is generated at startup from `MYSQL_*` env vars.

## Contents

- `Dockerfile` – PHP Apache image + WordPress install
- `docker-entrypoint.sh` – generates `wp-config.php` from env
- `docker-compose.apache.yml` – db + apache services
- `.env.example` – copy to `.env` and set `MYSQL_*`

## Usage

```bash
cp .env.example .env
# Edit .env and set MYSQL_ROOT_PASSWORD, MYSQL_PASSWORD, etc.
docker compose -f docker-compose.apache.yml up -d
```

- HTTP: port 80 in container (mapped to `HTTP_PORT` from `.env`, default 8080)

Then open the site and complete the WordPress setup wizard in the browser.
