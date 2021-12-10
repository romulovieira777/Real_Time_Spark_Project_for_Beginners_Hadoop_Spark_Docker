# Importing Spark Related Packages
from pyspark.sql import SparkSession

# Importing Python Related Packages

def upper(input):
    output = None
    output = input.upper()
    return output

if __name__ == "__main__":
    print("Application Started ...")

    spark = SparkSession \
            .builder \
            .appName("First PySpark Demo") \
            .master("local[*]") \
            .getOrCreate()

    input_file_path = "file:///home/dmadmin/datamaking/data/pyspark101/input/tech.txt"

    tech_rdd = spark.sparkContext.textFile(input_file_path)

    print("Printing data in the tech_rdd: ")
    print(tech_data.collect())

    print("Application Completed.")
    spark.stop()
