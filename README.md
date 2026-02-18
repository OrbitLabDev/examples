# OrbitLab examples

Deployable examples for [OrbitLab.dev](https://orbitlab.dev). Each example can run **locally** with its own DB (docker-compose) or on **OrbitLab PaaS** using the **shared database** (no DB container; env from `POST /database`).

## Examples

| Folder | Stack |
|--------|--------|
| [php-wordpress-lightspeed](./php-wordpress-lightspeed) | PHP + WordPress on LiteSpeed |
| [php-wordpress-apache](./php-wordpress-apache) | PHP + WordPress on Apache |

## Deploying on OrbitLab (shared DB)

On the PaaS you do **not** run a database inside Docker. Instead:

1. **Provision a database** via `POST /database` (`type: "mysql"` for these WordPress examples). The API returns `host`, `port`, `database`, `user`, `password`, and `connectionString`.
2. **Set project env** with `PUT /project/:id/env` using those fields (e.g. `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`).
3. **Deploy** the app image only. The container receives the env and connects to the shared MySQL.

See each example’s README for step-by-step and for app-only compose files (to run locally against the shared DB).
