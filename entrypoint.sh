#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

: "${GUNICORN_CONF:=gunicorn_conf.py}"
: "${WORKER_CLASS:=uvicorn.workers.UvicornWorker}"
: "${APP_MODULE:=project.main:app}"

if [ "${POD_TYPE}" = 'worker' ]; then
    echo 'Starting Worker'
    if [ $WITH_NEW_RELIC == "true" ] ; then
        echo 'Starting New Relic Celery Agent...'
        newrelic-admin run-program celery \
            -A project.main.celery worker \
                -l 'INFO' \
                -c "${WORKER_CONCURRENCY:-2}" \
                -E \
                --without-gossip \
                --without-mingle \
                -Q "${DEFAULT_QUEUE_NAME}"
    else
        echo 'Starting Celery Worker...'
        celery \
            -A project.main.celery worker \
                -l 'INFO' \
                -c "${WORKER_CONCURRENCY:-2}" \
                -E \
                --without-gossip \
                --without-mingle
    fi
else
    echo 'Starting FastAPI Web Application...'
    if [ $WITH_NEW_RELIC == "true" ] ; then
        alembic upgrade head
        echo "Database UP"
        newrelic-admin run-program gunicorn \
            -c "${GUNICORN_CONF}" \
            -w "${GUNICORN_CONCURRENCY:-2}" \
            -k "${WORKER_CLASS}" \
            "${APP_MODULE}"
    else
        alembic upgrade head
        echo "Database UP"
        gunicorn \
            -c "${GUNICORN_CONF}" \
            -w "${GUNICORN_CONCURRENCY:-2}" \
            -k "${WORKER_CLASS}" \
            "${APP_MODULE}"
    fi
f
