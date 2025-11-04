-- correct lifespan for Pieter Bruegel
UPDATE artist
SET death = 1569
WHERE artist_id = 596;

WITH artist_lifespan AS (
    SELECT
        artist_id,
        full_name,
        death - birth AS lifespan
    FROM artist
    WHERE death IS NOT NULL 
        AND birth IS NOT NULL
)
SELECT AVG(lifespan)::integer AS avg_lifespan_of_artists
FROM artist_lifespan;