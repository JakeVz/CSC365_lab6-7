-- Abhinav Singh and Jake Veazey
-- asingh54@calpoly.edu and wveazey@calpoly.edu

-- CARS-1
SELECT
   m.Maker,
   MAX(d.MPG) as MPG, 
   AVG(d.Accelerate) as a
FROM 
   countries c, 
   carMakers m, 
   carsData d, 
   carNames n
WHERE 
   d.Id = n.Id
   AND n.Model = m.Maker
   AND m.Country = c.Id
   AND c.Name = 'japan'
GROUP BY 
   m.Maker
ORDER BY
   MPG;

-- CARS-2
SELECT
   m.Maker,
   COUNT(*) as count
FROM
   carMakers m,
   carsData d,
   countries c,
   carNames n
WHERE
   c.Name = 'usa'
   AND d.Cylinders = 4
   AND d.Weight < 4000
   AND d.Accelerate < 14
   AND d.Id = n.Id
   AND n.Model = m.Maker
   AND m.Country = c.Id
GROUP BY
   m.Maker
ORDER BY
   count DESC;

-- CARS-3
SELECT
   n.description,
   d.YearMade
FROM
   carsData d,
   carNames n
WHERE
   d.MPG = (
      SELECT
         MAX(MPG)
         FROM
            carsData)
   AND n.Id = d.Id;

-- CARS-4
SELECT
   sub.description,
   sub.YearMade
FROM
   (SELECT
      n.description,
      d.YearMade,
      d.Accelerate
   FROM
      carNames n,
      carsData d
   WHERE
      n.Id = d.Id
      AND d.MPG = 
         (SELECT
            MAX(MPG)
         FROM carsData)
         ) as sub
WHERE
   sub.Accelerate = 
      (SELECT
         MAX(sub.Accelerate)
      );


-- CARS-5
SELECT
   sub.YearMade,
   sub.Maker,
   sub.a,
   MAX(sub.w) as w
FROM 
   (SELECT
      d.YearMade,
      m.Maker,
      AVG(d.Accelerate) as a,
      AVG(d.Weight) as w
   FROM
      carMakers m,
      carsData d,
      carNames n,
      modelList mo
   WHERE 
      n.Model = mo.Model
      AND mo.Maker = m.Id
      AND d.Id = n.Id
   GROUP BY
      d.YearMade, m.Id
   HAVING
      COUNT(*) > 1
   ORDER BY
      w DESC
   ) as sub
GROUP BY
   sub.YearMade,
   sub.Maker,
   sub.w,
   sub.a
ORDER BY
   sub.YearMade;

-- CARS-6
SELECT
   sub1.MPG - sub2.MPG as Difference
FROM
   (SELECT
      MAX(d.MPG) as MPG
   FROM
      carsData d
   WHERE
      d.Cylinders = 8
   ) as sub1,
   (SELECT
      MIN(d.MPG) as MPG
   FROM
      carsData d
   WHERE
      d.Cylinders = 4
   ) as sub2;

-- CARS-7
SELECT
   sub.YearMade,
   CASE
      WHEN sub.us > sub.rest
         THEN 'US'
      WHEN sub.us < sub.rest
         THEN 'The Rest of the World'
      ELSE 'tie'
      END AS 'More'
FROM
   (SELECT
      inSub1.YearMade,
      inSub1.total as us,
      inSub2.total as rest
   FROM
      (SELECT
         d.YearMade,
         COUNT(*) as total
      FROM
         countries cu,
         carsData d,
         carNames n,
         carMakers m,
         modelList mo
      WHERE
         cu.Name = 'usa'
         AND 1972 <= d.YearMade
         AND d.YearMade <= 1976
         AND mo.Model = n.Model
         AND cu.Id = m.Country
         AND m.Id = mo.Maker
         AND n.Id = d.Id
      GROUP BY
         d.YearMade
      ) as inSub1,
      (SELECT
         d.YearMade,
         COUNT(*) as total
      FROM
         countries cu,
         carsData d,
         carNames n,
         modelList mo,
         carMakers m
      WHERE
         cu.Name <> 'usa'
         AND 1972 <= d.YearMade
         AND d.YearMade <= 1976
         AND mo.Model = n.Model
         AND cu.Id = m.Country
         AND m.Id = mo.Maker
         AND n.Id = d.Id
      GROUP BY
         d.YearMade
      ) as inSub2
      WHERE
         inSub1.YearMade = inSub2.YearMade
   ) as sub;
