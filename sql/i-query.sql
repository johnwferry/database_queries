
SELECT Drinker.name
FROM Drinker
EXCEPT ALL
(SELECT inter.drinker
FROM (
SELECT fl.drinker, fl.bar
FROM
(SELECT *
FROM
(SELECT Likes.drinker, Serves.bar
                  FROM Serves, Likes
                  WHERE Serves.beer = Likes.beer) as dl
GROUP BY dl.drinker, dl.bar) as fl

EXCEPT ALL
(SELECT Frequents.drinker, Frequents.bar FROM Frequents)) as inter
GROUP BY inter.drinker)
;
