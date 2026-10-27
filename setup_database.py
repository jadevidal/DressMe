
import os
import mysql.connector
from dotenv import load_dotenv

load_dotenv()

db = mysql.connector.connect(
    host=os.getenv("MYSQL_HOST"),
    port=int(os.getenv("MYSQL_PORT")),
    user=os.getenv("MYSQL_USER"),
    password=os.getenv("MYSQL_PASSWORD"),
    database=os.getenv("MYSQL_DATABASE")
)

try:
    cursor = db.cursor()

    with open("database_setup.sql", "r") as file:
        sql_script = file.read()

    for statement in sql_script.split(";"):
        if statement.strip():
            cursor.execute(statement)

    db.commit()

    print("DressMe tables created successfully!")

    cursor.execute("SHOW TABLES")

    for table in cursor.fetchall():
        print(table[0])

    cursor.close()

finally:
    db.close()
