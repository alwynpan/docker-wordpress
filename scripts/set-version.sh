#!/usr/bin/env bash
# Regenerates Dockerfiles, README links and compose image tags for a WordPress release.
# Usage: scripts/set-version.sh <wp-version> <php-version>...   e.g. 6.8.0 8.1 8.2 8.3 8.4
set -euo pipefail
cd "$(dirname "$0")/.." || exit 1

IMAGE=alwynpan/docker-wordpress
REPO_URL=https://github.com/alwynpan/docker-wordpress/blob/master
VARIANTS=(apache fpm fpm-alpine)
# shellcheck disable=SC2016 # literal backticks
LINKS_HEADING='## `Dockerfile` links'

die() { echo "error: $*" >&2; exit 1; }

[ $# -ge 2 ] || die "usage: $0 <wp-version> <php-version>..."
version=$1; shift
[[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "invalid WordPress version: $version"
for php in "$@"; do
  [[ $php =~ ^[0-9]+\.[0-9]+$ ]] || die "invalid PHP version: $php"
done
grep -qF "$LINKS_HEADING" README.md || die "README.md is missing '$LINKS_HEADING'"

# Plain loop rather than mapfile so macOS's bash 3.2 works too.
phps=()
while IFS= read -r php; do phps+=("$php"); done < <(printf '%s\n' "$@" | sort -uV)
newest_php=${phps[${#phps[@]}-1]}

rm -f Dockerfile.php*
for php in "${phps[@]}"; do
  for variant in "${VARIANTS[@]}"; do
    cat > "Dockerfile.php${php}-${variant}" <<DOCKERFILE
FROM wordpress:${version}-php${php}-${variant}

ENV PHP_MEMORY_LIMIT=128M \\
    PHP_UPLOAD_MAX_FILESIZE=10M \\
    PHP_POST_MAX_SIZE=10M \\
    PHP_MAX_EXECUTION_TIME=120

COPY config/php/uploads.ini /usr/local/etc/php/conf.d/uploads.ini
DOCKERFILE
  done
done

# Compose examples track the newest PHP.
perl -pi -e "s{(image: \Q${IMAGE}\E:)\S+-(apache|fpm)\$}{\${1}${version}-php${newest_php}-\${2}}" \
  docker-compose.yaml docker-compose.fpm.yaml

{
  awk -v heading="$LINKS_HEADING" '{ print } $0 == heading { exit }' README.md
  for php in "${phps[@]}"; do
    echo
    for variant in "${VARIANTS[@]}"; do
      echo "- [${version}-php${php}-${variant}](${REPO_URL}/Dockerfile.php${php}-${variant})"
    done
  done
} > README.md.tmp
mv README.md.tmp README.md

echo "Set WordPress ${version} for PHP ${phps[*]}"
