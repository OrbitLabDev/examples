# PHP + WordPress on LiteSpeed

Example stack for deploying WordPress on **LiteSpeed** (or OpenLiteSpeed) with PHP.

Suitable for deployment on [OrbitLab.dev](https://orbitlab.dev).

## Contents

- `Dockerfile` – PHP with LiteSpeed web server for WordPress.

## Usage

Build and run with Docker, or use this folder as the app source for OrbitLab.dev deployment.

## Notes

- WordPress core can be installed at deploy time or baked into the image.
- Configure database and `WP_*` env vars for your deployment.
