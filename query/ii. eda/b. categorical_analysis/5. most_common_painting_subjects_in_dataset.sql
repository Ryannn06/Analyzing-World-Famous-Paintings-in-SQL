SELECT 
    subject,
    COUNT(DISTINCT work_id) AS total_paintings
FROM work wo
INNER JOIN subject sub
USING (work_id)
GROUP BY subject
ORDER BY total_paintings DESC;