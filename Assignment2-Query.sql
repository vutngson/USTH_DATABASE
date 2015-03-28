-- 2 (a) Find all students who live in Malden or Newton
SELECT name
FROM students
WHERE city = 'Malden' or city = 'Newton'
ORDER BY name;

-- 2 (b) Find all students whose name starts with ’F’;
SELECT name
FROM students
WHERE name LIKE 'F%'
ORDER BY name;

-- 2 (c) Find all students whose name contains the letter ’f’;
SELECT name 
FROM students
WHERE name LIKE '%f%'
ORDER BY name;

-- 3

-- 4. Find all pairs of student names and course names for grades obtained during Fall of 2001.
SELECT name
FROM grades NATURAL JOIN students NATURAL JOIN courses
WHERE sem = 'Fall' AND year = 2001
ORDER BY name;

--  5. Find the names of students who took some four-credit courses.
SELECT DISTINCT name  
FROM grades NATURAL JOIN students
WHERE cno IN (SELECT cno 
				FROM courses
				WHERE cr = 4)
ORDER BY name;

-- 6. Find the names of students who took a course with an instructor who is also their advisor.
SELECT DISTINCT name
FROM grades NATURAL JOIN advising NATURAL JOIN students
ORDER BY name; 

-- 7. Find the names of students who took cs210 or had Prof. Smith as their advisor.
SELECT DISTINCT name
FROM grades NATURAL JOIN students
WHERE cno = 'cs210' OR empno IN (SELECT empno
								FROM advising 
								WHERE empno IN(SELECT empno
												FROM instructors
												WHERE name = 'Smith')); 

-- 8. Find all pairs of names of students who live in the same city.
SELECT st1.name, st2.name
FROM students st1, students st2
WHERE st1.city = st2.city AND st1.name < st2.name;

-- 9. Find all triples of instructors’ names for instructors who taught the same course.
SELECT DISTINCT emp1.name , emp2.name, emp3.name
FROM (SELECT name, cno FROM grades NATURAL JOIN instructors) AS emp1,
(SELECT name, cno FROM grades NATURAL JOIN instructors) AS emp2,
(SELECT name, cno FROM grades NATURAL JOIN instructors) AS emp3
WHERE emp1.cno = emp2.cno = emp3.cno AND emp1.name < emp2.name < emp3.name;

-- 10. Find instructors who taught students who are advised by another instructor who shares the same room.
SELECT DISTINCT name
FROM (SELECT name, empno, stno, roomno FROM grades NATURAL JOIN instructors) as A1
JOIN (SELECT empno as empno1, stno, roomno FROM advising NATURAL JOIN instructors) AS A2 
ON A1.stno = A2.stno AND A1.roomno = A2.roomno AND A1.empno <> A2.empno1;

-- 11. Find course numbers of courses taken by students who live in Boston and which are taught by an associate professor.
SELECT DISTINCT cno
FROM grades
WHERE stno IN (SELECT stno FROM students WHERE city = 'Boston')
AND empno IN (SELECT empno FROM instructors WHERE rank = 'Assoc. Prof.');

-- 12. Find the names of instructors who teach courses attended by students who took a course with and instructor who is an assistant professor.
SELECT DISTINCT name
FROM grades NATURAL JOIN instructors 
WHERE cno IN (SELECT cno 
				FROM grades 
				WHERE stno IN ( SELECT stno 
								FROM grades 
								WHERE cno IN (SELECT cno 
												FROM grades
												WHERE empno IN (SELECT empno 
																FROM instructors
																WHERE rank = 'Assoc. Prof.'))));

-- 13. Find the telephone numbers of instructors who teach a course taken by any student who lives in Boston
SELECT DISTINCT telno
FROM grades NATURAL JOIN instructors 
WHERE stno IN (SELECT stno 
				FROM students
				WHERE city = 'Boston');

-- 14. Find all pairs of names of students and instructors such that the student never took a course with the instructor.
SELECT DISTINCT stname, ename
FROM (SELECT students.name AS stname, instructors.name AS ename, stno , empno
		FROM students, instructors) AS A1
WHERE (stno , empno) NOT IN (SELECT stno, empno
								FROM grades);

-- 15. Find the names of students who took no four-credit courses.
SELECT name 
FROM (SELECT DISTINCT name 
		FROM grades NATURAL JOIN students NATURAL JOIN courses
		WHERE cr <> 4) AS not4cr
WHERE name NOT IN (SELECT DISTINCT name 
					FROM  grades NATURAL JOIN students NATURAL JOIN courses
					WHERE cr = 4);

-- 16. Find the names of students who took only four-credit courses.
SELECT name 
FROM (SELECT DISTINCT name 
		FROM grades NATURAL JOIN students NATURAL JOIN courses
		WHERE cr = 4) AS not4cr
WHERE name NOT IN (SELECT DISTINCT name 
					FROM  grades NATURAL JOIN students NATURAL JOIN courses
					WHERE cr <> 4);

-- 17. Find the names of students who took every four-credit course.
SELECT DISTINCT name 
FROM (SELECT * 
		FROM grades NATURAL JOIN students) AS C
WHERE NOT EXISTS
(SELECT cno 
FROM (SELECT cno
		FROM courses
		WHERE cr = 4) AS D
WHERE cno NOT IN (SELECT cno
					FROM (SELECT * 
							FROM grades NATURAL JOIN students) AS C1
					WHERE C1.name = C.name))
AND EXISTS
(SELECT cno 
FROM (SELECT cno
		FROM courses
		WHERE cr = 4) AS D1);

-- 18. Find the names of all students for whom no other student lives in the same city.
SELECT name
FROM students
WHERE city IN(SELECT city
				FROM (SELECT city, COUNT(name) AS nostudent
				FROM students
				GROUP BY city
				) AS A
				WHERE nostudent = 1);

-- 19. Find names of students who took every course taken by Richard Pierce.
SELECT DISTINCT name
FROM (SELECT *
		FROM grades NATURAL JOIN students) AS c1
WHERE NOT EXISTS
(SELECT cno
FROM (SELECT cno 
		FROM grades NATURAL JOIN instructors
		WHERE name = 'Richard Pierce') AS d
WHERE cno NOT IN(SELECT cno 
	FROM (SELECT *
			FROM grades NATURAL JOIN students) AS c2
	WHERE c1.name = c2.name))
AND EXISTS (SELECT cno
			FROM grades NATURAL JOIN instructors
			WHERE name = 'Richard Pierce');

-- 20. Find the names of instructors who teach no courses.
SELECT name
FROM instructors
WHERE empno NOT IN (SELECT DISTINCT empno 
					FROM grades);

-- 21. Find course numbers of courses that have never been taught.
SELECT cno
FROM courses
WHERE cno NOT IN (SELECT DISTINCT cno 
					FROM grades);

-- 22. Find courses that are taught by every assistant professor.
SELECT DISTINCT cname 
FROM (SELECT * 
		FROM grades NATURAL JOIN courses) AS c1
WHERE NOT EXISTS
(SELECT empno
FROM (SELECT * 
		FROM instructors
		WHERE rank = 'Assoc. Prof.') AS d
WHERE empno NOT IN (SELECT empno
					FROM (SELECT *
							FROM grades NATURAL JOIN courses) AS c2
					WHERE c1.cname = c2.cname))
AND EXISTS
(SELECT empno
FROM (SELECT * 
		FROM instructors
		WHERE rank = 'Assoc. Prof.') AS d1);

-- 23. Find the names of students whose advisor did not teach them any course.
SELECT DISTINCT name
FROM advising NATURAL JOIN students
WHERE (stno,empno) NOT IN (SELECT DISTINCT stno,empno
					FROM grades);

-- 24. Find the names of students who have failed all their courses (failing is defined as a grade less than 60).
SELECT name
FROM (SELECT DISTINCT name, stno 
		FROM grades NATURAL JOIN students) AS A
WHERE stno NOT IN (SELECT DISTINCT stno
					FROM grades
					WHERE grade >= 60);

-- 25. Find the names of students who do not have an advisor.
SELECT name
FROM students 
WHERE stno NOT IN (SELECT DISTINCT stno FROM advising);

-- 26. Find the names of instructors who taught every semester when a student from Rhode Island was enrolled.
SELECT DISTINCT name
FROM (SELECT DISTINCT empno, sem, year
		FROM grades) AS C1 NATURAL JOIN instructors
WHERE NOT EXISTS
(SELECT sem, year
FROM (SELECT DISTINCT sem, year
		FROM grades
		WHERE stno IN (SELECT stno
						FROM students
						WHERE state = 'RI')) AS D
WHERE (sem, year) NOT IN (SELECT sem, year
							FROM (SELECT DISTINCT empno, sem, year
									FROM grades) AS C2
							WHERE C1.empno = C2.empno));


-- 27. Find course names of courses taken by every student advised by Prof. Evans.
SELECT DISTINCT cname
FROM (SELECT * FROM grades NATURAL JOIN courses) AS C1
WHERE NOT EXISTS 
(SELECT stno 
FROM (SELECT stno 
		FROM advising NATURAL JOIN instructors 
		WHERE name = 'Evans Robert') AS D
WHERE stno NOT IN(SELECT stno 
					FROM (SELECT * 
							FROM grades NATURAL JOIN courses) AS C2  
					WHERE C1.cname = C2.cname)
AND EXISTS
(SELECT stno 
FROM (SELECT stno 
		FROM advising NATURAL JOIN instructors 
		WHERE name = 'Evans Robert') AS D1));

-- 28. Find names of students who took every course taught by an instructor who is advising at least two students.
-- C courses teach by instructors who is advising at least two students
-- D student learns all cousrse
SELECT stno
FROM (SELECT DISTINCT stno
		FROM advising
		NATURAL JOIN
		(SELECT DISTINCT empno, cno
			FROM grades NATURAL JOIN (SELECT empno
										FROM (SELECT empno, COUNT(stno) AS nostu
										FROM advising
										GROUP BY empno) AS A
										WHERE A.nostu >= 2) AS B ) AS C) AS D
WHERE stno NOT IN
(SELECT DISTINCT stno
FROM advising NATURAL JOIN (SELECT DISTINCT empno, cno
			FROM grades NATURAL JOIN (SELECT empno
										FROM (SELECT empno, COUNT(stno) AS nostu
										FROM advising
										GROUP BY empno) AS A
										WHERE A.nostu >= 2) AS B ) AS C 
WHERE (stno, empno, cno) NOT IN (SELECT stno, empno, cno
									FROM grades));
 
-- 29. Find names of instructors who teach every student they advise.
SELECT name
FROM (SELECT DISTINCT name, empno FROM advising NATURAL JOIN instructors)  AS A
WHERE A.empno NOT IN (SELECT DISTINCT empno 
						FROM advising 
						WHERE (stno,empno) NOT IN (SELECT DISTINCT stno,empno
													FROM grades));


-- 30. Find names of students who are taking every course taught by their advisor.
SELECT name 
FROM (SELECT DISTINCT stno
		FROM advising NATURAL JOIN (SELECT DISTINCT empno, cno
										FROM grades
										WHERE empno IN (SELECT DISTINCT empno
														FROM advising)) AS A1) AS A3
NATURAL JOIN students
WHERE stno NOT IN (SELECT DISTINCT stno
					FROM advising NATURAL JOIN (SELECT DISTINCT empno, cno
												FROM grades
												WHERE empno IN (SELECT DISTINCT empno
																FROM advising)) AS A
					WHERE (stno, empno, cno) NOT IN ( SELECT DISTINCT stno, empno, cno
									FROM grades));

-- 31. Find course numbers of courses taken by every student who lives in Rhode Island.
SELECT DISTINCT cno
FROM grades as c1
WHERE NOT EXISTS 
(SELECT stno
FROM (SELECT * FROM students WHERE state = 'RI') AS d
WHERE stno NOT IN (SELECT stno 
					FROM grades as c2
					WHERE c1.cno = c2.cno))
AND EXISTS 
(SELECT stno
FROM (SELECT * FROM students WHERE state = 'RI') AS d1);

-- 32. Find the student numbers of students who took at least two courses.
SELECT stno
FROM (SELECT stno, COUNT(cno) AS noco FROM grades GROUP BY stno) AS A
WHERE A.noco >= 2;

-- 33. Find the course names of courses in which at least three students were enrolled.
SELECT cname
FROM (SELECT cname, COUNT(stno) AS stuno
		FROM grades NATURAL JOIN courses 
		GROUP BY cname) AS A
WHERE A.stuno >= 3;

-- 34. Find the names of instructors who advise at least two students.
SELECT name
FROM (SELECT name, COUNT(empno) AS stuno 
		FROM advising NATURAL JOIN instructors
		GROUP BY name) AS A
WHERE A.stuno >= 2;

-- 35. Find cities where students live for all students who do not live in Boston, Massachusetts.
SELECT DISTINCT city
FROM students
WHERE city <> 'Boston';

