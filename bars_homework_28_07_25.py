#--1
import psycopg2
import psycopg2.extras
try:
    conn = psycopg2.connect(
        dbname='postgres',
        user='user',
        password='admin',
        host='localhost',
        port='5432',
        cursor_factory=psycopg2.extras.RealDictCursor
    )
    print("Connected successfully.")
except psycopg2.Error as e:
    print("Connection error:", e)

#--2
try:
    cur = conn.cursor()
    cur.execute("""
CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    price NUMERIC(6, 2) NOT NULL,
    in_stock BOOLEAN DEFAULT TRUE
        );
    """)
    conn.commit()
    print("Table created.")
except psycopg2.Error as e:
    print("Error creating table:", e)
finally:
    cur.close()


products_table_info=(('Laptop', 3200.50, True),
                     ('Mouse', 99.99, True),
                     ('Keyboard', 250.00, False),
                     ('Monitor', 1190.95, True))
try:
    cur = conn.cursor()
    cur.executemany(
        """
    INSERT INTO products (name, price, in_stock)
    VALUES (%s, %s, %s)
    ON CONFLICT (name) DO NOTHING;
    """,
    products_table_info)
    conn.commit()
    print("Data inserted.")
except psycopg2.Error as e:
    print("Insert error:", e)
finally:
    cur.close()

#--3
try:
    cur = conn.cursor()
    cur.execute("SELECT * FROM products "
                "WHERE in_stock = TRUE;")
    rows = cur.fetchall()
    for row in rows:
        print(row)
except psycopg2.Error as e:
    print("Select error:", e)
finally:
    cur.close()

#--------------STREAMLIT
import streamlit as st
st.title("Hello Streamlit")
st.write("Welcome to your first web app!")

