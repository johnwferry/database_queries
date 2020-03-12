SELECT lef.drinker, rig.bar
FROM


(SELECT Drinker.name AS drinker
FROM Drinker) as lef

LEFT OUTER JOIN



(
SELECT Frequents.drinker, Frequents.bar
FROM Frequents, (SELECT Frequents.drinker, MAX(Frequents.times_a_week)
                  FROM Frequents
                  GROUP BY Frequents.drinker) as inn
WHERE inn.drinker = Frequents.drinker
AND inn.max = Frequents.times_a_week) as rig


ON rig.drinker = lef.drinker
;
