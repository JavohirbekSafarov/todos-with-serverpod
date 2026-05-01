#!/bin/sh

echo "Running migrations..."
./server --mode $RUNMODE --apply-migrations

echo "Starting server..."
exec ./server --mode $RUNMODE