SELECT 
    art.full_name AS artists,
    COUNT(wo.work_id) AS total_no_of_paintings
FROM work wo
LEFT JOIN artist art
USING (artist_id)
GROUP BY art.artist_id, art.full_name
ORDER BY total_no_of_paintings DESC;