
SELECT Drinker.name
FROM Drinker
EXCEPT
      SELECT G.drinker as name
      FROM

      (SELECT large.drinker, large.bar
      FROM (SELECT *
               FROM
               (SELECT Frequents.drinker, Frequents.bar
                     FROM Frequents, Serves
                     WHERE Frequents.bar = Serves.bar) as temp2
               GROUP BY temp2.drinker, temp2.bar) as large
      EXCEPT
            SELECT small.drinker, small.bar
            FROM
            (SELECT *
                        FROM
                        (SELECT Likes.drinker, Al.bar
                        FROM (SELECT Frequents.drinker, Frequents.bar, Serves.beer
                        FROM Frequents, Serves
                        WHERE Frequents.bar = Serves.bar) as Al, Likes
                        WHERE Al.beer = Likes.beer
                        AND Al.drinker = Likes.Drinker) as temp
                        GROUP BY temp.drinker, temp.bar) as small) as G


;
