WITH subject_work AS (
    SELECT 
        wo.artist_id,
        wo.work_id,
        sub.subject
    FROM work wo
    INNER JOIN subject sub USING (work_id)
), subject_rank AS (
    SELECT 
        art.artist_id,
        art.full_name,
        subj.subject,
        COUNT(DISTINCT subj.work_id) AS total_paintings,
        RANK() OVER (PARTITION BY art.artist_id ORDER BY COUNT(DISTINCT subj.work_id) DESC) AS rank
    FROM subject_work subj
    INNER JOIN artist art USING (artist_id)
    GROUP BY art.artist_id, art.full_name, subj.subject
)
SELECT 
    full_name,
    subject AS most_common_subject,
    total_paintings
FROM subject_rank
WHERE rank = 1
ORDER BY total_paintings DESC;