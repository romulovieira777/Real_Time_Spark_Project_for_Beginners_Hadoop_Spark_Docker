#!/bin/bash

# generate ssh key
echo "Y" | ssh-keygen -t rsa -P "" -f configs/id_rsa

# Building Hadoop Docker Image
docker build -f ./datamaking_hadoop/Dockerfile . -t hadoop_spark_cluster:datamaking_hadoop

# Building Spark Docker Image
docker build -f ./datamaking_spark/Dockerfile . -t hadoop_spark_cluster:datamaking_spark

# Building PostgreSQL Docker Image for Hive Metastore Server
docker build -f ./datamaking_postgresql/Dockerfile . -t hadoop_spark_cluster:datamaking_postgresql

# Building Hive Docker Image
docker build -f ./datamaking_hive/Dockerfile . -t hadoop_spark_cluster:datamaking_hive

