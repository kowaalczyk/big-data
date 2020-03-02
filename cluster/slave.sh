#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function start_slave() {
    echo
    echo "***************************************************************************"
    echo service ssh start
    echo "***************************************************************************"
    service ssh start

    tail -f /dev/null  # idle, slaves don't need any running process
}

function stop_slave() {
    echo
    echo "***************************************************************************"
    echo service ssh stop
    echo "***************************************************************************"
    service service ssh stop
}

trap stop_slave SIGTERM

start_slave
stop_slave
