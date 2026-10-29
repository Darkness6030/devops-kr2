#!/bin/sh
set -eu
mkdir -p logs
sh certs.sh > /tmp/certs.log 2>&1
/work/dice-server > /tmp/kr2-go.log 2>&1 &
nginx -p /work -c nginx.conf
python manage.py runserver 127.0.0.1:8000 --noreload > /tmp/kr2-django.log 2>&1 &
python manage.py runserver 127.0.0.1:8001 --noreload > /tmp/kr2-django2.log 2>&1 &
wait
