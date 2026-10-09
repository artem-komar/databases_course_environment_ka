-- Practice 6: save solutions below each label. The fresh-start migration preloads library_p6.
-- P6-1: Join mixed credits to books and authors to compare repeated facts.
SELECT
   b.book_id,
   b.title,
   a.author_id,
   a.full_name AS author_name,
   ba.credit_order
FROM library_p6.books b
JOIN library_p6.book_authors ba ON b.book_id = ba.book_id
JOIN library_p6.authors a ON ba.author_id = a.author_id
ORDER BY b.book_id, ba.credit_order;
-- P6-2: Write one live/stored comparison query; rerun after the supplied update and refresh.
SELECT 
    v.loan_id,
    v.borrower_name AS live_name,
    mv.borrower_name AS stored_name
FROM library_p6.v_loans_report v
JOIN library_p6.mv_loans_report mv ON v.loan_id = mv.loan_id
WHERE v.borrower_name = 'Olena Bondar';
-- P6-3: Write UNION for the two offerings; compare with the supplied UNION ALL query.
-- P6-4: Build one CTE offering summary for 1001, 1007, and 1008.
-- Optional P6-5: Use EXCEPT to find students without enrolments.
-- Optional P6-6: Classify grouped offerings with a derived table, scalar subquery, CASE, and COALESCE.
