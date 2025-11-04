SELECT
    day,
    TO_CHAR(AVG(open), 'HH24:MI') AS avg_open_time,
    TO_CHAR(AVG(close), 'HH24:MI') AS avg_close_time,
    TO_CHAR((AVG(close) - AVG(open)), 'HH24:MI') AS avg_duration
FROM museum_hours
GROUP BY day
ORDER BY avg_duration DESC;