FROM hadoop_spark_cluster:datamaking_spark

MAINTAINER Pari Margu <pari.margu2020@gmail.com>

USER root

# get sources
RUN apt-get install -y libpostgresql-jdbc-java
#RUN wget https://archive.apache.org/dist/hive/hive-2.3.4/apache-hive-2.3.4-bin.tar.gz -P /home/hadoop/
#RUN tar -xzf /home/hadoop/apache-hive-2.3.4-bin.tar.gz -C /home/hadoop/
ADD datamaking_hive/apache-hive-2.3.7-bin.tar.gz /home/hadoop
RUN mv /home/hadoop/apache-hive-2.3.7-bin /home/hadoop/hive
#RUN rm -rf /home/hadoop/apache-hive-2.3.7*

# set environment variables
ENV HIVE_HOME /home/hadoop/hive
ENV PATH $HIVE_HOME/bin:$PATH

RUN cp /usr/share/java/postgresql-jdbc4.jar /home/hadoop/hive/lib/
ADD configs/hive-site.xml $HIVE_HOME/conf/hive-site.xml
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /home/hadoop/hive/bin/hive-config.sh
RUN chown hadoop -R /home/hadoop/hive
RUN export LANGUAGE=en_US.UTF-8
