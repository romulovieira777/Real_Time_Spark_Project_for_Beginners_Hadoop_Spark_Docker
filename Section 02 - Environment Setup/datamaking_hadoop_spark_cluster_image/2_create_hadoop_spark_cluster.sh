#!/bin/bash

# Bring the services up
function startServices {
  docker start masternode
  sleep 5
  echo ">> Starting hdfs ..."
  docker exec -u hadoop -it masternode start-dfs.sh
  sleep 5
  echo ">> Starting yarn ..."
  docker exec -u hadoop -d masternode start-yarn.sh
  sleep 5
  echo ">> Starting MR-JobHistory Server ..."
  docker exec -u hadoop -d masternode mr-jobhistory-daemon.sh start historyserver
  sleep 5
  echo ">> Starting Spark ..."
  docker exec -u hadoop -d masternode start-master.sh
  docker exec -u hadoop -d masternode start-slave.sh masternode:7077
  sleep 5
  echo ">> Starting Spark History Server ..."
  docker exec -u hadoop masternode start-history-server.sh
  sleep 5
  echo ">> Preparing hdfs for hive ..."
  docker exec -u hadoop -it masternode hdfs dfs -mkdir -p /tmp
  docker exec -u hadoop -it masternode hdfs dfs -mkdir -p /user/hive/warehouse
  docker exec -u hadoop -it masternode hdfs dfs -chmod g+w /tmp
  docker exec -u hadoop -it masternode hdfs dfs -chmod g+w /user/hive/warehouse
  sleep 5
  echo ">> Starting Hive Metastore ..."
  docker exec -u hadoop -d masternode hive --service metastore
  docker exec -u hadoop -d masternode hive --service hiveserver2
  echo "Hadoop info @ masternode: http://172.20.1.1:8088/cluster"
  echo "DFS Health @ masternode : http://172.20.1.1:50070/dfshealth"
  echo "MR-JobHistory Server @ masternode : http://172.20.1.1:19888"
  echo "Spark info @ masternode  : http://172.20.1.1:8080"
  echo "Spark History Server @ masternode : http://172.20.1.1:18080"
}

function stopServices {
  echo ">> Stopping Spark Master and slaves ..."
  docker exec -u hadoop -d masternode stop-master.sh
  docker exec -u hadoop -d masternode stop-slave.sh
  echo ">> Stopping containers ..."
  docker stop masternode postgresqlnode
}

if [[ $1 = "create" ]]; then
  docker network create --subnet=172.20.0.0/16 datamakingnet # create custom network

  # Starting Postresql Hive metastore
  echo ">> Starting postgresql hive metastore ..."
  docker run -d --net datamakingnet --ip 172.20.1.2 -p 5432:5432 --hostname postgresqlnode --name postgresqlnode -e POSTGRES_PASSWORD=hive -it hadoop_spark_cluster:datamaking_postgresql
  sleep 5
  
  # 3 nodes
  echo ">> Starting master node ..."
  docker run -d --net datamakingnet --ip 172.20.1.1 -p 50070:50070 -p 50010:50010 -p 8088:8088 -p 8032:8032 -p 10000:10000 -p 7077:7077 -p 9000:9000 -p 19888:19888 -p 8080:8080 -p 18080:18080 --hostname masternode --add-host postgresqlnode:172.20.1.2 --add-host zookeepernode:172.20.1.3 --add-host kafkanode:172.20.1.4 --name masternode -it hadoop_spark_cluster:datamaking_hive

  # Format masternode
  echo ">> Formatting hdfs ..."
  docker exec -u hadoop -it masternode hdfs namenode -format
  startServices
  exit
fi


if [[ $1 = "stop" ]]; then
  stopServices
  exit
fi


if [[ $1 = "start" ]]; then  
  docker start postgresqlnode masternode
  startServices
  exit
fi


echo "Usage: 1_create_hadoop_spark_image.sh create|start|stop"
echo "                 create - Prepare to run and start for first time all containers"
echo "                 start  - start existing containers"
echo "                 stop   - stop running processes"
