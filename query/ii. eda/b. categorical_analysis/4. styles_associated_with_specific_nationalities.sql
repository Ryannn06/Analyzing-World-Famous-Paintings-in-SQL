WITH artist_count AS (
    SELECT 
        wo.style,
        art.nationality,
        COUNT(DISTINCT art.artist_id) AS total_artists
    FROM work wo
    INNER JOIN artist art 
    USING (artist_id)
    WHERE wo.style IS NOT NULL
    GROUP BY wo.style, art.nationality
)
SELECT 
    COALESCE(style, 'Grand Total') AS style,
    COALESCE(nationality, 'Subtotal') AS nationality,
    SUM(total_artists) AS total_artists
FROM artist_count
GROUP BY ROLLUP(style, nationality)
ORDER BY style, total_artists ASC; 