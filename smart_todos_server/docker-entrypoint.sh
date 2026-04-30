#!/bin/bash
set -e

echo "Waiting for PostgreSQL to be ready..."
until PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\q' 2>/dev/null; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

echo "PostgreSQL is up - executing migrations..."

# Run Serverpod migrations
dart pub get
dart run serverpod_cli:cli migrate --mode production

echo "Migrations completed - starting server..."

# Start the server with environment variables
exec ./server \
  --mode=${RUNMODE:-production} \
  --server-id=${SERVERID:-default} \
  --logging=${LOGGING:-normal} \
  --role=${ROLE:-monolith}
