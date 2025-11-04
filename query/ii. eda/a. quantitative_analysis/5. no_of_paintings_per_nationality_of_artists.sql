SELECT 
    art.nationality,
    COUNT(work_id) AS total_no_of_paintings
FROM work wo
INNER JOIN artist art
USING (artist_id)
GROUP BY art.nationality
ORDER BY total_no_of_paintings DESC;