--$$BARS HOMEWORK 31/07/25$$--
--Exercise 1 — Greeting with Name and Timestamp
--Create a function greet_user(name TEXT) that returns a greeting message including the name and current timestamp.

drop FUNCTION if exists greet_user();

CREATE OR REPLACE FUNCTION greet_user(name TEXT) 
RETURNS VARCHAR
LANGUAGE plpgsql AS
$$
BEGIN
    RETURN CONCAT('hello ', name, ' !! ', current_timestamp);
END;
$$;

select * from greet_user('Alex');

--------------------------------------------------------------------
--Exercise 2 — Create Table for Orders
--Write a stored procedure create_orders_table() that creates a table called orders with:
----id (SERIAL primary key)
----customer_name (TEXT, not null)
----amount (DOUBLE PRECISION, not null)

drop procedure if exists create_table();


CREATE OR REPLACE procedure create_table() 
LANGUAGE plpgsql AS
$$
BEGIN	
	CREATE TABLE IF NOT EXISTS Orders(
	id SERIAL primary key,
	customer_name TEXT not null,
	amount DOUBLE PRECISION not null) ;
   
END;
$$;

call create_table();

---------------------------------------------------------------------
--Exercise 3 — Function to Multiply Three Numbers
--Create a function multiply_three(x DOUBLE PRECISION, y DOUBLE PRECISION, z DOUBLE PRECISION) that returns the product.

CREATE OR REPLACE FUNCTION multiply_num(x DOUBLE PRECISION, y DOUBLE PRECISION, z DOUBLE PRECISION)
RETURNS DOUBLE PRECISION
LANGUAGE plpgsql AS
$$
BEGIN
    RETURN x * y * z;
END;
$$;

select * from multiply_num(4,2,3);

------------------------------------------------------------------------
--Exercise 4 — Division and Modulo Function
--Create a function div_mod(a DOUBLE PRECISION, b DOUBLE PRECISION) that returns:
--OUT quotient
--OUT remainder

DROP FUNCTION IF EXISTS math_test(DOUBLE PRECISION, DOUBLE PRECISION);

CREATE OR REPLACE FUNCTION math_test(
     a DOUBLE PRECISION,
     b DOUBLE PRECISION,
    OUT quotient DOUBLE PRECISION, 
    OUT remainder DOUBLE PRECISION
)
LANGUAGE plpgsql AS
$$
BEGIN
    quotient := a / b;
    remainder := MOD(a:: numeric , b:: numeric);
END;
$$;

SELECT * FROM math_test(8, 5);

------------------------------------------------------------------------
--Exercise 5 — Square Root and Power 4
--Create a function sp_math_roots(x DOUBLE PRECISION, y DOUBLE PRECISION) that returns:
--OUT sum_result
--OUT diff_result
--OUT sqrt_x
--OUT y_power_4

DROP FUNCTION IF EXISTS sp_math_roots(DOUBLE PRECISION, DOUBLE PRECISION);

CREATE OR REPLACE FUNCTION sp_math_roots(
     x DOUBLE PRECISION,
     y DOUBLE PRECISION,
    OUT sum_result DOUBLE PRECISION, 
    OUT diff_result DOUBLE precision,
    OUT sqrt_x DOUBLE precision,
    OUT y_power_4 DOUBLE precision
    )
LANGUAGE plpgsql AS
$$
BEGIN
    sum_result := x + y;
    diff_result := x-7;
	sqrt_x := power(x,2) ;
	y_power_4 := power(y,4);
END;
$$;

SELECT * FROM sp_math_roots(8, 5);

------------------------------------------------------------------------
--Exercise 6 — Insert Books and Authors + Get All Books with Publish Year
--Create a procedure prepare_books_db() that creates and fills tables:
--
--authors(id SERIAL, name TEXT NOT NULL)
--books(id SERIAL, title TEXT, price DOUBLE PRECISION, publish_date DATE, author_id INT REFERENCES authors)
--Then create a function sp_get_books_with_year() that returns:
--
--title, publish_year, price

drop procedure if exists prepare_books_db();

CREATE OR REPLACE procedure prepare_books_db() 
LANGUAGE plpgsql AS
$$
BEGIN	
	CREATE TABLE IF NOT EXISTS authors(
	id SERIAL primary key,
	name TEXT NOT NULL
	) ; 

	CREATE TABLE IF NOT EXISTS books(
	id SERIAL primary key,
	title TEXT ,
	price DOUBLE PRECISION,
	publish_date DATE,
	author_id INT REFERENCES authors
	) ; 
	
	-- Authors
	INSERT INTO authors(name) VALUES ('Alice Munro'), ('George Orwell'), ('Haruki Murakami'), ('Chimamanda Ngozi Adichie');

-- Books
	INSERT INTO books(title, price, publish_date, author_id) VALUES
	('Lives of Girls and Women', 45.0, '1971-05-01', 1),
	('1984', 30.0, '1949-06-08', 2),
	('Norwegian Wood', 50.0, '1987-09-04', 3),
	('Half of a Yellow Sun', 42.5, '2006-08-15', 4),
	('Kafka on the Shore', 55.0, '2002-01-01', 3),
	('Dear Life', 48.0, '2012-11-13', 1),
	('The Thing Around Your Neck', 35.0, '2009-04-01', 4),
	('Animal Farm', 28.0, '1945-08-17', 2),
	('The Testaments', 60.0, '2019-09-10', 2),
	('Colorless Tsukuru Tazaki', 47.5, '2013-04-12', 3);
		
  
END;
$$;

DROP FUNCTION IF EXISTS sp_get_books_with_year( );


DROP FUNCTION IF EXISTS sp_get_books_with_year();

CREATE OR REPLACE FUNCTION sp_get_books_with_year()
RETURNS TABLE (
    title TEXT,
    publish_date DATE,
    price DOUBLE PRECISION
)
LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY
    SELECT b.title, b.publish_date, b.price
    FROM books b;
END;
$$;

select * from  sp_get_books_with_year();

------------------------------------------------------------------------
--Exercise 7 — Most Recently Published Book
--Create a function sp_latest_book() that returns the most recent book's title and publish date.

DROP FUNCTION IF EXISTS  sp_latest_book();

CREATE OR REPLACE function sp_latest_book()
RETURNS TABLE (
    title TEXT,
    publish_date DATE,
    price DOUBLE PRECISION
)
LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY
    SELECT b.title, b.publish_date, b.price
    FROM books b
    ORDER BY b.publish_date DESC
    LIMIT 1;
END;
$$;

select * from  sp_latest_book();

------------------------------------------------------------------------
--Exercise 8 — Books Summary Stats
--Create a function sp_books_summary() that returns:
--OUT youngest_book DATE
--OUT oldest_book DATE
--OUT avg_price NUMERIC(5,2)
--OUT total_books INT

DROP FUNCTION IF EXISTS sp_math_roots( );

CREATE OR REPLACE FUNCTION sp_math_roots()
	RETURNS TABLE (
    youngest_book DATE,
    oldest_book DATE,
    avg_price DOUBLE PRECISION,
    total_books bigint
    )
LANGUAGE plpgsql AS
$$
BEGIN
	RETURN QUERY
	SELECT MAX(b.publish_date) AS youngest_book,
		   MIN(b.publish_date) AS oldest_book,
		   AVG(b.price) AS avg_price,
	   	   COUNT(*) AS total_books 
	   	   FROM books b;
END;
$$;


select * from sp_math_roots();

------------------------------------------------------------------------
--xercise 9 — Books by Year Range
--Create a function sp_books_by_year_range(from_year INT, to_year INT) that returns:
--
--id, title, publish_date, price

CREATE OR REPLACE FUNCTION sp_books_by_year_range(from_year INT, to_year INT)
	RETURNS TABLE (
    id int,
    title text,
    publish_date DATE,
    price double PRECISION
    )
LANGUAGE plpgsql AS
$$
BEGIN
	RETURN QUERY
	SELECT b.id,b.title,b.publish_date,b.price
	FROM books b
	WHERE b.publish_date between 
	TO_DATE(from_year || '-01-01', 'YYYY-MM-DD') AND 
    TO_DATE(to_year || '-12-31', 'YYYY-MM-DD'); 
END;
$$;


select * from sp_books_by_year_range(2002,2006);

