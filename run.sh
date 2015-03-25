#!/bin/bash -e

service postfix start && service cron start && service ssh start && exec "$@" 
function stop_svc {
    service postfix stop
    exit
}

trap 'stop_svc' SIGTERM

while true
do
    sleep 1
done
