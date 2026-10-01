-- P3-Q: Write Q1-Q5 from docs/practices-03-04.md.
-- For each query, note its row grain and where each selected column comes from.

-- Q1: Borrower for card code 0001.

-- Q2: Unreturned loan IDs, ordered.

-- Q3: Borrower 1 loan IDs and book titles through copies, ordered by time and ID.

-- Q4: Q3's titles only; explain repeated values.

-- Q5: Non-retired, positive-cost copy IDs, ordered.
-- Q1: Return borrower_id and full_name for card code 0001.
-- Grain: borrower
-- Output columns: borrower_id (borrowers), full_name (borrowers)
SELECT borrower_id, full_name
FROM library_lab.borrowers
WHERE card_code = '0001';

-- Q2: Return loan_id for unreturned loans, ordered by loan_id.
-- Grain: active loan
-- Output columns: loan_id (loans)
SELECT loan_id
FROM library_lab.loans
WHERE returned_at IS NULL
ORDER BY loan_id;

-- Q3: For borrower 1, return loan_id and book title, ordered by borrowing time, then loan ID.
-- Grain: loan event
-- Output columns: loan_id (loans), title (books)
SELECT l.loan_id, b.title
FROM library_lab.loans l
JOIN library_lab.copies c ON l.copy_id = c.copy_id
JOIN library_lab.books b ON c.book_id = b.book_id
WHERE l.borrower_id = 1
ORDER BY l.borrowed_at, l.loan_id;

-- Q4: Repeat Q3 with only the title in the output. Explain repeated values.
-- Grain: loan event (projected to title)
-- Output columns: title (books)
-- Explanation: Читач 1 двічі брав примірник 101 у різний час. Обидві видачі відносяться до книги "Learning Databases", тому вивід лише поля title продублює назву книги.
SELECT b.title
FROM library_lab.loans l
JOIN library_lab.copies c ON l.copy_id = c.copy_id
JOIN library_lab.books b ON c.book_id = b.book_id
WHERE l.borrower_id = 1
ORDER BY l.borrowed_at, l.loan_id;

-- Q5: Return copy_id for non-retired copies with a positive replacement cost, ordered by copy_id.
-- Grain: copy
-- Output columns: copy_id (copies)
SELECT copy_id
FROM library_lab.copies
WHERE retired = false AND replacement_cost > 0
ORDER BY copy_id;