FROM dimajix/hadoop:2.7.3
MAINTAINER k.kupferschmidt@dimajix.de

ARG BUILD_SPARK_VERSION=2.1.0
ARG BUILD_ALLUXIO_VERSION=1.4.0

USER root

# http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
ENV PYTHONHASHSEED=0 \
    PYTHONIOENCODING=UTF-8 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# SPARK
ENV SPARK_MASTER_HOST=spark-master \
    SPARK_MASTER_PORT=7077 \
    SPARK_WEBUI_PORT=8080 \
    SPARK_HOME=/opt/spark \
    SPARK_CONF_DIR=/etc/spark \
    SPARK_DIST_CLASSPATH="$HADOOP_CONF_DIR/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH=$PATH:${SPARK_HOME}/bin

# Download and install Spark
RUN curl -sL --retry 3 "http://d3kbcqa49mib13.cloudfront.net/spark-${BUILD_SPARK_VERSION}-bin-without-hadoop.tgz" \
  | tar xz -C /opt \
 && ln -s /opt/spark-${BUILD_SPARK_VERSION}-bin-without-hadoop ${SPARK_HOME} \
 && chown -R root:root $SPARK_HOME

# Download Alluxio Spark client
RUN curl -sL --retry 3 http://downloads.alluxio.org/downloads/files/${BUILD_ALLUXIO_VERSION}/alluxio-${BUILD_ALLUXIO_VERSION}-spark-client-jar-with-dependencies.jar \
  > /opt/spark/jars/alluxio-${BUILD_ALLUXIO_VERSION}-spark-client-jar-with-dependencies.jar

# copy configs and binaries
COPY bin/ /opt/docker/bin/
COPY libexec/ /opt/docker/libexec/
COPY conf/spark-defaults.conf ${SPARK_HOME}/conf

ENTRYPOINT ["/opt/docker/bin/entrypoint.sh"]
CMD ["bash"]
