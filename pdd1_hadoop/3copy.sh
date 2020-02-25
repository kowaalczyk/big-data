home=/home/ala
hdfs_dir="${home}/hdfsdata"
cluster_dir="${home}/cluster"
code_dir="${home}/SortAvroRecord"

rm -fr $hdfs_dir
mkdir $hdfs_dir
mkdir $hdfs_dir/namenode
mkdir $hdfs_dir/datanode

user=ala
cd $home

while read name
do
  echo "============================== syncing to:" $name "==================================="
  
  ssh -n $user@$name rm -fr "$hdfs_dir"
  ssh -n $user@$name mkdir $hdfs_dir
  ssh -n $user@$name mkdir $hdfs_dir/datanode
  rsync -zrvhae ssh $cluster_dir $user@$name:
  rsync -zrvhae ssh $hdfs_dir $user@$name:
done < slaves_no_master

while read name
do
  echo "============================== syncing sources to:" $name "==================================="
  
  rsync -zrvhae ssh $code_dir $user@$name:
done < slaves_no_master

echo 
echo "***************************************************************************"
echo hdfs namenode -format
echo "***************************************************************************"
# Format the namenode directory (DO THIS ONLY ONCE, THE FIRST TIME)
hdfs namenode -format
