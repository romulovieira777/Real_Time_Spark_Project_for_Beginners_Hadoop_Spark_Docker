package com.datamaking.apachespark101

import org.apache.spark.sql.SparkSession

object create_first_app_apachespark101_part_1 {
  def main(args: Array[String]): Unit = {
    println("Started ...")
    println("First Apache Spark 2.4.4 Application using IntelliJ IDEA in Windows 7/10 | Apache Spark 101 Tutorial | Scala API | Part 1")

    val spark = SparkSession
      .builder
      .appName("Apache Spark 101 Tutorial | Part 1")
      .master("local[*]")
      .getOrCreate()

    spark.sparkContext.setLogLevel("ERROR")

    val tech_names_list = List("spark1", "spark2", "spark3", "hadoop1", "hadoop2", "spark4")
    val names_rdd = spark.sparkContext.parallelize(tech_names_list, 3)
    val names_upper_case_rdd = names_rdd.map(ele => ele.toUpperCase())
    names_upper_case_rdd.collect().foreach(println)

    spark.stop()
    println("Completed.")

  }
}
