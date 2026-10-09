-- Practice 8: use reporting_lab.results (14 fictional rows, 12 graded).
-- P8-1: keep every graded row; add offering AVG, graded COUNT and grade minus offering AVG with OVER.
select student_id, offering_id, grade,
  avg(grade) over (partition by offering_id) as offering_avg,
  count(grade) over (partition by offering_id) as offering_graded_count,
  grade - avg(grade) over (partition by offering_id) as grade_diff_from_avg
from reporting_lab.results
where grade is not null
order by offering_id, student_id;
-- P8-2: rank graded rows per offering with ROW_NUMBER (grade DESC, student_id),
-- RANK and DENSE_RANK (grade DESC only). Order displayed rows by offering_id and position.
select student_id, offering_id, grade,
  row_number() over (partition by offering_id order by grade desc, student_id) as position,
  rank() over (partition by offering_id order by grade desc) as points_rank,
  dense_rank() over (partition by offering_id order by grade desc) as dense_points_rank
from reporting_lab.results
where grade is not null
order by offering_id, position;
-- P8-3: use a CTE and an outer filter to return exactly two graded students per offering.
with ranked as (select student_id, offering_id, grade,
    row_number() over (partition by offering_id order by grade desc, student_id) as position
  from reporting_lab.results
  where grade is not null)
select student_id, offering_id, grade, position 
from ranked
where position<=2
order by offering_id, position;
-- P8-4: group ALL results by enrolled_on; add a running count with SUM OVER and an explicit ROWS frame.
select enrolled_on,
  count(*) as daily_count,
  sum(count(*)) over (order by enrolled_on rows between unbounded preceding and current row) as running_total
from reporting_lab.results
group by enrolled_on
order by enrolled_on;
-- Optional P8-5: use LAG(grade) per student (enrolled_on, offering_id) to show previous grade and change.
-- Optional P8-6: from daily counts, AVG the current and two preceding observed dates with a ROWS frame.
-- Optional P8-7: split graded rows per offering into three balanced NTILE groups (grade DESC, student_id).
-- Optional P8-8: attach FIRST_VALUE, default LAST_VALUE and full-frame LAST_VALUE per student;
-- order history by enrolled_on, offering_id and keep NULL grades.
-- Save one query, output and reasoning per task. Predict the ties/NULLs/date gap before running.
