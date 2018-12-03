-- Abhinav Singh and Jake Veazey
-- asingh54@calpoly.edu and wveazey@calpoly.edu

-- BAK-1
SELECT
   g.Flavor,
   AVG(g.PRICE) as avgPrice,
   COUNT(DISTINCT g.Food) as types
FROM
   goods g
GROUP BY
   g.Flavor
HAVING
   COUNT(DISTINCT g.Food) > 3
ORDER BY
   avgPrice;

-- BAK-2
SELECT
   DAYNAME(sub.SaleDate) as Day,
   sub.SaleDate,
   COUNT(DISTINCT sub.RNumber) as Purchases,
   COUNT(sub.Item) as Pastries,
   ROUND(SUM(sub.PRICE), 2) as Revenue
FROM
   (SELECT
      r.RNumber,
      r.SaleDate,
      i.Item,
      g.PRICE
   FROM
      receipts r,
      items i,
      goods g
   WHERE
      8 <= DAY(r.SaleDate)
      AND MONTH(r.SaleDate) = 10
      AND DAY(r.SaleDate) < 15
      AND g.GId = i.Item
      AND i.Receipt = r.RNumber
   ) as sub
GROUP BY
   sub.SaleDate
ORDER BY
   sub.SaleDate;

-- BAK-3
SELECT DISTINCT
   c.FirstName,
   c.LastName
FROM
   customers c LEFT JOIN
   (SELECT DISTINCT
      r.Customer
   FROM
      receipts r,
      items i,
      goods g
   WHERE
      g.Food = 'Twist'
      AND MONTH(r.SaleDate) = 10
      AND YEAR(r.SaleDate) = 2007
      AND r.RNumber = i.Receipt
      AND i.Item = g.GId
   ) as sub
ON
   c.CId = sub.Customer
WHERE
   sub.Customer IS NULL
ORDER BY
   c.LastName;

-- BAK-4
SELECT
   sub.Food,
   sub.Flavor,
   sub.FirstName,
   sub.LastName,
   sub.Purchases
FROM
   (SELECT
      g.Food,
      g.Flavor,
      c.FirstName,
      c.LastName,
      COUNT(*) as Purchases
   FROM
      customers c,
      receipts r,
      items i,
      goods g
   WHERE
      g.Food = 'Cake'
      AND c.CId = r.Customer
      AND r.RNumber = i.Receipt
      AND i.Item = g.GId
   GROUP BY
      g.Food,
      g.Flavor,
      c.FirstName,
      c.LastName
   ORDER BY
      g.Food,
      g.Flavor,
      Purchases DESC
   ) as sub
WHERE
   sub.Purchases = 
      (SELECT
         MAX(sub.Purchases)
      )
GROUP BY
   sub.Food,
   sub.Flavor 
ORDER BY
   sub.Purchases DESC,
   sub.LastName;

-- BAK-5
SELECT
   c.FirstName,
   c.LastName
FROM
   customers c LEFT JOIN
      (SELECT DISTINCT
         c.CId
      FROM
         customers c,
         receipts r
      WHERE
         '2007-10-05' <= r.SaleDate
         AND r.SaleDate <= '2007-10-11'
         AND c.CId = r.Customer
      ) as sub
ON
   c.CId = sub.CId
WHERE
   sub.CId IS NULL
ORDER BY
   c.LastName;

-- BAK-6
SELECT
   c.FirstName,
   c.LastName,
   MIN(r.SaleDate) as Earliest
FROM
   customers c,
   receipts r,
      (SELECT
         q.Customer
      FROM
         receipts r,
            (SELECT
               r.Customer,
               MAX(r.SaleDate) as Latest
            FROM
               receipts r
            GROUP BY
               r.Customer
            ) as q
      WHERE
         q.Latest = r.SaleDate
         AND q.Customer = r.Customer
      GROUP BY
         r.Customer
      HAVING
         COUNT(*) > 1
      ) as sub
WHERE
   c.CId = r.Customer
   AND c.CId = sub.Customer
GROUP BY
   c.CId
ORDER BY
   Earliest;

-- BAK-7
SELECT
   sub.Category
FROM
   (SELECT
      g.Flavor as Category,
      SUM(g.PRICE) as Revenue
   FROM
      items i,
      goods g
   WHERE
      g.Flavor = 'Chocolate'
      AND i.Item = g.GId
   UNION
   SELECT
      g.Food as Category,
      SUM(g.PRICE) as Revenue
   FROM
      items i,
      goods g
   WHERE
      g.Food = 'Croissant'
      AND i.item = g.GId
   ORDER BY
      Revenue DESC
   ) as sub
LIMIT 1;
