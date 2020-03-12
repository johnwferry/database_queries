SELECT Bar.name
FROM Frequents, Bar
WHERE Frequents.drinker LIKE '%Eve%'
AND Bar.name = Frequents.bar;
