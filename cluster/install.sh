# sed -i '$ a . path.sh' .bashrc

export HADOOP_PREFIX=$HADOOP_INSTALL

etc_hadoop=${HADOOP_INSTALL}/etc/hadoop
#hdfs_dir="$( mktemp -d /tmp/hadoop.XXXXXX )"
hdfs_dir="${PROJECT_HOME}/hdfsdata"
master="master"  # TODO: env
# master=$(head -n 1 ${PROJECT_HOME}/master)
# cp $PROJECT_HOME/slaves_no_master $HADOOP_INSTALL/etc/hadoop/slaves

echo 
echo "***************************************************************************"
echo modifying ${HADOOP_INSTALL}/etc/hadoop/hadoop-env.sh
echo setting export JAVA_HOME=${JAVA_HOME}
echo "***************************************************************************"
sed -i -e "s|^export JAVA_HOME=\${JAVA_HOME}|export JAVA_HOME=$JAVA_HOME|g" ${HADOOP_INSTALL}/etc/hadoop/hadoop-env.sh

cat <<EOF > ${etc_hadoop}/core-site.xml
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://${master}:9000</value>
    <description>NameNode URI</description>
  </property>
</configuration>
EOF

cat <<EOF > ${etc_hadoop}/hdfs-site.xml
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>3</value>
  </property>

  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file://${hdfs_dir}/datanode</value>
    <description>Comma separated list of paths on the local filesystem of a DataNode where it should store its blocks.</description>
  </property>
 
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file://${hdfs_dir}/namenode</value>
    <description>Path on the local filesystem where the NameNode stores the namespace and transaction logs persistently.</description>
  </property>

  <property>
    <name>dfs.namenode.datanode.registration.ip-hostname-check</name>
    <value>false</value>
    <description>http://log.rowanto.com/why-datanode-is-denied-communication-with-namenode/</description>
  </property>
</configuration>
EOF


cat <<EOF > ${etc_hadoop}/mapred-site.xml
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


cat <<EOF > ${etc_hadoop}/yarn-site.xml
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>${master}</value>
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



