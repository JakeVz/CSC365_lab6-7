-- Abhinav Singh and Jake Veazey
-- asingh54@calpoly.edu and 

-- Q1
 SELECT Grade, COUNT(DISTINCT Classroom) AS Classrooms, COUNT(*) AS Students
 FROM list s
 GROUP BY Grade
 ORDER BY Classrooms DESC, Grade
 ;

 --Q2
SELECT Classroom, MAX(LastName)
FROM list
WHERE Grade = 4
GROUP BY Classroom
;

-- Q3
SELECT t.FirstName, t.LastName, COUNT(l.LastName)
FROM list l
INNER JOIN teachers t ON t.Classroom = l.Classroom
GROUP BY l.Classroom
HAVING COUNT(l.Classroom) >= ALL(SELECT COUNT(*) FROM list l2 GROUP BY l2.Classroom)
;

-- Q4
SELECT stu.Grade, COUNT(stu.LastName)
FROM list stu
WHERE (stu.LastName LIKE 'A%') OR 
	  (stu.LastName LIKE 'B%') OR 
	  (stu.LastName LIKE 'C%')
GROUP BY stu.Grade
HAVING COUNT(stu.Grade) >= ALL(SELECT COUNT(stu2.Grade)
							   FROM list stu2
							   WHERE (stu2.LastName LIKE 'A%') OR
							   		 (stu2.LastName LIKE 'B%') OR 
							   		 (stu2.LastName LIKE 'C%')
							   GROUP BY stu2.Grade)
;

-- Q5
SELECT stu.Classroom, COUNT(*)
FROM list stu
GROUP BY stu.Classroom
HAVING COUNT(*) < (SELECT COUNT(stu2.LastName)/COUNT(DISTINCT stu2.Classroom)
				   FROM list stu2)
ORDER BY stu.Classroom ASC
;

-- Q6
SELECT stu.Classroom, stu2.Classroom, COUNT(DISTINCT stu.LastName)
FROM list stu, list stu2 
WHERE stu.Classroom < stu2.Classroom 
GROUP BY stu.Classroom, stu2.Classroom
HAVING COUNT(DISTINCT stu.LastName) = COUNT(DISTINCT stu2.LastName)
ORDER BY COUNT(stu.LastName) ASC
;