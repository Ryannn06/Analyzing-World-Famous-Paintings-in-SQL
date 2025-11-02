SELECT 
    style,
    COUNT(DISTINCT work_id) AS total_paintings,
    DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT work_id) DESC) AS ranking
FROM work
WHERE style IS NOT NULL
GROUP BY style
ORDER BY total_paintings DESC;