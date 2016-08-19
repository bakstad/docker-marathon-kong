#!/bin/sh
set -e

# Setting up the proper database
if [ -n "$DATABASE" ]; then
  sed -ie "s/database: cassandra/database: $DATABASE/" /etc/kong/kong.yml
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

# Configure CLUSTER_LISTEN

# Find ip from marathon $HOST variable
HOST_IP=`ping -c1 -n $HOST | head -n1 | sed "s/.*(\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)).*/\1/g"`
CLUSTER_LISTEN="$HOST_IP:$PORT3"

# Cluster Listen based on marathon
sed -ie "s/cluster_listen: \"0.0.0.0:7946\"/cluster_listen: \"$CLUSTER_LISTEN\"/" /etc/kong/kong.yml

exec "$@"