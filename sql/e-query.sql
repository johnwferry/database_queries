
SELECT Serves.beer, Serves.bar
  FROM Bar, Serves, (SELECT Foo.beer, MAX(Foo.price) as max
  FROM (SELECT Serves.price, Serves.beer
    FROM Serves, Likes
    WHERE Serves.beer = Likes.beer
    AND Likes.drinker LIKE '%Eve%') AS Foo
  GROUP BY Foo.beer) as foo2
  WHERE Bar.name = Serves.bar
  AND Serves.beer = foo2.beer
  AND Serves.price = foo2.max

;
