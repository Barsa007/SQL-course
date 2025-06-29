--(Bar Sassons Homework)--
-------EX 1-------
--1)
SELECT * from STUDENTS ;
--2)
SELECT GRADE,NAME FROM STUDENTS;
--3)
SELECT avg(GRADE) 
 FROM STUDENTS;
 --4)
 SELECT min(BIRTHYEAR)
 from STUDENTS;
 
 -------EX 2-------
 --5)
 SELECT * from STUDENTS
 WHERE GRADE>80; 
--6)
 SELECT * from STUDENTS
 WHERE BIRTHYEAR>2005; 
 --7)
 SELECT * from STUDENTS
  WHERE CLASS="H1"
  --8)
 SELECT * from STUDENTS
  WHERE NAME like '%i%';
 
 -------EX 3-------
 --9)
  SELECT * from STUDENTS
  ORDER BY GRADE DESC
  LIMIT 3;
  --10)
   SELECT * from STUDENTS
  ORDER BY BIRTHYEAR ;
  --11)
   SELECT * from STUDENTS
   LIMIT 3;
  --12)
  SELECT * from STUDENTS
  LIMIT 3 OFFSET 3;
   
   -------EX 4-------
   --13)
   update STUDENTS
   SET GRADE=100
   WHERE name ='Dana';
   --14)
      update STUDENTS
   SET CLASS='GRADUATED'
   WHERE BIRTHYEAR<2010;
   --15)
   DELETE  
   FROM STUDENTS
   WHERE NAME='Tom';
   


   
   