FROM ubuntu:18.04

USER root

# install java & openssh
RUN apt update
RUN apt -y dist-upgrade
RUN apt install -y openssh-server openjdk-8-jdk
ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64/"

# create ssh key
RUN ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -P "" \
    && cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

# add ssh config
COPY ssh/config /root/.ssh/config

# unpack hadoop
COPY ./hadoop-2.8.5.tar.gz /usr/src/cluster/hadoop-2.8.5.tar.gz
RUN tar -xzf /usr/src/cluster/hadoop-2.8.5.tar.gz -C /usr/src/cluster
RUN rm /usr/src/cluster/hadoop-2.8.5.tar.gz

# add scripts from cluster directory
COPY . /usr/src/cluster
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
RUN chmod +x install.sh
RUN ./install.sh

# format hdfs namenode during build
# TODO: volumes are stateful, this may not be the perfect place to do that
RUN hdfs namenode -format

# master node
EXPOSE 22
EXPOSE 9000

RUN chmod +x master.sh
