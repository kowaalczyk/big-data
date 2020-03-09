FROM ubuntu:18.04

USER root

# install java & openssh
RUN apt update
RUN apt -y dist-upgrade
RUN apt install -y openssh-server openjdk-8-jdk
ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64/"

# copy and install zeppelin
COPY ./zeppelin-0.8.2-bin-all.tgz /usr/src/zeppelin/zeppelin-0.8.2-bin-all.tgz
RUN tar -xzf /usr/src/zeppelin/zeppelin-0.8.2-bin-all.tgz -C /usr/src/zeppelin
RUN rm /usr/src/zeppelin/zeppelin-0.8.2-bin-all.tgz

# working directory is zeppelin, but all zeppelin scripts are directly in PATH
WORKDIR /usr/src/zeppelin
ENV ZEPPELIN_HOME="/usr/src/zeppelin/zeppelin-0.8.2-bin-all"
ENV PATH="${PATH}:${JAVA_HOME}/bin:${ZEPPELIN_HOME}/bin"

# necessary addresses, otherwise there is no connection from container to host
ENV ZEPPELIN_ADDR="0.0.0.0"
ENV ZEPPELIN_PORT="8080"
EXPOSE 8080

# data directory (non-hdfs, standard file system) for passing input/output
ENV DATA_DIR="/usr/src/data"
RUN mkdir $DATA_DIR

# notebook dir, can by synced to host via docker-compose volume
ENV ZEPPELIN_NOTEBOOK_DIR="/usr/src/notebooks"
RUN mkdir $ZEPPELIN_NOTEBOOK_DIR

# that way, docker logs will contain zeppelin logs
CMD ["zeppelin-daemon.sh", "upstart"]
