# WordPress

Based on [WordPress official image](https://hub.docker.com/_/wordpress/), just added a bit extra PHP settings via environment variables.

## Usage

Please see [WordPress Docker hub page](https://hub.docker.com/_/wordpress/).

## Extra PHP Settings

- `PHP\_MEMORY\_LIMIT=...` (default to 128M)
- `PHP\_UPLOAD\_MAX\_FILESIZE=...` (default to 10M)
- `PHP\_POST\_MAX\_SIZE=...` (default to 10M)
- `PHP\_MAX\_EXECUTION\_TIME=...` (default to 120)

## `Dockerfile` links

- [6.0.2-php7.3-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.3-apache)
- [6.0.2-php7.3-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.3-fpm)
- [6.0.2-php7.3-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.3-fpm-alpine)

- [6.0.2-php7.4-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.4-apache)
- [6.0.2-php7.4-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.4-fpm)
- [6.0.2-php7.4-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.4-fpm-alpine)

- [6.0.2-php8.0-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.0-apache)
- [6.0.2-php8.0-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.0-fpm)
- [6.0.2-php8.0-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.0-fpm-alpine)

- [6.0.2-php8.1-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.1-apache)
- [6.0.2-php8.1-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.1-fpm)
- [6.0.2-php8.1-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.1-fpm-alpine)
