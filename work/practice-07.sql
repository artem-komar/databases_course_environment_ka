-- Practice 7: eight read-only tasks on activity_lab. Four core, four optional.
-- Keep this setting in the connection used for date casts and calendar reports:
SET TIME ZONE 'UTC';
SHOW TimeZone;
-- P7-1: September2026 events: inclusive September1, exclusive October1.
-- Return event_id, registration_id, occurred_at, status; order occurred_at, event_id.

SELECT event_id, registration_id, occurred_at, status
FROM activity_lab.registration_events
WHERE occurred_at >= TIMESTAMPTZ '2026-09-01 00:00:00+00' AND occurred_at < TIMESTAMPTZ '2026-10-01 00:00:00+00'
ORDER BY occurred_at, event_id;
-- P7-2: daily September counts with FILTER for registered and cancelled events.
SELECT cast (occurred_at as DATE) AS event_date,
  COUNT(*) as all_events,
    COUNT(*) FILTER (WHERE status = 'registered') AS registered_events,
    COUNT(*) FILTER (WHERE status = 'cancelled') AS cancelled_events
FROM activity_lab.registration_events
WHERE occurred_at >= TIMESTAMPTZ '2026-09-01 00:00:00+00' AND occurred_at < TIMESTAMPTZ '2026-10-01 00:00:00+00'
GROUP BY cast (occurred_at as DATE)
ORDER BY event_date;
-- P7-3: generate September1-7 dates and join daily counts, including zero-activity days.
WITH calendar AS (
    SELECT DATE '2026-09-01' + intervals AS report_date
    FROM generate_series(0, 6) AS days(intervals)
),
daily_counts AS (
    SELECT 
        occurred_at::date AS day,
        COUNT(*) FILTER (WHERE status = 'registered') AS registered_count,
        COUNT(*) FILTER (WHERE status = 'cancelled') AS cancelled_count
    FROM activity_lab.registration_events
    WHERE occurred_at >= '2026-09-01'
      AND occurred_at < '2026-09-08'
    GROUP BY occurred_at::date
)
SELECT 
    c.report_date AS event_date,
    COALESCE(d.registered_count, 0) AS registered_events,
    COALESCE(d.cancelled_count, 0) AS cancelled_events
FROM calendar c
LEFT JOIN daily_counts d ON c.report_date = d.day
ORDER BY event_date;
-- P7-4: latest state before October1; DISTINCT ON with timestamp DESC/event_id DESC;
WITH latest_status AS (
    SELECT DISTINCT ON (registration_id)
        event_id,
        registration_id,
        occurred_at,
        status
    FROM activity_lab.registration_events
    WHERE occurred_at < TIMESTAMPTZ '2026-10-01 00:00:00+00'
    ORDER BY registration_id, occurred_at DESC, event_id DESC
)
SELECT 
    event_id,
    registration_id,
    occurred_at,
    status
FROM latest_status
WHERE status = 'registered'
ORDER BY registration_id;
-- select active registrations AFTER choosing the latest event. Join registration identifiers.
-- Optional P7-5: use EXISTS to list each student who ever cancelled before October1 once.
-- Optional P7-6: current participants per workshop, including empty workshops; ordered STRING_AGG.
-- Optional P7-7: September event counts by date_trunc('week', occurred_at).
-- Optional P7-8: all workshops, September event counts and cancellation/registration ratio;
-- use numeric division and NULLIF for a zero denominator. Keep an undefined ratio NULL.
-- Save SQL, output, reasoning, the report time zone and the cutoff for every task.
