#!/bin/bash

set -e

NGX_UPSTREAM=${NGX_ADDRESS:-app}:${NGX_PORT:-80}

[[ $DEBUG == true ]] && set -x

# Generate Upstream config
sed -i 's/NGX_UPSTREAM/'"${NGX_UPSTREAM}"'/' /etc/nginx/upstream.conf

# Generate Pagespeed config based on environment variables
echo $(env | grep NPSC_ | sed -e 's/^NPSC_//g' -e "s/\([A-Z_]*\)=/\L\1=/g" -e "s/_\([a-zA-Z]\)/\u\1/g" -e "s/^\([a-zA-Z]\)/\u\1/g" -e 's/\=/ /' -e 's/^/\pagespeed /' -e 's/$/;/') >> /etc/nginx/pagespeed.conf

exec "$@"
