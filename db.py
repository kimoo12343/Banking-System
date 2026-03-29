import mysql.connector

DB_NAME = "banking_system"

def get_server_connection(host="localhost", user="root", password="Kimko777-"):
    return mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        autocommit=True
    )

def ensure_database(conn):
    cur = conn.cursor()
    cur.execute(f"CREATE DATABASE IF NOT EXISTS {DB_NAME};")
    cur.execute(f"USE {DB_NAME};")
    cur.close()

def run_sql_file(conn, sql_path: str):
    ensure_database(conn)
    with open(sql_path, "r", encoding="utf-8") as f:
        script = f.read()

    # split statements by semicolon
    statements = [s.strip() for s in script.split(";") if s.strip()]

    cur = conn.cursor()
    for stmt in statements:
        cur.execute(stmt)
    cur.close()

def get_db_connection(host="localhost", user="root", password="YOUR_PASSWORD"):
    return mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database=DB_NAME,
        autocommit=True
    )

def fetch_all(conn, query: str):
    cur = conn.cursor()
    cur.execute(query)
    cols = [d[0] for d in cur.description]
    rows = cur.fetchall()
    cur.close()
    return cols, rows