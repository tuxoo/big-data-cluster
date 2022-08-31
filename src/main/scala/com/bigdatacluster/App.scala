package com.bigdatacluster

import scala.util.Random
import java.time.Instant
import java.sql.Timestamp
import org.apache.spark.sql.{DataFrame, Row, SparkSession}
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions.{col, udf}

object App extends App {

    val spark = SparkSession.builder()
      .master("local[*]")
      .appName("demo")
      .getOrCreate

    val dfFirst: DataFrame = spark
      .read
      .format("csv")
      .option("header", "true")
      .option("inferSchema", "true")
      .load("hdfs://master:9000/big-data-cluster/cities.csv")

  dfFirst.select("id", "name", "country_code", "country_name")
      .orderBy("id")
      .coalesce(1)
      .write
      .mode("overwrite")
      .format("csv")
      .option("header", "true")
      .save("hdfs://master:9000/big-data-cluster/brief_cities")

  val timeSchema = List(StructField("current_time", TimestampType, true), StructField("char", StringType, true))
  val time = Seq(Row(Timestamp.from(Instant.now()), Random.nextString(10)))
  val dfSecond = spark.createDataFrame(spark.sparkContext.parallelize(time), StructType(timeSchema))

  dfSecond.write
    .mode("append")
    .format("jdbc")
    .option("url", "jdbc:postgresql://postgresql:5432/big_data_cluster")
    .option("dbtable", "public.counter_time").option("user", "postgres")
    .option("password", "postgres")
    .option("driver", "org.postgresql.Driver")
    .save
}
