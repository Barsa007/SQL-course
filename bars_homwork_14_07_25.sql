-------- 1:1 ---------

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE passwords (
    user_id INTEGER UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);

INSERT INTO users (user_id, name) VALUES
(1, 'Lior'), (2, 'Tamar'), (3, 'Erez'), (4, 'Dana'),
(5, 'Amit'), (6, 'Yael'), (7, 'Noam'), (8, 'Hila'),
(9, 'Aviad'), (10, 'Shani');

INSERT INTO passwords (user_id, password_hash) VALUES
(1, 'abc123'), (2, 'pass456'), (3, 'hello789'), (4, 'secure321'),
(5, 'qwerty12'), (6, 'secret99');

--1:הצג את כל המשתמשים עם הסיסמה שלהם (INNER JOIN)
select u.*,p.password_hash FROM users u 
JOIN passwords p on p.user_id = u.user_id;

--2:הצג את כל המשתמשים, גם כאלה שאין להם סיסמה (LEFT JOIN)
SELECT u.*,p.password_hash FROM  users u
left join passwords p on p.user_id = u.user_id;

--3:הצג את המשתמשים שאין להם סיסמה כלל
SELECT u.* FROM  users u
left join passwords p on p.user_id = u.user_id
where p.password_hash is null;


-------- N:1 ---------

CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    department_id INTEGER,
    FOREIGN KEY(department_id) REFERENCES departments(department_id)
);

INSERT INTO departments (department_id, name) VALUES
(1, 'Finance'), (2, 'IT'), (3, 'HR'), (4, 'Marketing'),(5, 'Meth lab');

INSERT INTO employees (employee_id, name, department_id) VALUES
(1, 'Shira', 1), (2, 'Doron', 2), (3, 'Tal', 2), (4, 'Adi', 3),
(5, 'Omer', NULL), (6, 'Yoni', 1), (7, 'Michal', NULL),
(8, 'Liad', 4), (9, 'Noga', 2), (10, 'Rami', 1);

--1:הצג את כל העובדים עם שם המחלקה שלהם
SELECT  e.employee_id ,e.name ,d.department_id ,d.name FROM employees e
JOIN departments d on e.department_id  =d.department_id;

--2:הצג את כל המחלקות וספור כמה עובדים יש לכל מחלקה
select d.name,COUNT (e.employee_id ) as workers_in_department from departments d
left JOIN employees e on e.department_id  =d.department_id
GROUP by d.department_id;

--3:הצג את כל העובדים כולל כאלה שלא שויכו למחלקה
SELECT  e.employee_id ,e.name ,d.department_id ,d.name FROM employees e
left JOIN departments d on e.department_id  =d.department_id;

--4:הצג מחלקות שאין בהן אף עובד
select d.name,COUNT (e.employee_id ) as workers_in_department from departments d
left JOIN employees e on e.department_id  =d.department_id
GROUP by d.department_id
having workers_in_department is 0;


-------- M:N ---------

CREATE TABLE citizens (
    citizen_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE cable_tv (
    company_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE subscriptions (
    citizen_id INTEGER,
    company_id INTEGER,
    PRIMARY KEY (citizen_id, company_id),
    FOREIGN KEY(citizen_id) REFERENCES citizens(citizen_id),
    FOREIGN KEY(company_id) REFERENCES cable_tv(company_id)
);

INSERT INTO citizens (citizen_id, name) VALUES
(1, 'Rina'), (2, 'Avi'), (3, 'Lea'), (4, 'Moshe'),
(5, 'Gali'), (6, 'Bar'), (7, 'Itai'), (8, 'Sivan'),
(9, 'Elior'), (10, 'Hodaya');

INSERT INTO cable_tv (company_id, name) VALUES
(1, 'HOT'), (2, 'YES'), (3, 'Partner TV'), (4, 'Idan +');

INSERT INTO subscriptions (citizen_id, company_id) VALUES
(1, 1), (1, 2),
(2, 2), (2, 3),
(3, 1), (4, 1),
(5, 3), (6, 3), (6, 1),
(7, 2);

---1:הצג את כל המנויים עם שם האזרח ושם החברה
SELECT c.name ,c2.name  FROM subscriptions s 
JOIN citizens c ON s.citizen_id =c.citizen_id
JOIN cable_tv c2 ON s.company_id =c2.company_id;

---2:הצג את כל האזרחים וכמה חברות הם מנויים אליהן
SELECT c.name ,COUNT(c2.name) as num_of_cable_subs FROM citizens c
left join subscriptions s  ON s.citizen_id =c.citizen_id
LEFT join cable_tv c2 ON s.company_id =c2.company_id
GROUP by c.name
ORDER by num_of_cable_subs ;

---3:הצג את כל חברות הכבלים וכמה מנויים יש להן
SELECT c2.name ,COUNT(c.name) as num_of_subs FROM cable_tv c2
left join subscriptions s on c2.company_id = s.company_id
left join citizens c  on c.citizen_id =s.citizen_id
GROUP by c2.name
ORDER by num_of_subs ;

---4:הצג אזרחים שלא מנויים לאף חברה
SELECT c.citizen_id ,c.name as 'citizens without subscription' from citizens c 
left join subscriptions s on c.citizen_id =s.citizen_id
where s.company_id is null;

---5:הצג חברות שאין להן אף מנוי
SELECT c.company_id,c.name as 'companies without subscriptions' from cable_tv c 
left join subscriptions s on c.company_id =s.company_id
where s.citizen_id is null;
