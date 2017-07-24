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
