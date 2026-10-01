-- P3-S: Build library_lab.borrowers, books, copies, and loans here.
-- Start with an empty library_lab (sql/practice-03-start.sql).
-- Use the column names, keys, and rules in docs/practices-03-04.md.
-- Do not paste the recovery schema until you have attempted your own design.


CREATE TABLE library_lab.borrowers (
    borrower_id integer PRIMARY KEY,
    full_name text NOT NULL,
    card_code text NOT NULL UNIQUE
);

CREATE TABLE library_lab.books (
    book_id integer PRIMARY KEY,
    title text NOT NULL,
    isbn text NOT NULL UNIQUE,
    published_on date
);

CREATE TABLE library_lab.copies (
    copy_id integer PRIMARY KEY,
    book_id integer NOT NULL CONSTRAINT copies_book_fk REFERENCES library_lab.books (book_id),
    inventory_code varchar(12) NOT NULL UNIQUE,
    replacement_cost numeric(8,2) NOT NULL CONSTRAINT copies_cost_check CHECK (replacement_cost >= 0),
    retired boolean NOT NULL DEFAULT false
);

CREATE TABLE library_lab.loans (
    loan_id integer PRIMARY KEY,
    borrower_id integer NOT NULL CONSTRAINT loans_borrower_fk REFERENCES library_lab.borrowers (borrower_id),
    copy_id integer NOT NULL CONSTRAINT loans_copy_fk REFERENCES library_lab.copies (copy_id),
    borrowed_at timestamptz NOT NULL,
    due_at timestamptz NOT NULL,
    returned_at timestamptz,
    CONSTRAINT loans_copy_start_key UNIQUE (copy_id, borrowed_at),
    CONSTRAINT loans_due_check CHECK (due_at >= borrowed_at),
    CONSTRAINT loans_return_check CHECK (returned_at >= borrowed_at)
);