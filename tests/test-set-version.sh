#!/usr/bin/env bash
# shellcheck disable=SC2317,SC2329 # helpers are invoked through check()
# Runs scripts/set-version.sh against a scratch copy of the repo and checks its output.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

fail=0
repo=$PWD
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

check() { # name test-command...
  local name=$1; shift
  if "$@"; then echo "  PASS $name"; else echo "  FAIL $name"; fail=1; fi
}

fresh_copy() {
  rm -rf "$work/repo"; mkdir -p "$work/repo/scripts"
  cp "$repo"/Dockerfile.* "$repo"/README.md "$repo"/docker-compose*.yaml "$work/repo/"
  cp "$repo/scripts/set-version.sh" "$work/repo/scripts/"
}

run() { (cd "$work/repo" && scripts/set-version.sh "$@") >"$work/out" 2>&1; }

count_dockerfiles() { # dir
  local files=("$1"/Dockerfile.*)
  echo "${#files[@]}"
}

# Must fail and leave the Dockerfiles untouched.
rejects() {
  ! run "$@" && [ "$(count_dockerfiles "$work/repo")" = "$(count_dockerfiles "$repo")" ]
}

echo "== happy path (unsorted, duplicate PHP versions)"
fresh_copy
check exits-zero run 9.9.9 8.4 8.2 8.4
cd "$work/repo" || exit 1
check six-dockerfiles [ "$(count_dockerfiles .)" = 6 ]
check old-php-removed [ ! -e Dockerfile.php8.1-apache ]
check from-line grep -qx 'FROM wordpress:9.9.9-php8.4-fpm-alpine' Dockerfile.php8.4-fpm-alpine
check ini-copied grep -qx 'COPY config/php/uploads.ini /usr/local/etc/php/conf.d/uploads.ini' Dockerfile.php8.2-fpm
check compose-apache grep -q 'image: alwynpan/docker-wordpress:9.9.9-php8.4-apache$' docker-compose.yaml
check compose-fpm grep -q 'image: alwynpan/docker-wordpress:9.9.9-php8.4-fpm$' docker-compose.fpm.yaml
check compose-db-untouched grep -q 'image: mysql:8.4$' docker-compose.yaml
check readme-links [ "$(grep -c '^- \[9.9.9-php8\.[24]-' README.md)" = 6 ]
check readme-no-stale-links [ "$(grep -c '^- \[[0-9.]*-php' README.md)" = 6 ]
check readme-sorted [ "$(grep -m1 '^- \[' README.md)" = "- [9.9.9-php8.2-apache](https://github.com/alwynpan/docker-wordpress/blob/master/Dockerfile.php8.2-apache)" ]
check readme-head-kept grep -q '^## Extra PHP Settings$' README.md
cp README.md "$work/readme.1"
cd "$repo" || exit 1
check idempotent run 9.9.9 8.2 8.4
check idempotent-readme cmp -s "$work/readme.1" "$work/repo/README.md"

echo "== invalid input"
for args in "" "9.9.9" "9.9 8.4" "v9.9.9 8.4" "9.9.9 8" "9.9.9 8.4;rm" "9.9.9-rc1 8.4"; do
  fresh_copy
  read -ra argv <<< "$args"
  check "rejects [${args}]" rejects ${argv[@]+"${argv[@]}"}
done

exit $fail
