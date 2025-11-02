SELECT
    mu.name,
    mu.country, 
    COUNT(DISTINCT wo.work_id) AS total_paintings
FROM museum mu
INNER JOIN work wo
ON mu.museum_id = wo.museum_id
GROUP BY mu.museum_id, mu.name, mu.country
ORDER BY total_paintings DESC;