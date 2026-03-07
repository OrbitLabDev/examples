# PHP Starter — Orbit Lab

A minimal PHP application running on OpenLiteSpeed. Use this as a starting point for any PHP project on Orbit Lab shared hosting.

## Structure

```
php-starter/
├── Dockerfile              # OpenLiteSpeed + PHP
├── docker-entrypoint.sh    # Startup script
├── public/                 # Document root
│   ├── index.php           # Landing page
│   └── info.php            # phpinfo() (remove in production)
├── .env.example
└── README.md
```

## Local development

```bash
docker build -t php-starter .
docker run -p 8080:80 php-starter
```

Then open [http://localhost:8080](http://localhost:8080).

## Deploying on Orbit Lab

1. Purchase a shared hosting plan on [orbitlab.dev](https://orbitlab.dev).
2. From your hosting dashboard, click **Add website** and choose **PHP Starter**.
3. Your app will be deployed automatically. Edit files via SFTP or push to the repo.
