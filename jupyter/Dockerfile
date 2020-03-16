FROM ubuntu:18.04

USER root

# install java, scala, openssh, python3
RUN apt update
RUN apt -y dist-upgrade
RUN apt install -y openssh-server
RUN apt install -y openjdk-8-jdk
ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64/"
ENV JRE_HOME "/usr/lib/jvm/java-8-openjdk-amd64/jre/"
RUN apt install -y scala

# copy and install zeppelin
COPY ./spark-2.4.5-bin-hadoop2.7.tgz /usr/src/spark/spark-2.4.5-bin-hadoop2.7.tgz
RUN tar -xzf /usr/src/spark/spark-2.4.5-bin-hadoop2.7.tgz -C /usr/src/spark
RUN rm /usr/src/spark/spark-2.4.5-bin-hadoop2.7.tgz

# install python & necessary python libraries
RUN apt install -y python3 python3-pip
RUN pip3 install jupyter numpy py4j

# port for jupyter notebooks
EXPOSE 8888

# set environment variables for spark
ENV SPARK_HOME="/usr/src/spark/spark-2.4.5-bin-hadoop2.7"
ENV PYTHONPATH="${SPARK_HOME}/python:$PYTHONPATH"
ENV PYSPARK_DRIVER_PYTHON="jupyter"
ENV PYSPARK_DRIVER_PYTHON_OPTS="notebook --allow-root --port=8888 --no-browser --ip=0.0.0.0"
ENV PYSPARK_PYTHON="python3"
ENV PATH="${SPARK_HOME}:${SPARK_HOME}/bin:${PATH}:~/.local/bin:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin"

# data directory (non-hdfs, standard file system) for passing input/output
ENV DATA_DIR="/usr/src/data"
RUN mkdir $DATA_DIR

# notebook dir, can by synced to host via docker-compose volume
ENV NOTEBOOK_DIR="/usr/src/notebooks"
RUN mkdir $NOTEBOOK_DIR

# set workdir to /usr/src/ so that both data and notebooks are immediately visible
WORKDIR "/usr/src"

CMD ["pyspark"]
