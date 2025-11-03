WITH subject_work AS (
    SELECT 
        wo.artist_id,
        wo.work_id,
        sub.subject,
        COUNT(DISTINCT wo.work_id) AS total_paintings
    FROM work wo
    INNER JOIN subject sub
    USING (work_id)
    GROUP BY wo.artist_id, wo.work_id, sub.subject
)
SELECT
    COALESCE(art.full_name, 'Grand Total') AS artist,
    COALESCE(subw.subject, 'Subtotal') AS subject,
    SUM(total_paintings) AS total_paintings
FROM subject_work subw
INNER JOIN artist art
USING (artist_id)
GROUP BY ROLLUP(art.full_name, subw.subject)
ORDER BY art.full_name ASC, total_paintings ASC;