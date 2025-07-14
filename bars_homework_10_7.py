import sqlite3
import os
def title():
    print(46*'$'+'---Bars solutions 10.7.25---'+46*'$')
def create_sql_DB():
    global conn, cursor
    if os.path.exists('taxi.db'):
        os.remove('taxi.db')  # delete file
    conn = sqlite3.connect('taxi.db')
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
def create_tables():
    cursor.execute('''
CREATE TABLE IF NOT EXISTS taxis (
    id INTEGER PRIMARY KEY,
    driver_name TEXT NOT NULL,
    car_type TEXT NOT NULL
);
''')
    cursor.execute('''
CREATE TABLE IF NOT EXISTS passengers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    destination TEXT,
    taxi_id INTEGER,
    FOREIGN KEY(taxi_id) REFERENCES taxis(id)
);
''')
def insert_info_into_tables():
    NULL = None
    taxis_data = [(1, 'Moshe Levi', 'Van'),
                  (2, 'Rina Cohen', 'Sedan'),
                  (3, 'David Azulay', 'Minibus'),
                  (4, 'Maya Bar', 'Electric'),
                  (5, 'Yossi Peretz', 'SUV')
                  ]
    passengers_data = [(1, 'Tamar', 'Jerusalem', 1),
                       (2, 'Eitan', 'Haifa', 2),
                       (3, 'Noa', 'Tel Aviv', NULL),
                       (4, 'Lior', 'Eilat', 1),
                       (5, 'Dana', 'Beer Sheva', NULL),
                       (6, 'Gil', 'Ashdod', 3),
                       (7, 'Moran', 'Netanya', NULL)
                       ]
    cursor.executemany('''
INSERT INTO taxis (id,driver_name,car_type)
VALUES (?, ?, ?);
''', taxis_data)
    cursor.executemany('''
INSERT INTO passengers (id,name,destination,taxi_id)
VALUES (?, ?, ?, ?);
''', passengers_data)
def show_table(name):
    cursor.execute(f'''
SELECT * FROM {name};
''')
    print(f'\nSELECT * FROM {name}; result=')
    result = cursor.fetchall()
    for row in result:
        print(dict(row))
def ex4_1():
    print("\n---4.1--- INNER JOIN: נוסעים עם מונית ---")
    cursor.execute('''
    SELECT p.*,t.driver_name, t.car_type FROM passengers p
    INNER JOIN taxis t ON p.taxi_id = t.id
    ''')
    for row in cursor.fetchall():
        print(dict(row))
def ex4_2():
    print("\n---4.2--- LEFT JOIN:כל הנוסעים כולל כאלה שמצאו מונית וכאלה שלא  ---")
    cursor.execute('''
    SELECT p.*,t.driver_name, t.car_type FROM passengers p
    LEFT JOIN taxis t ON p.taxi_id = t.id
    ''')
    for row in cursor.fetchall():
        print(dict(row))
def ex4_3():
    print("\n---4.3--- LEFT OUTER JOIN: רק נוסעים בלי מספר מונית מזהה  ---")
    cursor.execute('''
    SELECT p.*,t.driver_name, t.car_type FROM passengers p
    LEFT JOIN taxis t ON p.taxi_id = t.id
    WHERE p.taxi_id is NULL
    ''')
    for row in cursor.fetchall():
        print(dict(row))
def ex4_4():
    print("\n---4.4--- FULL JOIN: כל הנוסעים וכל המוניות — גם אם אין התאמה ביניהם ---")
    cursor.execute('''
    SELECT p.*,t.driver_name, t.car_type FROM passengers p
    FULL JOIN taxis t ON p.taxi_id = t.id
    ''')
    for row in cursor.fetchall():
        print(dict(row))
def ex4_5():
    print("\n---4.5--- CROSS JOIN: כל הצירופים האפשריים בין נוסעים למוניות ---")
    cursor.execute('''
    SELECT p.*,t.driver_name ,t.car_type FROM  passengers p 
    CROSS JOIN taxis t ;
    ''')
    for row in cursor.fetchall():
        print(dict(row))
def main_func():
    title()
    create_sql_DB()
    create_tables()
    insert_info_into_tables()
    show_table('passengers')
    show_table('taxis')
    conn.commit()
    ex4_1()
    ex4_2()
    ex4_3()
    ex4_4()
    ex4_5()
    conn.close()
main_func()
