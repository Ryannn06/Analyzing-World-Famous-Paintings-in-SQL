WITH work_subject AS (
    SELECT wo.work_id, wo.name, prod.size_id, wo.artist_id
    FROM work wo
    INNER JOIN product_size prod
    USING (work_id)
), prod_size AS (
    SELECT 
        wsub.*,
        (canv.width * canv.height) AS area
    FROM work_subject wsub
    INNER JOIN canvas_size canv
    ON wsub.size_id = canv.size_id::text
    WHERE canv.width IS NOT NULL 
        AND canv.height IS NOT NULL

), artist_canva AS (
    SELECT psize.*, art.full_name
    FROM prod_size psize
    INNER JOIN artist art
    USING (artist_id)
)
SELECT * FROM artist_canva;

SELECT wo.work_id, wo.name, prod.size_id, wo.artist_id
FROM work wo
INNER JOIN product_size prod
USING (work_id)