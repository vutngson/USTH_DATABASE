-- 1. List all students by name, along with their grade averages.
SELECT name, CAST(avg(grade) as DECIMAL(5,2)) as avg_grade
FROM grades NATURAL JOIN students
GROUP BY name
ORDER BY name; 

-- 2. Find student numbers of students for whom the difference between the highest and the lowest grade is less than 20.
SELECT stno
FROM (SELECT stno, MAX(grade) AS highest, MIN(grade) AS lowest
		FROM grades
        GROUP BY stno) AS A
WHERE (highest - lowest) < 20; 

-- 3. Print a report that contains for each course (cno), the number of students who took the course, the highest, the lowest, and the average grade in the course.
SELECT cno, COUNT(stno) AS no_student, MAX(grade) AS highest, MIN(grade) AS lowest, 
CAST(AVG(grade) AS DECIMAL(5,2)) AS average
FROM grades
GROUP BY cno;

-- 4. Find the average grade of students who took cs110 at any time. Then, find students whose grades in cs110 were above the average.
SELECT name
FROM (SELECT name, grade
		FROM grades NATURAL JOIN students
        WHERE cno = 'cs110') AS A
JOIN 
(SELECT CAST(AVG(grade) AS DECIMAL(5,2)) AS avarage
FROM grades 
WHERE cno = 'cs110') AS B
ON A.grade > B.avarage;

-- 5. List the top three instructors in the order of the number of students that they advise.
SELECT name, COUNT(stno) AS no_student
FROM advising NATURAL JOIN instructors
GROUP BY empno
ORDER BY no_student DESC
LIMIT 3;

-- 6. List names of instructors and the number of courses they taught.
SELECT name, COUNT(cno) AS no_course
FROM grades NATURAL JOIN instructors
GROUP BY name
ORDER BY name;

-- 7. List instructors in the order of the number of courses they taught.
SELECT name
FROM (SELECT name, COUNT(cno) AS no_course
		FROM grades NATURAL JOIN instructors
        GROUP BY name) AS A
ORDER BY no_course DESC;

-- 8. List the top three instructors in the order of the number of courses they taught.
SELECT name
FROM (SELECT name, COUNT(cno) AS no_course
		FROM grades NATURAL JOIN instructors
        GROUP BY name) AS A
ORDER BY no_course DESC
LIMIT 3;

-- 9. For each instructors list the sequence of the numbers of courses that the instructor taught during each of the semesters that he or she was active.
SELECT name, no_course, sem, year
FROM (SELECT name, COUNT(cno) AS no_course, sem, year
		FROM grades NATURAL JOIN instructors
        GROUP BY name, sem, year) AS A
ORDER BY name;