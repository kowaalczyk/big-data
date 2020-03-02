#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo 
echo "***************************************************************************"
# TODO: Config / environment variable (but don't export, it can break hadoop)
HADOOP_CONF_DIR=${HADOOP_INSTALL}/etc/hadoop
echo "modifying ${HADOOP_CONF_DIR}/hadoop-env.sh"

echo "setting export JAVA_HOME=${JAVA_HOME}"
sed -i -e "s|^export JAVA_HOME=\${JAVA_HOME}|export JAVA_HOME=$JAVA_HOME|g" ${HADOOP_CONF_DIR}/hadoop-env.sh

echo "setting export HADOOP_CONF_DIR=${HADOOP_CONF_DIR}"
sed -i -e "s|/etc/hadoop|$HADOOP_CONF_DIR|g" ${HADOOP_CONF_DIR}/hadoop-env.sh

echo "***************************************************************************"
cat ${HADOOP_INSTALL}/etc/hadoop/hadoop-env.sh
echo "***************************************************************************"

echo
echo "***************************************************************************"
echo "adding list of slaves to ${HADOOP_CONF_DIR}"
echo "***************************************************************************"
cp slaves $HADOOP_CONF_DIR/slaves

cat <<EOF > ${HADOOP_CONF_DIR}/core-site.xml
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://${MASTER_HOST_NAME}:9000</value>
    <description>NameNode URI</description>
  </property>
</configuration>
EOF

cat <<EOF > ${HADOOP_CONF_DIR}/hdfs-site.xml
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>2</value>
  </property>

  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file://${CUSTOM_HDFS_DIR}/datanode</value>
    <description>Comma separated list of paths on the local filesystem of a DataNode where it should store its blocks.</description>
  </property>
 
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file://${CUSTOM_HDFS_DIR}/namenode</value>
    <description>Path on the local filesystem where the NameNode stores the namespace and transaction logs persistently.</description>
  </property>

  <property>
    <name>dfs.namenode.datanode.registration.ip-hostname-check</name>
    <value>false</value>
    <description>http://log.rowanto.com/why-datanode-is-denied-communication-with-namenode/</description>
  </property>
</configuration>
EOF


cat <<EOF > ${HADOOP_CONF_DIR}/mapred-site.xml
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.map.memory.mb</name>
        <value>16384</value>
    </property>
    <property>
        <name>mapreduce.map.java.opts</name>
        <value>-Xmx15384m</value>
    </property>
    <property>
        <name>mapreduce.reduce.memory.mb</name>
        <value>16384</value>
    </property>
    <property>
        <name>mapreduce.reduce.java.opts</name>
        <value>-Xmx15384m</value>
    </property>
</configuration>
EOF


cat <<EOF > ${HADOOP_CONF_DIR}/yarn-site.xml
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>${MASTER_HOST_NAME}</value>
    </property>
    <property>
        <name>yarn.nodemanager.vmem-check-enabled</name>
        <value>false</value>
    </property>
    <property>
      <name>yarn.nodemanager.resource.memory-mb</name>
      <value>25000</value>
    </property>
    <property>
      <name>yarn.scheduler.maximum-allocation-mb</name>
      <value>16384</value>
      <description>Max RAM-per-container https://stackoverflow.com/questions/43826703/difference-between-yarn-scheduler-maximum-allocation-mb-and-yarn-nodemanager</description>
   </property>
</configuration>
EOF

echo
echo "***************************************************************************"
echo "preparing namenode and datanode in $CUSTOM_HDFS_DIR"
echo "***************************************************************************"
rm -fr $CUSTOM_HDFS_DIR
mkdir $CUSTOM_HDFS_DIR
mkdir $CUSTOM_HDFS_DIR/namenode
mkdir $CUSTOM_HDFS_DIR/datanode
