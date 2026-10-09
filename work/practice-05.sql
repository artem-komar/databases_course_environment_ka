-- Practice 5: save solutions below each label. The fresh-start migration preloads library_p5.
-- P5-1: Join copies to books and explain the zero-cost retired copy.
SELECT *
FROM library_p5.copies AS c
RIGHT 
JOIN library_p5.books AS b ON c.book_id = b.book_id;

-- P5-2: Left join books, book_authors, and authors, retaining book 30.
SELECT
    b.book_id,
    b.title,
    a.full_name AS author_name,
    ba.credit_order
FROM library_p5.books b
LEFT JOIN library_p5.book_authors ba ON b.book_id = ba.book_id
LEFT JOIN library_p5.authors a ON ba.author_id = a.author_id
ORDER BY b.book_id, ba.credit_order;
-- P5-3: Left join students to enrolments, including student 7.
SELECT 
    s.student_id,
    s.full_name,
    e.offering_id,
    e.grade
FROM practice.students AS s
LEFT JOIN practice.enrolments AS e ON s.student_id = e.student_id
ORDER BY s.student_id DESC, e.offering_id;;
-- P5-4: Report enrolments, grades, and averages for every course.
-- P5-4: Report enrolments, grades, and averages for every course.
SELECT 
    c.course_id,
    c.title,
    COUNT(e.student_id) AS enrolment_count,
    COUNT(e.grade) AS graded_count,
    AVG(e.grade) AS average_grade
FROM practice.courses c
LEFT JOIN practice.course_offerings o ON c.course_id = o.course_id
LEFT JOIN practice.enrolments e ON o.offering_id = e.offering_id
GROUP BY c.course_id, c.title
ORDER BY c.course_id;

-- Optional P5-5: Autumn offering report with WHERE and HAVING.
-- Optional P5-6: Students in multiple offerings of one course.
