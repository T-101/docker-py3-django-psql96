#!/bin/sh
# wait-for-postgres.sh

if [ ! -f ./manage.py ]; then
    echo "No Django project found, exiting";
    exit 3
fi

echo "Django project found, waiting for PostgreSQL"

set -e

host="$1"
shift
cmd="$@"

until export PGPASSWORD=$POSTGRES_PASSWORD; psql -h "$host" -U $POSTGRES_USER -c '\q' -q > /dev/null 2>&1; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command '$cmd'"
exec $cmd
