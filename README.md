# Spark Docker Container

This Docker image provides a Spark standalone cluster together with a client. Actually you can also connect the client
to a YARN or Mesos cluster, if you provide the appropriate SPARK_MASTER url.

As a special gimmick, this image not only contains Hadoop for accessing files in HDFS, but also Alluxio for caching
data and accessing data in a federated environment in HDFS, S3 and other locations supported by Alluxio.

# Configuration

You will find two configuration files for use with docker-compose. The first docker-compose.yml contains the setup of
the containers. The second file docker-compose.env  contains common environment settings used by all containers. This
seperation helps to come up with a consistent configuration of all ports, hostnames etc for all containers.

## Spark Cluster Configuration

The following settings configure Spark master and all workers.

    SPARK_MASTER_HOST=spark-master
    SPARK_MASTER_PORT=7077

    SPARK_WEBUI_PORT=9090
    SPARK_WORKER_CORES=4
    SPARK_WORKER_MEMORY=8G
    SPARK_LOCAL_DIRS=/tmp/spark-local
    SPARK_WORKER_DIR=/tmp/spark-worker
    
## History Server Configuration

Optionally you can also run the spark history server. This required that log files are collected from drivers inside
a shared volume. History collection is enabled per default.
    
    SPARK_HISTORY_ENABLED=true
    SPARK_HISTORY_DIR=/tmp/spark-history
    SPARK_HISTORY_CLEANER_ENABLED="true"
    
## Volume Configuration

Spark uses several directories for temporary data. You can configure the location of these directories and optionally
mount specific (potentially large) volumes into these directories. If you want to run a Spark history server, the
history volume is configured by `SPARK_HISTORY_DIR` and has to be a volume shared by all clients (where the driver
programs are running) and the Spark history server.

    SPARK_LOCAL_DIRS=/tmp/spark-local
    SPARK_WORKER_DIR=/tmp/spark-worker
    SPARK_HISTORY_DIR=/tmp/spark-history
    

## Hadoop Properties

It is possible to access Hadoop resources (in HDFS) from Spark. 

    HDFS_NAMENODE_HOSTNAME=hadoop-namenode
    HDFS_NAMENODE_PORT=8020
    HDFS_DEFAULT_FS=${HDFS_DEFAULT_FS=hdfs://$HDFS_NAMENODE_HOSTNAME:$HDFS_NAMENODE_PORT}
    HDFS_REPLICATION_FACTOR=2

## S3 properties

Since many users want to access data stored on AWS S3, it is also possible to specify AWS credentials and general
settings.

    S3_PROXY_HOST=
    S3_PROXY_PORT=-1
    S3_PROXY_USE_HTTPS=false
    S3_ENDPOINT=s3.amazonaws.com
    S3_ENDPOINT_HTTP_PORT=80
    S3_ENDPOINT_HTTPS_PORT=443

    AWS_ACCESS_KEY_ID=
    AWS_SECRET_ACCESS_KEY=

    
# Services
    
Per default the following services are available:
    
## Spark Master
    
    SPARK_MASTER_PORT=7077
    SPARK_MASTER_WEBUI_PORT=8080

## Spark Worker
    
    SPARK_WORKER_WEBUI_PORT=8081
    
## Spark History Server

    SPARK_HISTORY_WEBUI_PORT=18080 

## Spark Driver
    
    SPARK_DRIVER_WEBUI_PORT=4040
    
    
# Running a Spark Standalone Cluster

The container already contains all components for running a Spark standalone cluster. This can be achieved by using the
three commands
    * master
    * slave
    * history-server

The docker-compose file contains an example of a complete Spark standalone cluster with a Jupyter Notebook as the
frontend.
