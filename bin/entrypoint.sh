#!/bin/bash
set -eo pipefail

# Setup environment
source /opt/docker/libexec/hadoop-init.sh
source /opt/docker/libexec/spark-vars.sh


start_slave() {
   	$SPARK_HOME/sbin/start-slave.sh "spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}" --webui-port ${SPARK_WEBUI_PORT} "$@"
    check_java
}


start_master() {
    $SPARK_HOME/sbin/start-master.sh --webui-port ${SPARK_WEBUI_PORT} "$@"
    check_java
}


case "$1" in
    "master")
        start_master
        ;;
    "slave")
        start_slave
        ;;
    *)
        exec $@
        ;;
esac
exit $?

