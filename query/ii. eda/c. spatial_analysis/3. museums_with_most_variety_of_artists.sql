SELECT 
    mu.name AS museum,
    mu.country,
    COUNT(DISTINCT artist_id) AS total_artists
FROM museum mu
INNER JOIN work wo
USING (museum_id)
GROUP BY mu.museum_id, mu.name, mu.country
ORDER BY total_artists DESC;