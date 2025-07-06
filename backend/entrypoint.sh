#!/bin/sh

set -e

# ==== HIBERNATE CONFIG ====
#!/bin/sh

set -e

# ==== HIBERNATE CONFIG ====
for file in $(find /opt/tomcat/webapps/ROOT/WEB-INF/classes/ -name "hibernate.properties"); do
  sed -i \
    -e "s|^hibernate.connection.url=.*|hibernate.connection.url=jdbc:postgresql://${DB_ENDPOINT_TOKEN}:5432/${DB_NAME_TOKEN}|" \
    -e "s|USERNAME|${DB_USERNAME_TOKEN}|g" \
    -e "s|USERPASSWORD|${DB_USERPASSWORD_TOKEN}|g" \
  "$file"
done

# ==== CACHE CONFIG ====
for file in $(find /opt/tomcat/webapps/ROOT/WEB-INF/classes/ -name "cache.properties"); do
  if [ -n "${REDIS_URL}" ]; then
    sed -i "s|^redis.address *=.*|redis.address = ${REDIS_URL}|g" "$file"
  fi
done

exec "$@"
