#--1
import psycopg2
import psycopg2.extras
def connect_pgsql():
    global conn, e
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

connect_pgsql()
#--2
def create_table(q):
    global cur, e
    try:
        cur = conn.cursor()
        cur.execute(f'{q}')
        conn.commit()
        print("Table created.")
    except psycopg2.Error as e:
        print("Error creating table:", e)
    finally:
        cur.close()
create_quary="""
CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    price NUMERIC(6, 2) NOT NULL,
    in_stock BOOLEAN DEFAULT TRUE
        );
    """

def insert_info(q,data):
    global cur, e

    try:
        cur = conn.cursor()
        cur.executemany(q,data)
        conn.commit()
        print("Data inserted.")
    except psycopg2.Error as e:
        print("Insert error:", e)
    finally:
        cur.close()
products_table_info = (('Laptop', 3200.50, True),
                      ('Mouse', 99.99, True),
                      ('Keyboard', 250.00, False),
                      ('Monitor', 1190.95, True))
insert_quary=            """
        INSERT INTO products (name, price, in_stock)
        VALUES (%s, %s, %s)
        ON CONFLICT (name) DO NOTHING;
        """

create_table(create_quary)
insert_info(insert_quary,products_table_info)

#--3
def select(q):
    global cur, rows, row, e
    try:
        cur = conn.cursor()
        cur.execute(q)
        rows = cur.fetchall()
        print(q)
        for row in rows:
            print(row)
    except psycopg2.Error as e:
        print("Select error:", e)
    finally:
        cur.close()
select_quary="""SELECT * FROM products \nWHERE in_stock = TRUE;"""
select(select_quary)


#--------------STREAMLIT
import streamlit as st
#--1)Show your name using st.title()
st.title("Bar's Calculator")

#--2)Add two number input fields using st.text_input()
num1=st.text_input('input your first number')
num2=st.text_input('input your second number')

#--3)Add a button labeled "Add"
#---st.button('add')

#--4)Add a button labeled "Add"
#----When clicked, it should:
#----Add the two numbers
#----Display the result using st.success()
if st.button('add'):
    num3 = int(num1) + int(num2)
    st.success(f'{num1} + {num2} = {num3}')

#------Section B: Show Available Products
#--1)Add a subheader like "Available Products"
st.subheader("Available Products")
#--2)When clicking a button like "Show Products":
#----Connect to the PostgreSQL database
#----Run the query:
#---'SELECT * FROM products WHERE in_stock = TRUE'
#----Show the result using st.write()
if st.button('Show Products'):
    products_dict= []
    try:
        cur = conn.cursor()
        cur.execute("SELECT products.name,products.price FROM products "
                    "WHERE in_stock = TRUE;")
        rows = cur.fetchall()
        for row in rows:
            products_dict.append(dict(row))
        for i in range(0,len(products_dict)):
            st.write(f'{products_dict[i]['name']} | price :{products_dict[i]['price']}$')
    except psycopg2.Error as e:
        print("Select error:", e)
    finally:
        cur.close()



