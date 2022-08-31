# BIG DATA CLUSTER
### Test big data cluster for testing technologies and stack

    command to start : 

    docker-compose -f docker-compose.yml up -d

## Containers:

    - Container slave-0-big_data_cluster           Started
    - Container slave-1-big_data_cluster           Started
    - Container postgres-big_data_cluster          Started
    - Container zookeeper-big_data_cluster         Started 
    - Container master-big_data_cluster            Started
    - Container slave-2-big_data_cluster           Started
    - Container clickhouse-2-big_data_cluster      Started
    - Container clickhouse-0-big_data_cluster      Started
    - Container clickhouse-1-big_data_cluster      Started
    - Container clickhouse-3-big_data_cluster      Started
    - Container airflow-big_data_cluster           Started
    - Container livy-big_data_cluster              Started
    - Container zeppelin-big_data_cluster          Started

## Spark-Hadoop:

    version: 
        Spark 2.4.5
        Scala 2.11.12
        Hadoop 3.2.0

    source: https://github.com/panovvv/bigdata-docker-compose

    Hadoop: hdfs://master:9000/...

    spark-submit command:
    spark-submit --class com.big_data_cluster.App --master yarn /big_data_cluster/big-data-demo-0.0.1-jar-with-dependencies.jar
## Livy:

    version: 
        Livy 0.7.0

    source: https://github.com/panovvv/bigdata-docker-compose

## Zeppelin:

    version: 
        Zeppelin 0.9.0

    source: https://github.com/panovvv/bigdata-docker-compose

## ClickHouse:

    version: 
        ClickHouse 21.3.11
  
    source: https://github.com/tetafro/clickhouse-cluster

    external URL: jdbc:clickhouse://localhost:8123
    internal URL: jdbc:clickhouse://clickhouse-0:8123
    User: clickhouse
    Password: clickhouse

    command for config clickhouse nodes: 
        make config up

    create disturbed table on cluster:
        CREATE DATABASE big_data_cluster ON CLUSTER 'big_data_cluster_click';
        CREATE TABLE big_data_cluster.events ON CLUSTER 'big_data_cluster_click' (
                                                                time DateTime,
                                                                uid  Int64,
                                                                type LowCardinality(String)
        )
        ENGINE = ReplicatedMergeTree('/clickhouse/tables/{cluster}/{shard}/table', '{replica}')
        PARTITION BY toDate(time)
        ORDER BY (uid);
        CREATE TABLE big_data_cluster.events_distr ON CLUSTER 'big_data_cluster_click' AS big_data_cluster.events
        ENGINE = Distributed('big_data_cluster_click', big_data_cluster, events, uid);

## Postgres:

    version:
        Postgres 11.8

    external URL: jdbc:postgresql://localhost:5432
    internal URL: jdbc:postgresql://postgresql:5432
    User: postgres
    Password: postgres

    DB for exexution - "big_data_cluster"
    DB for airflow - "airflow"

## Airflow:

    version:
        Airflow 2.2.1

    source: https://github.com/bitnami/bitnami-docker-airflow

    User: airflow
    Password: airflow

## Ports:
    8080    - Spark Master Web UI
    18080   - Spark History server
    8088    - YARN UI
    9870    - Hadoop name node UI
    9868    - Hadoop secondary name node UI
    9864    - Hadoop data node 0 UI
    9865    - Hadoop data node 1 UI
    9866    - Hadoop data node 2 UI
    8998    - Livy UI
    8890    - Zeppelin UI
    8085    - Airflow UI
    9866    - Postgres
    8123    - Clickhouse

## Examples:
    Load:
    val df = spark.read.format("csv").option("header", "true").option("inferSchema", "true").load("hdfs://master:9000/test/cities.csv")
    val df = spark.read.format("jdbc").option("url", "jdbc:postgresql://postgresql:5432/big_data_cluster").option("dbtable", "public.countries").option("user", "postgres").option("password", "postgres").option("driver", "org.postgresql.Driver").load
    val df = spark.read.format("jdbc").option("url", "jdbc:clickhouse://clickhouse-0:8123/big_data_cluster").option("dbtable", "cities").option("user", "clickhouse").option("password", "clickhouse").option("driver", "ru.yandex.clickhouse.ClickHouseDriver").load
    
    Save:
    df.write.format("jdbc").option("url", "jdbc:postgresql://postgresql:5432/big_data_cluster").option("dbtable", "public.brief_countries").option("user", "postgres").option("password", "postgres").option("driver", "org.postgresql.Driver").save
    df.coalesce(1).write.mode("overwrite").format("csv").option("header", "true").save("hdfs://master:9000/big_data_cluster/brief_cities")

    Common:
    df show
    df schema