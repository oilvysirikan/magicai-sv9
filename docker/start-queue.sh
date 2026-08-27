#!/bin/sh
# Starts a Laravel queue worker only when a real (non-sync) queue connection
# is configured. For sync/null the worker is a no-op so supervisord stays happy.
set -e

CONNECTION="${QUEUE_CONNECTION:-sync}"

if [ "$CONNECTION" = "sync" ] || [ "$CONNECTION" = "null" ] || [ -z "$CONNECTION" ]; then
    echo "[queue] QUEUE_CONNECTION is '$CONNECTION' -> not starting a background worker."
    exec tail -f /dev/null
fi

echo "[queue] Starting worker on connection '$CONNECTION' (queue: ${REDIS_QUEUE:-default})"
exec php /app/artisan queue:work "$CONNECTION" \
    --queue="${REDIS_QUEUE:-default}" \
    --tries=3 \
    --max-time=3600 \
    --sleep=3 \
    --timeout=300
