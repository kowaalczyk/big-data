#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ ! -e "scripts" ]]; then
    echo "This script should be executed from project root"
    exit 2
fi

if [[ -z "$PREFIX" ]]; then
    echo "No prefix specified, you should do this before installation:"
    echo "source local.env"
    exit 2
fi

echo "Using hadoop from $PREFIX"

user="$USER"

while read name
do
  echo "============================== syncing to:" $name "==================================="
  ssh -n $user@$name rm -fr "$CUSTOM_HDFS_DIR"
  ssh -n $user@$name mkdir $CUSTOM_HDFS_DIR
  ssh -n $user@$name mkdir $CUSTOM_HDFS_DIR/datanode
  rsync -zrvhae ssh $CUSTOM_CLUSTER_DIR $user@$name:
  rsync -zrvhae ssh $CUSTOM_HDFS_DIR $user@$name:
done < cluster/slaves

while read name
do
  echo "============================== syncing applications to:" $name "==================================="
  rsync -zrvhae ssh $APPLICATIONS_DIR $user@$name:
done < cluster/slaves

# workdir cluster
pushd cluster

echo 
echo "***************************************************************************"
echo hdfs namenode -format
echo "***************************************************************************"
hdfs namenode -format

popd
