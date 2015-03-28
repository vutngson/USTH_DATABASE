-- Assignment 2
-- Create schema for University

DROP DATABASE IF EXISTS university;
CREATE DATABASE IF NOT EXISTS university;
USE university;

DROP TABLE IF EXISTS students, courses, instructors, grades, advising;

set storage_engine = InnoDB;
-- set storage_engine = MyISAM;
-- set storage_engine = Falcon;
-- set storage_engine = PBXT;
-- set storage_engine = Maria;


CREATE TABLE students(	
	stno INT,
	name VARCHAR(20),
	addr VARCHAR(20),
	city VARCHAR(20),
	state VARCHAR(5),
	zip VARCHAR(5)
);

CREATE TABLE instructors(
	empno VARCHAR(3),
	name VARCHAR(20),
	rank VARCHAR(20),
	roomno INT,
	telno INT
);

CREATE TABLE courses(
	cno VARCHAR(5),
	cname VARCHAR(30),
	cr INT,
	cap INT
);

CREATE TABLE grades(
	stno INT,
	empno VARCHAR(3),
	cno VARCHAR(5),
	sem VARCHAR(10),
	year INT,
	grade INT
);

CREATE TABLE advising(
	stno INT,
	empno VARCHAR(3)
);

-- insert into students table
INSERT INTO students
values(1011, 'Edwards P. David', '10 Red Rd.', 'Newton', 'MA', '02159'),
(2415, 'Grogan A. Mary', '8 Walnut St.', 'Malden', 'MA', '02148'),
(2661, 'Mixon Leatha', '100 School St.', 'Brookline', 'MA', '02146'),
(2890, 'McLane Sandy', '30 Cass Rd.', 'Boston', 'MA', '02122'),
(3442, 'Novak Roland', '42 Beacon St', 'Nashua', 'NH', '03060'),
(3566, 'Pierce Richard', '70 Park St.', 'Brookline', 'MA', '02146'),
(4022, 'Prior Lorraine', '8 Beacon St.', 'Boston', 'MA', '02125'),
(5544, 'Rawlings Jerry', '15 Pleasant Dr.', 'Boston', 'MA', '02115'), 
(5571, 'Lewis Jerry', '1 Main Rd.', 'Providence', 'RI', '02904'); 

-- insert into instructors table
INSERT INTO instructors 
values('019', 'Evans Robert', 'Professor',82, 7122),
('023', 'Exxon George', 'Professor', 90, 9101),
( '056', 'Sawyer Kathy', 'Assoc. Prof.', 91, 5110 ),
('126', 'Davis William', 'Assoc. Prof.', 72, 5411),
( '234', 'Will Samuel', 'Assist. Prof.', 90 ,7024);

-- insert into courses table
INSERT INTO courses 
values('cs110', 'Introduction to Computing', 4, 120),
('cs210', 'Computer Programming', 4, 100),
('cs240','Computer Achitecture', 3, 100),
('cs310','Data Structure', 3, 60),
('cs350','Higher Level Language', 3, 50),
('cs410','Software Engineering', 3, 40),
('cs460','Graphics', 3, 30);

-- insert into grades table
INSERT INTO grades 
values(1011,'019','cs110','Fall',2001,40),
(2661,'019','cs110','Fall',2001,80),
(3566,'019','cs110','Fall',2001,95),
(5544,'019','cs110','Fall',2001,100),
(1011,'023','cs110','Spring',2002,75),
(4022,'023','cs110','Spring',2002,60),
(3566,'019','cs240','Spring',2002,100),
(5571,'019','cs240','Spring',2002,50),
(2415,'019','cs240','Spring',2002,100),
(3442,'234','cs410','Spring',2002,60),
(5571,'234','cs410','Spring',2002,80),
(1011,'019','cs210','Fall',2002,90),
(2661,'019','cs210','Fall',2002,70),
(3566,'019','cs210','Fall',2002,90),
(5571,'019','cs210','Spring',2003,85),
(4022,'019','cs210','Spring',2003,70),
(5544,'056','cs240','Spring',2003,70),
(1011,'056','cs240','Spring',2003,90),
(4022,'056','cs240','Spring',2003,80),
(2661,'234','cs310','Spring',2003,100),
(4022,'234','cs310','Spring',2003,75);


-- insert into advising table
INSERT INTO advising 
values(1011, '019'),
(2415, '019'),
(2661, '023'),
(2890, '023'),
(3442, '056'),
(3566, '126'),
(4022, '234'),
(5544, '023'),
(5571, '234');

 