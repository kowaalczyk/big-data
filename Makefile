download:
	wget -P ./cluster -O 'cluster/hadoop-2.8.5.tar.gz' https://archive.apache.org/dist/hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz
	wget -P ./zeppelin -O 'zeppelin/zeppelin-0.8.2-bin-all.tgz' https://downloads.apache.org/zeppelin/zeppelin-0.8.2/zeppelin-0.8.2-bin-all.tgz

clean-volumes:
	docker volume prune -f

build:
	docker-compose build

flags:
	-mkdir flags

enable-hdfs-format: flags
	echo "# when this file exists on cluster startup, the namenode will be formatted" > flags/format-hdfs

disable-hdfs-format:
	rm flags/format-hdfs

run:
	docker-compose up

first-run: flags enable-hdfs-format run
