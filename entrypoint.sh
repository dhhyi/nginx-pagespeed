#!/bin/bash

set -e

NGX_UPSTREAM=${NGX_ADDRESS:-app}:${NGX_PORT:-80}

NGX_CACHE_DURATION="${NGX_CACHE_DURATION:-"10m"}"

[[ $DEBUG == true ]] && set -x

# Generate Upstream config
sed -i 's%NGX_UPSTREAM%'"${NGX_UPSTREAM}"'%' /etc/nginx/upstream.conf
sed -i 's%NGX_CACHE_DURATION%'"${NGX_CACHE_DURATION}"'%' /etc/nginx/upstream.conf

# Generate Pagespeed config based on environment variables
env | grep NPSC_ | sed -e 's/^NPSC_//g' -e "s/\([A-Z_]*\)=/\L\1=/g" -e "s/_\([a-zA-Z]\)/\u\1/g" -e "s/^\([a-zA-Z]\)/\u\1/g" -e 's/=.*$//' -e 's/\=/ /' -e 's/^/\pagespeed /' > /tmp/pagespeed-prefix.txt

env | grep NPSC_ | sed -e 's/^[^=]*=//' -e 's/$/;/' > /tmp/pagespeed-suffix.txt

paste -d" " /tmp/pagespeed-prefix.txt /tmp/pagespeed-suffix.txt >> /etc/nginx/pagespeed.conf

exec "$@"
