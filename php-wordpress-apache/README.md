# PHP + WordPress on Apache

Orbit Lab example: **WordPress** on **Apache** (PHP 8.2). WordPress is installed in the image; `wp-config.php` is generated at startup from `MYSQL_*` env vars. The database is **OrbitLab shared MySQL** (provisioned via API); no DB container.

## Contents

- `Dockerfile` – PHP Apache image + WordPress install
- `docker-entrypoint.sh` – generates `wp-config.php` from env
- `docker-compose.apache.yml` – app only (set `MYSQL_*` in .env from OrbitLab or external MySQL)
- `.env.example` – copy to `.env` and set `MYSQL_*`

## Local run (with OrbitLab or external MySQL)

1. Provision a MySQL database (e.g. OrbitLab: `POST /database` with `{ "userId", "type": "mysql" }`). The API returns `host`, `port`, `database`, `user`, `password`.
2. Copy env and set DB connection:

```bash
cp .env.example .env
# Set MYSQL_HOST, MYSQL_PORT, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD (from POST /database or your MySQL)
docker compose -f docker-compose.apache.yml up -d
```

- HTTP: port 80 in container (mapped to `HTTP_PORT`, default 8080). Open the site and complete the WordPress setup wizard in the browser.

## OrbitLab PaaS

On OrbitLab you deploy **only the app image**; the database is provisioned via the API and injected as project env.

1. Create a project and (if needed) a domain.
2. Provision a MySQL database: `POST /database` with `{ "userId", "type": "mysql" }`. The API returns `host`, `port`, `database`, `user`, `password` (and `connectionString`).
3. Set project env from the response: `PUT /project/:id/env` with:
   - `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`
4. Deploy the app. The container receives the env and connects to the shared MySQL.

The PaaS mounts a persistent volume at **`/app/data`** in the container. The entrypoint uses it for WordPress **uploads**, **plugins**, and **themes** (symlinks `wp-content/uploads`, `wp-content/plugins`, `wp-content/themes` → `/app/data/...`) so media and user-installed plugins/themes persist across deploys. If `/app/data` is not present (e.g. local compose), WordPress uses the default wp-content dirs.
