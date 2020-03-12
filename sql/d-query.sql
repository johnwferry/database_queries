SELECT Likes.drinker as name
FROM Likes
WHERE Likes.drinker NOT IN (SELECT Likes.drinker FROM Likes WHERE Likes.beer LIKE '%Budweiser%')
AND Likes.beer LIKE '%Corona%';
