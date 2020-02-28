download:
	wget -P ./cluster https://archive.apache.org/dist/hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz

build:
	docker-compose build
