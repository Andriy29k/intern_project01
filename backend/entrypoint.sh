#!/bin/sh

set -e

# ==== HIBERNATE CONFIG ====
for file in $(find /opt/tomcat/webapps/ROOT/WEB-INF/classes/ -name "hibernate.properties"); do
  sed -i \
    -e "s|jdbc:postgresql://[^:/]*:5432/[^[:space:]]*|jdbc:postgresql://${DB_ENDPOINT_TOKEN}:5432/${DB_NAME_TOKEN}|" \
    -e "s|hibernate.connection.username=.*|hibernate.connection.username=${DB_USERNAME_TOKEN}|" \
    -e "s|hibernate.connection.password=.*|hibernate.connection.password=${DB_USERPASSWORD_TOKEN}|" \
  "$file"
done

# ==== CACHE CONFIG ====
for file in $(find /opt/tomcat/webapps/ROOT/WEB-INF/classes/ -name "cache.properties"); do
  if [ -n "${REDIS_URL}" ]; then
    sed -i "s|^redis.address *=.*|redis.address = ${REDIS_URL}|g" "$file"
  fi
done

exec "$@"
