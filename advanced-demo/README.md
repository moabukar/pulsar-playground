# setup environment

download/install virtualbox
https://www.virtualbox.org/wiki/Downloads

download/install centos
https://www.centos.org/download/

create VM

#update OS
yum update -y

install guest tools

# modify OS params

share vim tutorial
https://opensource.com/article/19/3/getting-started-vim

add user to sudoers

/etc/sysctl.conf
	vm.swappiness=0
	fs.file-max=100000

/etc/pam.d/login
	session required pam_limits.so

/etc/security/limits.conf
	pulsar soft nofile unlimited
	pulsar hard nofile unlimited

create clones

change hostnames

add to /etc/hosts file

install clusterssh

verify connectivity



systemctl stop firewalld
systemctl disable firewalld

install java
yum install java-11-openjdk

# create install dir in opt
mkdir -p /opt/training/apps
mkdir -p /opt/training/src

download pulsar
cd /opt/training/src
wget https://archive.apache.org/dist/pulsar/pulsar-2.7.0/apache-pulsar-2.7.0-bin.tar.gz



# untar src files
cd /opt/training/apps
tar -xf ../src/apache-pulsar-2.7.0-bin.tar.gz

# create symlink in apps dir
ln -s apache-pulsar-2.7.0/ pulsar

# edit zookeeper config
mkdir -p /opt/training/apps/data/zookeeper
vim /opt/training/apps/data/zookeeper/myid

vim /opt/training/apps/pulsar/conf/zookeeper.conf

	dataDir=/opt/training/apps/data/zookeeper

	server.1=192.168.1.145:2888:3888
	server.2=192.168.1.140:2888:3888
	server.3=192.168.1.119:2888:3888

# add users
useradd -M pulsar
usermod -L pulsar

chown -R pulsar:pulsar /opt/training


vim /etc/systemd/system/zookeeper.service
systemctl daemon-reload
systemctl start zookeeper

bin/pulsar initialize-cluster-metadata   --cluster pulsar-training-01   --zookeeper pulsartraining01:2181   --configuration-store pulsartraining01:2181   --web-service-url http://pulsartraining01:8080,pulsartraining02:8080,pulsartraining03:8080   --web-service-url-tls https://pulsartraining01:8443,pulsartraining02:8443,pulsartraining03:8443   --broker-service-url pulsar://pulsartraining01:6650,pulsartraining02:6650,pulsartraining03:8443   --broker-service-url-tls pulsar+ssl://pulsartraining01:6651,pulsartraining02:6651,pulsartraining03:6652




# start zookeeper if restarted
systemctl start zookeeper

# edit bookkeeper config files


zkServers=pulsartraining01:2181,pulsartraining02:2181,pulsartraining03:2181

vim /etc/systemd/system/bookkeeper.service

systemctl daemon-reload
systemctl start bookkeeper

# test bookkeeper
bin/bookkeeper shell bookiesanity


bin/bookkeeper shell simpletest --ensemble 3 --writeQuorum 2 --ackQuorum 2 --numEntries 2






#edit pulsar.conf file

zookeeperServers=pulsartraining01:2181,pulsartraining02:2181,pulsartraining03:2181
configurationStoreServers=pulsartraining01:2181,pulsartraining02:2181,pulsartraining03:2181

clusterName=pulsar-training-01

brokerServicePort=6650
brokerServicePortTls=6651
webServicePort=8080
webServicePortTls=8443

#edit client.conf

webServiceUrl=http://pulsartraining01:8080
brokerServiceurl=pulsar://pulsartraining01:6650

# add service files
vim /etc/systemd/system/pulsar.service

# reload daemon
systemctl daemon-reload

systemctl start pulsar

# test pulsar

bin/pulsar-client produce persistent://public/default/test -n 1 -m "Hello world Pulsar edition"

bin/pulsar-client consume persistent://public/default/test -n 100 -s "consumer-subscription-name" -t "Exclusive"







##  editing heap sizes, turning off swap

swapoff -a

vim /etc/fstab

#zookeeper
mkdir /opt/training/apps/conf

vim /opt/training/apps/conf/java.env
	export SERVER_JVMFLAGS="-Xms512m -Xmx512m -XX:+AlwaysPreTouch"

#bookkeeper
vim /opt/training/apps/pulsar/conf/bkenv.sh
	#BOOKIE_MEM=${BOOKIE_MEM:-${PULSAR_MEM:-"-Xms2g -Xmx2g -XX:MaxDirectMemorySize=2g"}}
	BOOKIE_MEM=${BOOKIE_MEM:-${PULSAR_MEM:-"-Xms512m -Xmx512m -XX:MaxDirectMemorySize=512m"}}

#pulsar
vim /opt/training/apps/pulsar/conf/pulsar_env.sh
	#PULSAR_MEM=${PULSAR_MEM:-"-Xms2g -Xmx2g -XX:MaxDirectMemorySize=4g"}
	PULSAR_MEM=${PULSAR_MEM:-"-Xms512m -Xmx512m -XX:MaxDirectMemorySize=1g"}







##  Example use case

# message deduplication
vim /opt/training/apps/pulsar/conf/broker.conf
	brokerDeduplicationEnabled=true

#### create partitioned topic
# create tenant
./pulsar-admin tenants create pulsartraining-tenant1

# create namespace
./pulsar-admin namespaces create pulsartraining-tenant1/pulsartraining-namespace1

# create partitioned topic
./pulsar-admin topics create-partitioned-topic persistent://pulsartraining-tenant1/pulsartraining-namespace1/stock-topic-partitioned1  --partitions 12

# message deduplication
vim /opt/training/apps/pulsar/conf/broker.conf
	brokerDeduplicationEnabled=true

# do not configure transactions