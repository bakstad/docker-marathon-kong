#!/usr/local/bin/dumb-init /bin/bash
set -e

# Setting up the proper database
if [ -n "$DATABASE" ]; then
  sed -ie "s/database: postgres/database: $DATABASE/" /etc/kong/kong.yml
fi

# Postgres
if [ -n "$POSTGRES_HOST" ]; then
  sed -ie "s/host: \"kong-database\"/host: \"$POSTGRES_HOST\"/" /etc/kong/kong.yml
fi

if [ -n "$POSTGRES_PORT" ]; then
  sed -ie "s/port: 5432/port: $POSTGRES_PORT/" /etc/kong/kong.yml
fi

if [ -n "$POSTGRES_DB" ]; then
  sed -ie "s/database: kong/database: $POSTGRES_DB/" /etc/kong/kong.yml
fi

if [ -n "$POSTGRES_USER" ]; then
  sed -ie "s/user: kong/user: $POSTGRES_USER/" /etc/kong/kong.yml
fi

if [ -n "$POSTGRES_PASSWORD" ]; then
  sed -ie "s/#  password: kong/  password: $POSTGRES_PASSWORD/" /etc/kong/kong.yml
fi

if [ -n "$CLUSTER_TTL_ON_FAILURE" ]; then
  sed -ie "s/  ttl_on_failure: 3600/  ttl_on_failure: $CLUSTER_TTL_ON_FAILURE/" /etc/kong/kong.yml
fi

# Configure kong to advertise its external ip and port to the rest of the cluster
# Find ip from marathon $HOST variable
HOST_IP=`ping -c1 -n $HOST | head -n1 | sed "s/.*(\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)).*/\1/g"`
ADVERTISE_ADDR="$HOST_IP:$PORT3"
sed -ie "s/  advertise: \"0\.0\.0\.0:7946\"/  advertise: \"$ADVERTISE_ADDR\"/" /etc/kong/kong.yml

# Start
exec "$@"
