#!/bin/sh

set -e

# ==== HIBERNATE CONFIG ====
#!/bin/sh

set -e

# ==== HIBERNATE CONFIG ====
for file in $(find /opt/tomcat/webapps/ROOT/WEB-INF/classes/ -name "hibernate.properties"); do
  sed -i \
    -e "s|postgres:5432/DATABASE|${DB_HOST}:${DB_PORT}/${DB_NAME}|g" \
    -e "s|USERNAME|${DB_USER}|g" \
    -e "s|USERPASSWORD|${DB_PASSWORD}|g" \
    "$file"
done

# ==== CACHE CONFIG ====
for file in $(find /opt/tomcat/webapps/ROOT/WEB-INF/classes/ -name "cache.properties"); do
  if [ -n "${REDIS_URL}" ]; then
    sed -i "s|^redis.address *=.*|redis.address = ${REDIS_URL}|g" "$file"
  fi
done

exec "$@"
