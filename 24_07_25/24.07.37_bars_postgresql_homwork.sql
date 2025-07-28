--4. SERIAL
--שאלה: שנה את מבנה הטבלה כך שהמזהה יעבוד עם SERIAL, והכנס שלוש רשומות נוספות ללא ציון מזהה

CREATE TABLE trainers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

INSERT INTO trainers (id, name) VALUES
(201, 'Erez Barak'),
(202, 'Liat Ben-Haim'),
(203, 'Gil Oren');

INSERT INTO trainers ( name) VALUES
('Ehud Barak'),
('Willy Wonka'),
('Nursultan Tulyakbay');


--5. INSERT with RANDOM
--שאלה: כתוב שאילתה שמכניסה שלוש רשומות כאשר הערך הוא מספר אקראי בין 5 ל־15, עם שתי ספרות אחרי הנקודה

CREATE TABLE measurements (
    id SERIAL PRIMARY KEY,
    value NUMERIC(5,2)
);

INSERT INTO measurements ( value) VALUES
(round((random() * 15 + 5)::numeric, 2)),
(round((random() * 15 + 5)::numeric, 2)),
(round((random() * 15 + 5)::numeric, 2));


--6. JSONB במקום קשר M:N
--שאלה: שנה את המבנה כך שהכול יישמר בטבלה אחת בשם enrollments עם שדה JSONB שמכיל את רשימת הקורסים של כל סטודנט
--דוגמא לעמודת- JOSNB

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    course_date DATE NOT NULL
);

CREATE TABLE student_courses (
    student_id INTEGER REFERENCES students(id),
    course_id INTEGER REFERENCES courses(id),
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO students (name) VALUES
('Roni'),
('Alon');

INSERT INTO courses (title, course_date) VALUES
('math', '2024-11-01'),
('history', '2024-11-15');

INSERT INTO student_courses (student_id, course_id) VALUES
(1, 1),
(1, 2),
(2, 1);

CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_name TEXT NOT null,
    courses JSONB   
);


INSERT INTO enrollments (student_name,courses) VALUES
('Roni','{"math":"2024-11-01","history":"2024-11-15"}');
INSERT INTO enrollments (student_name,courses) VALUES
(('Alon'),'{"math":"2024-11-01"}');
