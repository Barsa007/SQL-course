--B@r$ $0lut!0n$--

--1. AUTOINCREMENT
--שאלה: שנה את מבנה הטבלה כך שהמזהה יעבוד עם AUTOINCREMENT, והכנס עוד שלוש רשומות ללא ציון מזהה.

CREATE TABLE members (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL
);

INSERT INTO members (id, full_name) VALUES
(101, 'Shira Levi'),
(102, 'Nadav Cohen'),
(103, 'Yael Azulay');

INSERT INTO members (full_name) VALUES
('Bar Sasson'),
('Michael Molocondov'),
('Borat Margaret Sagdiyev');


--2. UNION
--שאלה: יש שתי טבלאות: patients ו־nurses, שתיהן כוללות עמודת name. כתוב שאילתה שתחזיר את רשימת כל השמות מתוך שתי הטבלאות – בלי כפילויות

CREATE TABLE patients (
    id INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE nurses (
    id INTEGER PRIMARY KEY,
    name TEXT
);

INSERT INTO patients (name) VALUES ('Yoni'), ('Dana'), ('Avi');
INSERT INTO nurses (name) VALUES ('Avi'), ('Tamar'), ('Lior');

select name as 'all names' FROM patients p 
UNION 
select name from nurses n ;


--3. ON DELETE CASCADE
--שאלה: נסה למחוק במאי שיש לו סרטים – וראה שהמחיקה נכשלת. לאחר מכן, שנה את הגדרת המפתח הזר כדי לאפשר מחיקה cascading

PRAGMA foreign_keys = ON;

CREATE TABLE directors (
    director_id INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE movies (
    movie_id INTEGER PRIMARY KEY,
    title TEXT,
    director_id INTEGER,
    FOREIGN KEY(director_id) REFERENCES directors(director_id) ON DELETE CASCADE
);

INSERT INTO directors (name) VALUES ('Spielberg');
INSERT INTO movies (title, director_id) VALUES ('Jaws', 1);

delete from directors where director_id = 1;


