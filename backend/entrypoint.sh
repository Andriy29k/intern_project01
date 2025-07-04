#!/bin/sh

if [ -z "$BACKEND_IP" ]; then
  echo "ERROR: BACKEND_IP env variable is not set"
  exit 1
fi

sed -i "s|__BACKEND_IP__|$BACKEND_IP|g" /usr/share/nginx/html/index.html

exec nginx -g "daemon off;"
