# WordPress

Based on [WordPress official image](https://hub.docker.com/_/wordpress/), just added a bit extra PHP settings via environment variables.

## Usage

Please see [WordPress Docker hub page](https://hub.docker.com/_/wordpress/).

## Extra PHP Settings

- `PHP_MEMORY_LIMIT=...` (default to 128M)
- `PHP_UPLOAD_MAX_FILESIZE=...` (default to 10M)
- `PHP_POST_MAX_SIZE=...` (default to 10M)
- `PHP_MAX_EXECUTION_TIME=...` (default to 120)

These are read by PHP at startup from `/usr/local/etc/php/conf.d/uploads.ini` (see [config/php/uploads.ini](config/php/uploads.ini)), so they also work when the container runs as a non-root user.

## Examples

- `docker compose up` — Apache image with MySQL, on http://localhost:8080
- `docker compose -f docker-compose.fpm.yaml up` — PHP-FPM image behind nginx with MySQL, on http://localhost:8080

Data is persisted under `./data/`. When using the FPM example, keep `client_max_body_size` in [config/nginx/wordpress.conf](config/nginx/wordpress.conf) in line with `PHP_UPLOAD_MAX_FILESIZE`.

## `Dockerfile` links

- [7.1.2-php8.2-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.2-apache)
- [7.1.2-php8.2-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.2-fpm)
- [7.1.2-php8.2-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.2-fpm-alpine)

- [7.1.2-php8.3-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.3-apache)
- [7.1.2-php8.3-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.3-fpm)
- [7.1.2-php8.3-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.3-fpm-alpine)

- [7.1.2-php8.4-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.4-apache)
- [7.1.2-php8.4-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.4-fpm)
- [7.1.2-php8.4-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.4-fpm-alpine)

- [7.1.2-php8.5-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.5-apache)
- [7.1.2-php8.5-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.5-fpm)
- [7.1.2-php8.5-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.5-fpm-alpine)
