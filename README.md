# WordPress

Based on [WordPress official image](https://hub.docker.com/_/wordpress/), just added a bit extra PHP settings via environment variables.

## Usage

Please see [WordPress Docker hub page](https://hub.docker.com/_/wordpress/).

## Extra PHP Settings

- `PHP_MEMORY_LIMIT=...` (default to 128M)
- `PHP_UPLOAD_MAX_FILESIZE=...` (default to 10M)
- `PHP_POST_MAX_SIZE=...` (default to 10M)
- `PHP_MAX_EXECUTION_TIME=...` (default to 120)

## `Dockerfile` links

- [6.6.2-php8.1-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.1-apache)
- [6.6.2-php8.1-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.1-fpm)
- [6.6.2-php8.1-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.1-fpm-alpine)

- [6.6.2-php8.2-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.2-apache)
- [6.6.2-php8.2-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.2-fpm)
- [6.6.2-php8.2-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.2-fpm-alpine)

- [6.6.2-php8.3-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.3-apache)
- [6.6.2-php8.3-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.3-fpm)
- [6.6.2-php8.3-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.3-fpm-alpine)
