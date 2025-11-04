WITH artist_count AS (
    SELECT 
        art.artist_id,
        COUNT(wo.work_id)
    FROM work wo 
    INNER JOIN artist art
    USING (artist_id)
    GROUP BY art.artist_id
)
SELECT AVG(count)::integer AS avg_no_of_paintings_per_artist
FROM artist_count;