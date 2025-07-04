#!/bin/sh

set -e

# ==== HIBERNATE CONFIG ====
for file in $(find /opt/tomcat/webapps/ROOT/WEB-INF/classes/ -name "hibernate.properties"); do
  sed -i \
    -e "s|DB_ENDPOINT_TOKEN|${DB_ENDPOINT_TOKEN}|g" \
    -e "s|DB_NAME_TOKEN|${DB_NAME_TOKEN}|g" \
    -e "s|DB_USERNAME_TOKEN|${DB_USERNAME_TOKEN}|g" \
    -e "s|DB_USERPASSWORD_TOKEN|${DB_USERPASSWORD_TOKEN}|g" \
    "$file"
done

# ==== CACHE CONFIG ====
for file in $(find /opt/tomcat/webapps/ROOT/WEB-INF/classes/ -name "cache.properties"); do
  sed -i \
    -e "s|REDIS_ENDPOINT_TOKEN|${REDIS_ENDPOINT_TOKEN}|g" \
    "$file"
done

[ "$(find /opt/tomcat/webapps/ROOT/WEB-INF/classes/ -name 'hibernate.properties' | wc -l)" -eq 0 ]
[ "$(find /opt/tomcat/webapps/ROOT/WEB-INF/classes/ -name 'cache.properties' | wc -l)" -eq 0 ]

exec "$@"
