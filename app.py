from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

# Connect to MySQL
db = mysql.connector.connect(
    host=os.getenv("MYSQL_HOST"),
    user=os.getenv("MYSQL_USER"),
    password=os.getenv("MYSQL_PASSWORD"),
    database=os.getenv("MYSQL_DATABASE")
)


# HOME PAGE
@app.route("/")
def home():
    return render_template("index.html")


# Login page
@app.route("/login", methods=["GET", "POST"])
def login():

    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        cursor = db.cursor(dictionary=True)

        sql = """
        SELECT * FROM users
        WHERE username = %s AND password = %s
        """

        cursor.execute(sql, (username, password))
        user = cursor.fetchone()

        cursor.close()

        if user:
            return redirect(url_for("home"))
        else:
            return "Incorrect username or password"

    return render_template("login.html")


# REGISTER PAGE
@app.route("/register", methods=["GET", "POST"])
def register():

    if request.method == "POST":

        first_name = request.form["first_name"]
        last_name = request.form["last_name"]
        birthdate = request.form["birthdate"]
        username = request.form["username"]
        password = request.form["password"]

        cursor = db.cursor()

        # Check whether username already exists
        cursor.execute(
            "SELECT user_id FROM users WHERE username = %s",
            (username,)
        )

        existing_user = cursor.fetchone()

        if existing_user:
            cursor.close()
            return render_template(
                "register.html",
                error="Username already taken."
            )

        # Create account
        sql = """
        INSERT INTO users
        (first_name, last_name, birthdate, username, password)
        VALUES (%s, %s, %s, %s, %s)
        """

        values = (
            first_name,
            last_name,
            birthdate,
            username,
            password
        )

        cursor.execute(sql, values)
        db.commit()

        cursor.close()

        # Send new user to login page
        return redirect(url_for("login"))

    return render_template("register.html")


if __name__ == "__main__":
    app.run(debug=True)