
from flask import Flask, render_template, request, redirect, url_for, jsonify
import mysql.connector
import os
from dotenv import load_dotenv
from werkzeug.security import generate_password_hash, check_password_hash

load_dotenv()

app = Flask(__name__)

# Connect to MySQL
db = mysql.connector.connect(
    host=os.getenv("MYSQL_HOST"),
    port=int(os.getenv("MYSQL_PORT")),
    user=os.getenv("MYSQL_USER"),
    password=os.getenv("MYSQL_PASSWORD"),
    database=os.getenv("MYSQL_DATABASE")
)


# HOME PAGE
@app.route("/")
def home():
    return render_template("index.html")

# check username availability
@app.route("/check_username", methods=["GET"])
def check_username():
    username = request.args.get("username", "").strip()
    
    if not username:
        return jsonify({"exists": False})

    cursor = db.cursor()
    
    # Query your MySQL users table for an exact username match
    sql = "SELECT user_id FROM users WHERE username = %s"
    cursor.execute(sql, (username,))
    existing_user = cursor.fetchone()
    
    cursor.close()

    # Returns True if a record is found, otherwise False
    return jsonify({"exists": bool(existing_user)})

# Login page
@app.route("/login", methods=["GET", "POST"])
def login():

    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        cursor = db.cursor(dictionary=True)

        sql = """
        SELECT * FROM users
        WHERE username = %s
        """

        cursor.execute(sql, (username,))
        user = cursor.fetchone()

        cursor.close()

        if user and check_password_hash(user["password"], password):
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
        email = request.form["email"]
        password = request.form["password"]

        cursor = db.cursor()

        # Check whether username or email already exists
        cursor.execute(
            "SELECT user_id FROM users WHERE username = %s OR email = %s",
            (username, email)
        )

        existing_user = cursor.fetchone()

        if existing_user:
            cursor.close()
            return render_template(
                "register.html",
                error="Username or email already taken."
            )

        # Create account
        sql = """
        INSERT INTO users
        (first_name, last_name, birthdate, username, email, password)
        VALUES (%s, %s, %s, %s, %s, %s)
        """

        values = (
            first_name,
            last_name,
            birthdate,
            username,
            email,
            generate_password_hash(password)
        )

        cursor.execute(sql, values)
        db.commit()

        cursor.close()

        # Send new user to login page
        return redirect(url_for("login"))

    return render_template("register.html")


if __name__ == "__main__":
    app.run(debug=True, port=5001
    )
