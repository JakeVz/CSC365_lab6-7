-- Abhinav Singh and Jake Veazey
-- asingh54@calpoly.edu

-- Q1 
SELECT a.Code, a.Name 
FROM airports a, flights f
WHERE f.Source = a.Code
GROUP BY a.Name, a.Code
HAVING COUNT(*) = 17
ORDER BY a.Code
;

-- Q2
SELECT COUNT(DISTINCT f2.Destination)
FROM flights f1, flights f2
WHERE f1.Source = "ANP"
      AND f1.Destination = f2.Source
      AND f2.Destination != f1.Source
;
-- Q4
SELECT COUNT(DISTINCT f1.Source)
FROM flights f1, flights f2
WHERE f2.Destination = "ATE"
      AND f1.Source != f2.Destination
      AND ((f1.Destination = f2.Source) 
      OR (f1.Source = f2.Source 
      AND f1.Destination = f2.Destination))
;
-- Q4
SELECT a.Airline, COUNT(DISTINCT f.Source) AS `Number of Airports`
FROM airlines a, flights f
WHERE a.Id = f.Airline
GROUP BY a.Airline
ORDER BY COUNT(DISTINCT f.Source) DESC
;