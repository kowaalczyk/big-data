#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# wget -P ./download --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz

# wget -P ./download http://www-us.apache.org/dist/hadoop/common/hadoop-2.8.3/hadoop-2.8.3.tar.gz


wget -P ./download http://ftp.man.poznan.pl/apache/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz


# tar -xvf ~/download/jdk-8u161-linux-x64.tar.gz -C ~/cluster
tar -xvf ~/download/hadoop-2.8.3.tar.gz -C ~/cluster

