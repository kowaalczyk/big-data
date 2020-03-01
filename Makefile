download:
	wget -P ./cluster https://archive.apache.org/dist/hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz

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
