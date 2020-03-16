# Big Data

Assignments for big data class, spring semester 2019-20, MIMUW.

Contains dockerized hadoop+mapreduce setup that can be deployed
using docker-compose or using ssh (eg. on `students` server).

You can find detailed descriptions of assignments and lectures on
the [course website](https://sites.google.com/site/pdd20192020/).


## Setup

### Preparation

1. Download hadoop to `cluster` directory, and zeppelin to `zeppelin` directory
```shell
make download
```

2. Use docker setup or manual installation on a virtual machine (described below)


### Running on Docker

> If you want to run the cluster directly on a host / virtual machine, skip this section.

In Docker, the project root directory is mapped to `/usr/src`.
To prepare and build the docker image (shared between master and slave nodes):
```shell
docker-compose build
```

After that, the cluster (master + 2 slaves, pseudo-distributed) can be started using:
```
make first-run
```
The volume `hdfsdata` is mounted to all services, therefore slaves share the
data with master directly (the definition of pseudo-distributed mode).

In order to format the namenode properly, the `first-run` uses `flags` directory,
which is mounted as a docker volume and reflects all changes to the cluster state
locally. After `first-run`, the `flags/format-hdfs` file is deleted and
`make run` command can be used to start the cluster without losing data.

Commands can be executed on the running cluster from another terminal, ie:
```shell
# in terminal 1 - start entire cluster (this will take up to 1min):
make run

# in terminal 2 - connect to bash terminal running in the master container:
docker-compose exec master bash

# run examples on the master terminal:
hdfs dfs -mkdir /user
hdfs dfs -put hadoop-2.8.5/etc/hadoop /user/
yarn jar hadoop-2.8.5/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.5.jar grep /user/hadoop/hadoop-env.sh output 'dfs[a-z.]+'
```

The cluster web ui is exposed at: [http://localhost:50070/](http://localhost:50070/).

Applications located in `applications/*` subdirectories are mounted under `usr/src/applications`,
which makes them synchronized with the host and accessible from the container.

#### Zeppelin & Spark

Zeppelin server is currently configured as a separate service, not even running
on HDFS. Volumes for `data` and `zeppelin/notebooks` are created for sharing files
between container and the host.

*NOTE: Currently, all notebooks are in .gitignore (only applications are versioned)*


#### Jupyter & Spark

Jupyter is currently configured as a separate service (single Spark node), 
not even running on HDFS - same as for zeppelin+spark service.
Volumes for `data` (same one as for `zeppelin` service) and `jupyter/notebooks` 
(different from `zeppelin`, as the notebook format is not the same) 
are created for sharing files between container and the host.

*NOTE: Currently, all notebooks are in .gitignore (only applications are versioned)*


### Running locally / on virtual machines

> If you want to run the cluster on docker, skip this section.

1. Copy all files to the desired remote machine (HOST):
```shell
export DEPLOY_HOST=students
ssh $DEPLOY_HOST mkdir big-data
scp -r * $DEPLOY_HOST:~/big-data/
```

2. On the machine that will serve as a master node:
```shell
# set all environment variables - edit local.env to configure
source local.env
chmod +x scripts/*.sh

# install hadoop with all dependencies
./scripts/install.sh

# before starting cluster, make sure the slaves are correctly defined:
cat cluster/slaves  # edit this file to change hosts for slaves

# ensure that directories for namenode and datanodes exist on all machines
./scripts/copy.sh

# run examples on the master terminal:
hdfs dfs -mkdir /user
hdfs dfs -put hadoop-2.8.5/etc/hadoop /user/
yarn jar hadoop-2.8.5/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.5.jar grep /user/hadoop/hadoop-env.sh output 'dfs[a-z.]+'
```

#### Zeppelin & Spark

Current setup does not allow manual (local) installation of zeppelin & spark.


## Troubleshooting

### Apt complainign about invalid IP address (repository not found)

This is because repositories can change IP, but since Docker build context 
has not changed, the result of `apt update` will be loaded from cache.

To fix, simply run build without cache:
```shell
docker-compose build --no-cache [services]
```


## TODOs

- [ ] add scripts for setting up on students / local server:
    - [ ] zeppelin
    - [ ] jupyter
