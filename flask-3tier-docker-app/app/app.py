from flask import Flask, jsonify, render_template
import mysql.connector
import redis
import os

app = Flask(__name__)

# MySQL connection
db = mysql.connector.connect(
    host=os.getenv("MYSQL_HOST"),
    user=os.getenv("MYSQL_USER"),
    password=os.getenv("MYSQL_PASSWORD"),
    database=os.getenv("MYSQL_DB")
)

# Redis connection
cache = redis.Redis(host=os.getenv("REDIS_HOST"), port=6379, decode_responses=True)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/api/visits")
def visits():
    visits = cache.get("visits")

    if visits:
        return jsonify({"visits": int(visits), "source": "cache"})

    cursor = db.cursor()
    cursor.execute("CREATE TABLE IF NOT EXISTS counter (id INT PRIMARY KEY, visits INT)")
    cursor.execute("INSERT IGNORE INTO counter (id, visits) VALUES (1, 0)")
    cursor.execute("UPDATE counter SET visits = visits + 1 WHERE id = 1")
    db.commit()

    cursor.execute("SELECT visits FROM counter WHERE id=1")
    visits = cursor.fetchone()[0]

    cache.set("visits", visits, ex=30)

    return jsonify({"visits": visits, "source": "database"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
