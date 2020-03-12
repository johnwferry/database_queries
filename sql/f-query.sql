

  SELECT Serves.bar, Serves.beer, Serves.price
  FROM Serves,
  (SELECT MIN(pr.price) as price
      FROM Serves, (
        SELECT Serves.price
        FROM Serves, (SELECT Serves.bar, Serves.beer, Serves.price FROM Serves, (SELECT MIN(foo.price) AS price FROM (SELECT Serves.price FROM Serves) as foo) as m WHERE Serves.price = m.price ) as mn
        WHERE Serves.price > mn.price) AS pr) AS min2, (SELECT MIN(foo.price) AS price FROM (SELECT Serves.price FROM Serves) as foo) as min1
  WHERE Serves.price = min1.price
  OR Serves.price = min2.price



;
