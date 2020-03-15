import os
from pymongo import MongoClient
from pymysql import connect

# Mongo
client = MongoClient(os.getenv("MONGO_URI"))
client.database_names()

# Mysql
host, port = os.getenv("MYSQL_URI").split(":")
conn = connect(
    host=host,
    port=int(port),
    user="root",
    password="",
    db="mysql",
    charset="utf8mb4",
)

cursor = conn.cursor()
cursor.execute("show tables")
cursor.fetchall()
