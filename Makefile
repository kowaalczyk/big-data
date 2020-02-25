download:
	wget -P ./cluster http://ftp.man.poznan.pl/apache/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz

build:
	docker-compose build
