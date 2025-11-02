SELECT 
    art.full_name AS artist,
    STRING_AGG(DISTINCT wo.style, ',') AS styles,
    COUNT(DISTINCT wo.style) AS total_styles
FROM work wo
INNER JOIN artist art
USING (artist_id)
WHERE wo.style IS NOT NULL
GROUP BY art.artist_id, art.full_name
HAVING COUNT(DISTINCT wo.style) > 1
ORDER BY total_styles DESC;