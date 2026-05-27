-- 26-05-2026 | Indexes, Keys, and Query Fine Tuning

-- Indexes: An index is like the index page of a book. Without an index, MySQL may scan the whole table row by row.
-- With an index, MySQL can directly find the required rows faster.

-- Clustered Index : A clustered index decides the physical order of data inside the table.
-- In MySQL InnoDB, the PRIMARY KEY acts like a clustered index.
-- So when you create a primary key, MySQL stores the table data based on that primary key order.

-- customer_id is the primary key in customer table.
SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE customer_id = 10;

SHOW INDEX FROM customer;

-- Non-Clustered Index: A non-clustered index is a separate index created on a column.
-- It does not change the physical order of the table.
-- It stores the indexed column value along with a pointer to the actual row.

-- Create an index on last_name column
-- This helps when searching customers by last name
CREATE INDEX idx_customer_last_name ON customer(last_name);
SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE last_name = 'SMITH';


-- This query joins customer and payment tables.
-- Indexes on customer_id help the join run faster.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    p.amount,
    p.payment_date
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
WHERE c.customer_id = 5;

-- Composite Index : A composite index is an index created on multiple columns.
CREATE INDEX idx_rental_customer_date ON rental(customer_id, rental_date);
SELECT
    rental_id,
    customer_id,
    rental_date,
    return_date
FROM rental
WHERE customer_id = 10
ORDER BY rental_date;

-- Remove index if not needed
DROP INDEX idx_customer_last_name
ON customer;

-- -----------------------------------------------------------------------------------------------
-- Natural Keys and Surrogate Keys
-- What is a Natural Key: A natural key is a real-world column that can uniquely identify a record.
-- Examples: Email, SSN, Passport number, Phone number, Employee ID
-- -----------------------------------------------------------------------------------------------

SELECT
    customer_id,
    first_name,
    last_name,
    email
FROM customer
WHERE email = 'MARY.SMITH@sakilacustomer.org';
-- Here, email is a real-world value, So it can be considered a natural key.

-- Natural Key Example: Searching customer using email, Email is meaningful in real life
SELECT
    customer_id,
    first_name,
    last_name,
    email
FROM customer
WHERE email = 'PATRICIA.JOHNSON@sakilacustomer.org';

-- Natural keys can change.
-- Example: A customer can change email. If email is used as primary key, changing it becomes risky.
-- That is why natural keys are not always preferred as primary keys.


-- -----------------------------------------------------------------------------------------------
-- Surrogate key: A surrogate key is an artificial ID created only for the database. It has no real-world meaning.
-- Examples in Sakila: customer_id, film_id, actor_id, rental_id, payment_id, address_id
-- -----------------------------------------------------------------------------------------------

-- Surrogate Key Example with JOIN
-- customer_id connects customer and rental tables. customer_id is a surrogate key.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    r.rental_id,
    r.rental_date
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
WHERE c.customer_id = 1;


-- -----------------------------------------------------------------------------------------------
-- SQL Query Fine Tuning Techniques: Query fine tuning means improving SQL queries so they run faster and use fewer resources.
-- -----------------------------------------------------------------------------------------------


-- Technique 1: Use EXPLAIN, EXPLAIN shows how MySQL plans to execute a query.
EXPLAIN
SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE last_name = 'SMITH';

-- Look mainly at: type, possible_keys, key, rows, Extra
-- If rows is very high, MySQL is scanning many rows. If key is NULL, no index is being used.

-- Technique 2: Avoid SELECT *
-- Bad practice. This fetches every column even if we do not need all columns
SELECT *
FROM customer;

-- Better practice. Select only required columns
SELECT
    customer_id,
    first_name,
    last_name,
    email
FROM customer;
-- Because less data is read, transferred, and displayed.

-- Technique 3: Use WHERE to Filter Early

-- Bad: This brings all payments first. Then we mentally check high payments
SELECT
    payment_id,
    customer_id,
    amount
FROM payment;

-- Better: Filter only required records
SELECT
    payment_id,
    customer_id,
    amount
FROM payment
WHERE amount > 8;

-- Technique 4: Create Index on Frequently Filtered Columns
-- If we often search payments by amount, we can create an index on amount.
CREATE INDEX idx_payment_amount
ON payment(amount);
-- Then:
SELECT
    payment_id,
    customer_id,
    amount
FROM payment
WHERE amount > 8;
-- can become faster.

-- Technique 5: Avoid Functions on Indexed Columns
-- Bad because function is applied on payment_date
-- MySQL may not use index properly
SELECT
    payment_id,
    payment_date,
    amount
FROM payment
WHERE DATE(payment_date) = '2005-05-25';

-- Below command is better because column is used directly
SELECT
    payment_id,
    payment_date,
    amount
FROM payment
WHERE payment_date >= '2005-05-25'
  AND payment_date < '2005-05-26';
-- This is better for index usage.

-- Technique 6: Use JOIN Instead of Repeated Subqueries
-- Less efficient style: Subquery style 
SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE customer_id IN
(
    SELECT customer_id
    FROM payment
    WHERE amount > 10
);

-- Better style: JOIN style. Easier to understand and often better for performance
SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
WHERE p.amount > 10;


-- Technique 7: Use LIMIT When Testing Queries
-- Useful when checking data. Do not load thousands of rows unnecessarily
SELECT
    rental_id,
    rental_date,
    customer_id
FROM rental
LIMIT 10;

-- Technique 8: Index Columns Used in JOIN
-- Example:
SELECT
    f.film_id,
    f.title,
    i.inventory_id
FROM film f
JOIN inventory i
ON f.film_id = i.film_id;

-- Here, film_id should be indexed in both tables. Usually primary key and foreign key columns are indexed or should be indexed.

-- Technique 9: Use Composite Index for Multiple Conditions
-- Create composite index for common filtering pattern
CREATE INDEX idx_payment_customer_amount
ON payment(customer_id, amount);

-- Useful query:
SELECT
    payment_id,
    customer_id,
    amount
FROM payment
WHERE customer_id = 10
  AND amount > 5;
-- This is better than having only separate indexes sometimes.

-- Technique 10: Be Careful with OR
-- below command is less efficient:
SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE first_name = 'MARY'
   OR last_name = 'SMITH';

-- Sometimes better:
SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE first_name = 'MARY'

UNION

SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE last_name = 'SMITH';
-- This can allow MySQL to use separate indexes better.

-- Technique 11: Use EXISTS for Existence Check
-- Example: Find customers who have made at least one payment
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
WHERE EXISTS
(
    SELECT 1
    FROM payment p
    WHERE p.customer_id = c.customer_id
);
-- EXISTS is useful when we only care whether a matching row exists.

-- Technique 12: Avoid Unnecessary DISTINCT
-- belo command is Bad: DISTINCT adds extra work
SELECT DISTINCT
    first_name,
    last_name
FROM customer;

-- Better if duplicates are not a problem:
SELECT
    first_name,
    last_name
FROM customer;
-- Use DISTINCT only when you really need unique rows.

-- Technique 13: Use GROUP BY Carefully
-- Example: Find total payment by each customer
SELECT
    customer_id,
    SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id;

-- Better with JOIN:
-- Show customer name with total amount
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_amount
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;
-- For better performance, payment.customer_id should be indexed.

-- Technique 14: Filter Before GROUP BY
-- below command is bad: Groups all payments first
SELECT
    customer_id,
    SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100;
-- Better when possible:

-- WHERE filters rows before grouping
SELECT
    customer_id,
    SUM(amount) AS total_amount
FROM payment
WHERE amount > 5
GROUP BY customer_id
HAVING SUM(amount) > 100;

-- NOTE: WHERE filters rows before GROUP BY. HAVING filters groups after GROUP BY.

-- Technique 15: Avoid Leading Wildcard in LIKE
-- below command is bad for index usage. Starts with %, so MySQL cannot easily use index
SELECT
    film_id,
    title
FROM film
WHERE title LIKE '%ACADEMY%';

-- below command is better because pattern starts from the beginning
SELECT
    film_id,
    title
FROM film
WHERE title LIKE 'ACADEMY%';


-- Technique 16: Use Proper Data Types
-- it is not good to Storing amount as VARCHAR, Storing date as VARCHAR
-- Better to 
	-- amount -> DECIMAL
	-- date -> DATE / DATETIME
	-- id -> INT
	-- name -> VARCHAR


-- Technique 17: Avoid Sorting Huge Data Without Need
-- not a good way to use below commands
SELECT
    rental_id,
    rental_date,
    customer_id
FROM rental
ORDER BY rental_date;

-- Better way of using it is: 
SELECT
    rental_id,
    rental_date,
    customer_id
FROM rental
ORDER BY rental_date
LIMIT 20;
-- If sorting column is indexed, performance improves.
CREATE INDEX idx_rental_date ON rental(rental_date);


-- Technique 18: Use Covering Index. A covering index means the index contains all columns needed by the query.
-- Example:
CREATE INDEX idx_customer_name_email ON customer(last_name, first_name, email);
-- Query:
SELECT
    first_name,
    email
FROM customer
WHERE last_name = 'SMITH';
-- MySQL may get all required data from the index itself.

-- Technique 19: Avoid Too Many Indexes. Do not create indexes blindly.
-- Too many indexes cause slower: INSERT, UPDATE, DELETE
-- Because every index must be updated.

-- Good columns for indexes: Columns used in WHERE, Columns used in JOIN, Columns used in ORDER BY, Columns used in GROUP BY, Foreign key columns
-- Bad columns for indexes: Columns rarely used, Columns with very few values like Y/N, Very small tables


-- Technique 20: Check Existing Indexes Before Creating
SHOW INDEX FROM customer;
SHOW INDEX FROM rental;
SHOW INDEX FROM payment;
SHOW INDEX FROM film;







