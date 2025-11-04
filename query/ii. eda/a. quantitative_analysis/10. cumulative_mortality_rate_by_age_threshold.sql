WITH artist_lifespan AS (
    SELECT
        full_name AS artist,
        death::integer - birth::integer AS lifespan
    FROM artist
    WHERE death IS NOT NULL 
        AND birth IS NOT NULL
)
SELECT 
    ROUND(
        100 * SUM(CASE WHEN lifespan < 50 THEN 1  ELSE  0 END)::numeric/COUNT(*),
        2
    ) AS pct_died_before_50,
    ROUND(
        100 * SUM(CASE WHEN lifespan < 70 THEN 1 ELSE  0 END)::numeric/COUNT(*),
        2
    ) AS pct_died_before_70,
    ROUND(
        100 * SUM(CASE WHEN lifespan < 80 THEN 1  ELSE  0 END)::numeric/COUNT(*),
        2
    ) AS pct_died_before_80,
    ROUND(
        100 * SUM(CASE WHEN lifespan < 90 THEN 1  ELSE  0 END)::numeric/COUNT(*),
        2
    ) AS pct_died_before_90,
    ROUND(
        100 * SUM(CASE WHEN lifespan < 100 THEN 1  ELSE  0 END)::numeric/COUNT(*),
        2
    ) AS pct_died_before_100,
    COUNT(*) AS total_artist
FROM artist_lifespan;