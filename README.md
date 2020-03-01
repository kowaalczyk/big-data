# Big Data

## Setup

In Docker, the project root directory is mapped to `/usr/src`.
To prepare and build the docker image (shared between master and slave nodes):
```shell
make download
make build
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

### Running locally / on virtual machines

File `cluster/local.env` provides configuration for running cluster in a local
network rather then docker (ie. via SSH). For now, this only includes 
environment variables that are normally set in `Dockerfile` and was not tested
on a running server.
