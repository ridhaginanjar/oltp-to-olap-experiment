import polars as pl
import psycopg2
import sys

CONFIG_OLTP = {
    "host": "localhost",
    "port": 5432,
    "user": "postgres",
    "password": "postgres",
    "dbname": "postgres"
}

CONFIG_OLAP = {
    "host": "localhost",
    "port": 5432,
    "user": "postgres",
    "password": "postgres",
    "dbname": "northwind_olap"
}

def main():
    try:
        conn = psycopg2.connect(**CONFIG_OLAP)
        conn.autocommit = True

        with conn.cursor() as cur:
            cur.execute("SELECT version(), current_database(), current_user, now(); ")
            version,db,user,now = cur.fetchone()
        
        print("✅ CONNECT OK")
        print(f"   - current_database(): {db}")
        print(f"   - current_user:       {user}")
        print(f"   - server_time:        {now}")
        print(f"   - version:            {version.splitlines()[0]}")

        conn.close()
    except Exception as e:
        print(e)
        sys.exit(1)

if __name__ == '__main__':
    main()