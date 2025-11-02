SELECT 
    wo.style,
    COUNT(DISTINCT wo.work_id) AS total_paintings,
    STRING_AGG(DISTINCT art.full_name, ', ') AS artists,
    COUNT(DISTINCT art.artist_id) AS total_artists,
    DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT art.artist_id) DESC) AS ranking
FROM work wo
INNER JOIN artist art
USING (artist_id)
WHERE wo.style IS NOT NULL
GROUP BY wo.style 
ORDER BY total_artists DESC;