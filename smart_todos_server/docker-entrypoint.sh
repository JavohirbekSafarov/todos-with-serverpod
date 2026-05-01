#!/bin/sh

# Migratsiyalarni qo'llash (ixtiyoriy)
./server --mode $SERVERPOD_MODE --apply-migrations

# Serverni ishga tushirish
exec ./server --mode $SERVERPOD_MODE