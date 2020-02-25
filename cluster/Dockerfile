FROM openjdk:8

# this sets up hadoop in the semi-distributed mode
COPY ./hadoop-2.9.2.tar.gz /usr/src/cluster/hadoop-2.9.2.tar.gz
RUN tar -xvzf /usr/src/cluster/hadoop-2.9.2.tar.gz -C /usr/src/cluster
RUN rm /usr/src/cluster/hadoop-2.9.2.tar.gz

COPY . /usr/src/cluster
WORKDIR /usr/src/cluster

ENV PROJECT_HOME "/usr/src/cluster"
ENV HADOOP_INSTALL "/usr/src/cluster/hadoop-2.9.2"
ENV PATH "${JAVA_HOME}/bin:${HADOOP_INSTALL}/bin:${HADOOP_INSTALL}/sbin:${PATH}"

RUN chmod +x install.sh
RUN ./install.sh

# master node
EXPOSE 9000
