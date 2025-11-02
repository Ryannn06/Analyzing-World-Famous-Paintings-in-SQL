SELECT 
    mu.country, 
    COUNT(DISTINCT wo.work_id) AS total_paintings,
    DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT wo.work_id) DESC) as ranking
FROM work wo
INNER JOIN museum mu
ON wo.museum_id = mu.museum_id
GROUP BY mu.country
ORDER BY total_paintings DESC;