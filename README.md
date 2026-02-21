# OrbitLab examples

Deployable examples for [OrbitLab.dev](https://orbitlab.dev). PHP in Docker; database is OrbitLab MySQL (provisioned via API). Run locally with the same compose and `MYSQL_*` in .env.

## Examples

| Folder | Stack |
|--------|--------|
| [php-wordpress-lightspeed](./php-wordpress-lightspeed) | PHP + WordPress on LiteSpeed |
| [php-wordpress-apache](./php-wordpress-apache) | PHP + WordPress on Apache |

## Deploying on OrbitLab

Provision MySQL (`POST /database`), set `MYSQL_*` (and example-specific env) on the project, then deploy. See each example’s README for steps and local run.
