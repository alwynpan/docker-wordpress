#!/usr/bin/env bash
# Builds each given Dockerfile and asserts PHP ini values resolve from env vars.
# Usage: tests/test-images.sh [Dockerfile...]   (defaults to all Dockerfile.*)
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

QUERY='echo ini_get("memory_limit"),"|",ini_get("upload_max_filesize"),"|",ini_get("post_max_size"),"|",parse_ini_file("/usr/local/etc/php/conf.d/uploads.ini")["max_execution_time"],"|",ini_get("file_uploads"),"|",ini_get("display_errors");'
BOOT_WAIT_SECONDS=6
fail=0

check() { # name expected actual
  if [ "$2" = "$3" ]; then
    echo "  PASS $1"
  else
    echo "  FAIL $1: expected [$2] got [$3]"
    fail=1
  fi
}

php_ini() { # tag [docker run args...]
  local tag=$1; shift
  docker run --rm --entrypoint php "$@" "$tag" -r "$QUERY" 2>&1 | tail -1
}

test_image() { # dockerfile
  local tag="dwp-test:${1#Dockerfile.}"
  echo "== $1"
  if ! docker build -q -f "$1" -t "$tag" . >/dev/null; then
    echo "  FAIL build"; fail=1; return
  fi

  check defaults "128M|10M|10M|120|1|" "$(php_ini "$tag")"
  check overrides "256M|100M|100M|600|1|" "$(php_ini "$tag" \
    -e PHP_MEMORY_LIMIT=256M -e PHP_UPLOAD_MAX_FILESIZE=100M \
    -e PHP_POST_MAX_SIZE=100M -e PHP_MAX_EXECUTION_TIME=600)"
  check non-root "512M|10M|10M|120|1|" "$(php_ini "$tag" --user 12345:12345 -e PHP_MEMORY_LIMIT=512M)"
  # A newline in a value must not inject extra directives.
  check no-ini-injection "|" "$(php_ini "$tag" -e "PHP_MEMORY_LIMIT=$(printf '64M\ndisplay_errors=1')" \
    | awk -F'|' '{print "|"$6}')"

  local cid
  cid=$(docker run -d -e WORDPRESS_DB_HOST=127.0.0.1 "$tag")
  sleep "$BOOT_WAIT_SECONDS"
  if [ "$(docker inspect -f '{{.State.Running}}' "$cid")" = true ] \
    && docker exec "$cid" test -f /var/www/html/wp-settings.php; then
    echo "  PASS entrypoint-boots"
  else
    echo "  FAIL entrypoint-boots"; docker logs "$cid" 2>&1 | tail -5; fail=1
  fi
  docker rm -f "$cid" >/dev/null
}

if [ $# -eq 0 ]; then set -- Dockerfile.*; fi
for f in "$@"; do test_image "$f"; done
exit $fail
