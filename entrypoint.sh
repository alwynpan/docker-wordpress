#!/usr/bin/env sh

set -e

cat > /usr/local/etc/php/conf.d/uploads.ini <<EOL
file_uploads = On
memory_limit = '${PHP_MEMORY_LIMIT}'
upload_max_filesize = '${PHP_UPLOAD_MAX_FILESIZE}'
post_max_size = '${PHP_POST_MAX_SIZE}'
max_execution_time = '${PHP_MAX_EXECUTION_TIME}'
EOL

exec docker-entrypoint.sh "$@"
