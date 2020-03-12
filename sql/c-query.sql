SELECT Bar.name
FROM Likes, Serves, Bar
WHERE Likes.drinker LIKE '%Amy%'
AND Serves.beer = Likes.beer
AND Bar.name = Serves.bar
AND Serves.price < '2.75';
