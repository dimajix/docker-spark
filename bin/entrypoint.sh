#!/bin/bash
set -eo pipefail

# Setup environment
source /opt/docker/libexec/spark-init.sh


start_slave() {
   	$SPARK_HOME/sbin/start-slave.sh "spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}" --webui-port ${SPARK_WEBUI_PORT} "$@"
    check_java
}


start_master() {
    if [[ "${KUBERNETES_PORT}" != "" ]]
    then
        echo "Adjusting SPARK_MASTER for master on Kubernetes"
        export SPARK_MASTER_HOST=$(ip addr show eth0 scope global | grep inet | cut -b10-21)
        export SPARK_MASTER=${SPARK_MASTER="spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}"}
    fi

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

