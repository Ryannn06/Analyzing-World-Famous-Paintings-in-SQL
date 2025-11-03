WITH subject_work AS (
    SELECT 
        wo.artist_id,
        sub.subject,
        COUNT(DISTINCT wo.work_id) AS total_paintings
    FROM work wo
    INNER JOIN subject sub
    USING (work_id)
    GROUP BY wo.artist_id, sub.subject
), subject_rank AS (
    SELECT 
        art.full_name,
        subj.subject,
        total_paintings,
        RANK() OVER(PARTITION BY artist_id ORDER BY total_paintings DESC) AS rank
    FROM subject_work subj
    INNER JOIN artist art
    USING (artist_id)
)
SELECT 
    full_name,
    subject AS most_common_subject,
    total_paintings
FROM subject_rank WHERE rank = 1
ORDER BY full_name ASC;