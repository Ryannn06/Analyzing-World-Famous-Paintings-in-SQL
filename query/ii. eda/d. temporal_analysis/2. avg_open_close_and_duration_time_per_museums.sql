SELECT
    mus.name AS museum,
    TO_CHAR(AVG(muh.open), 'HH24:MI') AS opening_time,
    TO_CHAR(AVG(muh.close), 'HH24:MI') AS closing_time,
    TO_CHAR((AVG(muh.close) - AVG(muh.open)), 'HH24:MI') AS avg_duration
FROM museum_hours muh
INNER JOIN museum mus
USING (museum_id)
GROUP BY muh.museum_id, mus.name
ORDER BY avg_duration;