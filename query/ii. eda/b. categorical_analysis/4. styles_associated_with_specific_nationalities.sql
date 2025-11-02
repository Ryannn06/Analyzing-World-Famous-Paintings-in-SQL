SELECT 
    COALESCE(wo.style, 'Grant Total') AS style,
    COALESCE(art.nationality, 'Subtotal') AS nationality,
    COUNT(DISTINCT art.artist_id) AS total_artists
FROM work wo
INNER JOIN artist art
USING (artist_id)
WHERE wo.style IS NOT NULL
GROUP BY ROLLUP(wo.style, art.nationality)
ORDER BY wo.style, total_artists ASC;