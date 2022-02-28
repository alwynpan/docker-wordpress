# WordPress

Based on [WordPress official image](https://hub.docker.com/_/wordpress/), just added a bit extra PHP settings via environment variables.

## Usage

Please see [WordPress Docker hub page](https://hub.docker.com/_/wordpress/).

## Extra PHP Settings

* `PHP\_MEMORY\_LIMIT=...` (default to 128M)
* `PHP\_UPLOAD\_MAX\_FILESIZE=...` (default to 10M)
* `PHP\_POST\_MAX\_SIZE=...` (default to 10M)
* `PHP\_MAX\_EXECUTION\_TIME=...` (default to 120)

## `Dockerfile` links

* [5.7.0-php7.2-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.2-apache)
* [5.7.0-php7.2-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.2-fpm)
* [5.7.0-php7.2-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.2-fpm-alpine)

* [5.7.0-php7.3-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.3-apache)
* [5.7.0-php7.3-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.3-fpm)
* [5.7.0-php7.3-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.3-fpm-alpine)

* [5.7.0-php7.4-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.4-apache)
* [5.7.0-php7.4-fpm](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.4-fpm)
* [5.7.0-php7.4-fpm-alpine](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php7.4-fpm-alpine)
