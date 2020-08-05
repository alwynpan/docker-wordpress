# WordPress

Based on [WordPress official image](https://hub.docker.com/_/wordpress/), just added a bit extra PHP settings via enviroment variables.

## Usage

Please see [WordPress Docker hub page](https://hub.docker.com/_/wordpress/).

## Extra PHP Settings

* `PHP\_MEMORY\_LIMIT=...` (default to 64M)
* `PHP\_UPLOAD\_MAX\_FILESIZE=...` (default to 10M)
* `PHP\_POST\_MAX\_SIZE=...` (default to 10M)
* `PHP\_MAX\_EXECUTION\_TIME=...` (default to 300)

## `Dockerfile` links

* 5.4.2-php7.2-apache
* 5.4.2-php7.2-fpm
* 5.4.2-php7.2-fpm-alpine

* 5.4.2-php7.3-apache
* 5.4.2-php7.3-fpm
* 5.4.2-php7.3-fpm-alpine

* 5.4.2-php7.4-apache
* 5.4.2-php7.4-fpm
* 5.4.2-php7.4-fpm-alpine
