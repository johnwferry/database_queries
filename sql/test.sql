
SELECT *
FROM
(SELECT rig.beer, coalesce(rig.count, 0) as count, lef.avg
FROM      (SELECT bs.beer, ls.count

      FROM (SELECT Beer.name as beer, COUNT(*) as bc
      FROM Beer
      GROUP BY Beer.name) as bs

      FULL OUTER JOIN


      (SELECT Likes.beer, COUNT(*)
      FROM Likes
      GROUP BY Likes.beer) as ls

      ON bs.beer = ls.beer) as rig

FULL OUTER JOIN

(SELECT Serves.beer, AVG(Serves.price)
  FROM Serves
  GROUP BY Serves.beer
) as lef

ON lef.beer = rig.beer) as fin
ORDER BY fin.count DESC, fin.beer ASC
