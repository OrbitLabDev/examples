# PHP + WordPress on LiteSpeed

Orbit Lab example: **WordPress** on **LiteSpeed** (litespeedtech/litespeed). WordPress is installed in the image; `wp-config.php` is generated at startup from `MYSQL_*` env vars. Use either a **local MariaDB** (docker-compose) or the **OrbitLab shared MySQL** (no DB container).

## Contents

- `Dockerfile` – LiteSpeed image + WordPress install
- `docker-entrypoint.sh` – generates `wp-config.php` from env
- `docker-compose.litespeed.yml` – local: db + litespeed
- `docker-compose.litespeed-app-only.yml` – app only (shared DB or external MySQL)
- `.env.example` – copy to `.env` and set `MYSQL_*`

## Local: full stack (MariaDB + LiteSpeed)

```bash
cp .env.example .env
# Edit .env: MYSQL_ROOT_PASSWORD, MYSQL_PASSWORD, etc.
docker compose -f docker-compose.litespeed.yml up -d
```

- HTTP: port `7080` (or `HTTP_PORT`, default 8080)
- HTTPS: port `7443` (or `HTTPS_PORT`, default 8443)

## OrbitLab PaaS: shared database (no DB in Docker)

On OrbitLab you deploy **only the app image**; the database is provisioned via the API and injected as project env.

1. Create a project and (if needed) a domain.
2. Provision a MySQL database: `POST /database` with `{ "userId", "type": "mysql" }`. The API returns `host`, `port`, `database`, `user`, `password` (and `connectionString`).
3. Set project env from the response: `PUT /project/:id/env` with:
   - `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`
4. Deploy the app (no DB container). The container receives the env above and connects to the shared MySQL.

The PaaS mounts a persistent volume at **`/app/data`** in the container. The entrypoint uses it for WordPress **uploads**, **plugins**, and **themes** (symlinks `wp-content/uploads`, `wp-content/plugins`, `wp-content/themes` → `/app/data/...`) so media and user-installed plugins/themes persist across deploys. If `/app/data` is not present (e.g. local compose), WordPress uses the default wp-content dirs.

## Local: app only (e.g. test with shared DB)

If you have an external MySQL (or shared DB connection details), run the app without the `db` service:

```bash
cp .env.example .env
# Set MYSQL_HOST, MYSQL_PORT, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD (from PaaS or external DB)
docker compose -f docker-compose.litespeed-app-only.yml up -d
```

Then open the site and complete the WordPress setup wizard in the browser.
