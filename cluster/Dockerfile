FROM ubuntu:18.04

USER root

# install java & openssh
RUN apt update
RUN apt -y dist-upgrade
RUN apt install -y openssh-server openjdk-8-jdk
ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64/"

# configure ssh
RUN ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -P "" \
    && cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
COPY ssh/config /root/.ssh/config

# unpack hadoop
COPY ./hadoop-2.8.5.tar.gz /usr/src/cluster/hadoop-2.8.5.tar.gz
RUN tar -xzf /usr/src/cluster/hadoop-2.8.5.tar.gz -C /usr/src/cluster
RUN rm /usr/src/cluster/hadoop-2.8.5.tar.gz

# add scripts from cluster directory
COPY ./*.sh ./slaves /usr/src/cluster/
WORKDIR /usr/src/cluster

# prepare environment variables for hadoop installation
ENV HADOOP_HOME="/usr/src/cluster/hadoop-2.8.5"
ENV HADOOP_PREFIX="${HADOOP_HOME}"
ENV HADOOP_INSTALL="${HADOOP_HOME}"
ENV HADOOP_MAPRED_HOME="${HADOOP_HOME}"
ENV HADOOP_COMMON_HOME="${HADOOP_HOME}"
ENV HADOOP_HDFS_HOME="${HADOOP_HOME}"
ENV YARN_HOME="${HADOOP_HOME}"
ENV HADOOP_COMMON_LIB_NATIVE_DIR="${HADOOP_HOME}/lib/native"
ENV PATH="${PATH}:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin"
ENV HADOOP_OPTS="-Djava.library.path=${HADOOP_HOME}/lib/native"

# install & setup hadoop
ENV MASTER_HOST_NAME="master"
ENV CUSTOM_HDFS_DIR="/usr/src/hdfsdata"
RUN chmod +x install.shx
RUN ./install.sh

# to expose more ports: http://fibrevillage.com/storage/637-hadoop-default-ports-reference
EXPOSE 22
EXPOSE 9000
EXPOSE 50070

# entrypoints (setup + teardown on ctrl+c) for master and slave
RUN chmod +x master.sh
RUN chmod +x slave.sh

# entrypoint needs to be specified on execution (via docker run or docker-compose)
# commands can use flags mounted to /usr/src/flags to remember cluster state
RUN mkdir /usr/src/flags
ENV FLAGS_DIR="/usr/src/flags"

# applications directory where all user applications will be linked
# java applications can be compiled locally
# or remotely (in the cluster) as both sources and jars will be synchronized via docker volume
RUN mkdir /usr/src/applications/
ENV APPLICATIONS_DIR="/usr/src/applications/"
