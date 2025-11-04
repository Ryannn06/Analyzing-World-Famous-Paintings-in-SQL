WITH artist_lifespan AS (
    SELECT
        full_name AS artist,
        death::integer - birth::integer AS lifespan,
        DENSE_RANK() OVER(ORDER BY death::integer - birth::integer ASC) as ranking
    FROM artist
    WHERE death IS NOT NULL 
        AND birth IS NOT NULL
)
SELECT *
FROM artist_lifespan
WHERE ranking <= 10
ORDER BY ranking ASC;