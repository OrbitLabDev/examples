# PHP + WordPress on Apache

Example stack for deploying WordPress on **Apache** with PHP (mod_php or PHP-FPM).

Suitable for deployment on [OrbitLab.dev](https://orbitlab.dev).

## Contents

- `Dockerfile` – PHP with Apache for WordPress.

## Usage

Build and run with Docker, or use this folder as the app source for OrbitLab.dev deployment.

## Notes

- WordPress core can be installed at deploy time or baked into the image.
- Configure database and `WP_*` env vars for your deployment.
