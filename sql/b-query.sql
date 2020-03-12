SELECT Drinker.name, Drinker.address
FROM Frequents, Drinker
WHERE Frequents.bar LIKE '%Satisfaction%'
AND Frequents.drinker = Drinker.name;
