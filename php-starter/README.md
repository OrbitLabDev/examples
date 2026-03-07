# PHP Starter — Orbit Lab

A minimal PHP application for Orbit Lab shared hosting (OpenLiteSpeed).

## Structure

```
php-starter/
├── .htaccess    # OLS rewrite rules (front controller + directory listing off)
├── index.php    # Entry point — all non-static requests route here
└── README.md
```

## How it works

On shared hosting, files are deployed directly onto the hosting's OpenLiteSpeed server. The `.htaccess` enables the rewrite engine and routes all requests to `index.php` (front controller pattern). Static files (images, CSS, JS) are served directly.

## Deploying on Orbit Lab

1. Purchase a shared hosting plan on [orbitlab.dev](https://orbitlab.dev).
2. From your hosting dashboard, click **Add website** and choose **PHP Starter**.
3. Edit files via SFTP from the service dashboard.
