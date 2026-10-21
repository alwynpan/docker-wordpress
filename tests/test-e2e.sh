#!/usr/bin/env bash
# Runs each compose example against locally built images and checks the live PHP SAPI.
# Usage: tests/test-e2e.sh   (needs port 8080 free)
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

PROBE='<?php echo ini_get("memory_limit"),"|",ini_get("upload_max_filesize"),"|",ini_get("post_max_size"),"|",ini_get("max_execution_time"),"|",php_sapi_name(),"|",strlen(file_get_contents("php://input"));'
POST_BYTES=5242880
READY_ATTEMPTS=60
# Under the repo (gitignored) so Docker Desktop can bind-mount it; system temp dirs aren't shared.
mkdir -p data
work=$(mktemp -d "$PWD/data/.e2e.XXXXXX")
fail=0
stacks=()

# shellcheck disable=SC2329 # invoked via trap
cleanup() {
  local s
  for s in "${stacks[@]}"; do docker compose -p "$s" down -v >/dev/null 2>&1; done
  # Data dirs are owned by container users; remove them from inside a container.
  docker run --rm -v "$work:/w" alpine sh -c 'rm -rf /w/*' >/dev/null 2>&1
  rm -rf "$work"
  rmdir data 2>/dev/null || true
}
trap cleanup EXIT

expect() { # pass-msg fail-msg test-command...
  local pass=$1 failmsg=$2; shift 2
  if "$@"; then echo "  PASS $pass"; else echo "  FAIL $failmsg"; fail=1; fi
}

e2e() { # compose-file variant expected-sapi
  local variant=$2 dir="$work/$2"
  local tag="dwp-test:$variant"
  mkdir -p "$dir"
  cp -R config "$1" "$dir/"
  printf 'services:\n  wordpress:\n    image: %s\n' "$tag" > "$dir/override.yaml"
  local project="dwp-e2e-${variant//./-}"
  local dc=(docker compose -p "$project" -f "$dir/$1" -f "$dir/override.yaml")
  stacks+=("$project")

  echo "== $1 ($variant)"
  docker build -q -f "Dockerfile.$variant" -t "$tag" . >/dev/null || { echo "  FAIL build"; fail=1; return; }
  "${dc[@]}" up -d --quiet-pull >/dev/null 2>&1 || { echo "  FAIL up"; fail=1; return; }

  local code=""
  for _ in $(seq 1 "$READY_ATTEMPTS"); do
    code=$(curl -s -o /dev/null -w '%{http_code}' -L http://localhost:8080/wp-admin/install.php)
    [ "$code" = 200 ] && break
    sleep 2
  done
  expect "install page served (db connected)" "install page: $code" [ "$code" = 200 ]
  [ "$code" = 200 ] || "${dc[@]}" logs --tail 20

  expect "wordpress files persisted" "wordpress files not persisted" \
    [ -f "$dir/data/wordpress/wp-config.php" ]
  expect "mysql data persisted" "mysql data not persisted" [ -d "$dir/data/mysql/exampledb" ]

  printf '%s' "$PROBE" > "$dir/data/wordpress/probe.php"
  head -c "$POST_BYTES" /dev/zero > "$work/post.bin"
  local out
  out=$(curl -s --data-binary @"$work/post.bin" http://localhost:8080/probe.php)
  expect "live ini + 5MB POST: $out" "live ini/POST: [$out]" \
    [ "$out" = "128M|100M|100M|600|$3|$POST_BYTES" ]

  # Free port 8080 for the next stack.
  "${dc[@]}" down -v >/dev/null 2>&1
}

e2e docker-compose.yaml php8.3-apache apache2handler
e2e docker-compose.fpm.yaml php8.3-fpm fpm-fcgi
exit $fail
