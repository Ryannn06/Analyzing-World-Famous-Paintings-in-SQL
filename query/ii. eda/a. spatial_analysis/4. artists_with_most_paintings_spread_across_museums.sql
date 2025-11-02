WITH artist_work AS (
    SELECT 
        art.artist_id,
        art.nationality,
        art.full_name,
        wo.museum_id,
        wo.work_id
    FROM artist art
    INNER JOIN work wo
    USING (artist_id)
)
SELECT 
    art.full_name AS artist,
    art.nationality,
    COUNT(DISTINCT art.work_id) AS total_paintings,
    STRING_AGG(DISTINCT mu.name, ', ') AS museums,
    COUNT(DISTINCT mu.museum_id) AS total_no_of_museums
FROM artist_work art
INNER JOIN museum mu
USING (museum_id)
GROUP BY art.artist_id, art.full_name, art.nationality
ORDER BY total_no_of_museums DESC;