
-- 20-05-2026 STRING BUILT-IN FUNCTIONS

USE sakila;

-- LPAD(): Adds characters to the LEFT side of a value until it reaches the given length
-- If first_name is less than 10 characters, * will be added on the left side
SELECT first_name,
       LPAD(first_name, 10, '*') AS padded_name
FROM actor;
-- customer_id 1 becomes 00001
SELECT customer_id,
       LPAD(customer_id, 5, '0') AS formatted_customer_id
FROM customer;

-- RPAD(): Adds characters to the RIGHT side of a value until it reaches the given length
-- If first_name is less than 10 characters, * will be added on the right side
SELECT first_name,
       RPAD(first_name, 10, '*') AS padded_name
FROM actor;

-- LPAD + RPAD: Using both left padding and right padding together
-- First adds * on the left to make length 10
-- Then adds - on the right to make length 15
SELECT first_name,
       RPAD(LPAD(first_name, 10, '*'), 15, '-') AS formatted_name
FROM actor;

-- SUBSTRING(): Extracts part of a string, Starts from position 1 and takes 5 characters
-- In SQL indexing starts from '1' not '0'
SELECT title,
       SUBSTRING(title, 2, 5) AS first_five_letters
FROM film;

-- CONCAT(): Joins two or more values together, here it Combines first_name and last_name with a space
SELECT first_name,
       last_name,
       CONCAT(first_name, ' ', last_name) AS full_name
FROM actor;

-- CONCAT() with text
SELECT title,
       rental_rate,
       CONCAT(title, ' costs $', rental_rate) AS film_price_text
FROM film
LIMIT 10;

-- REVERSE(): Reverses the given string, Shows actor first_name in reverse order
SELECT first_name,
       REVERSE(first_name) AS reversed_name
FROM actor;

-- LENGTH(): Returns the number of bytes/characters in a string, Shows length of each actor first_name
SELECT first_name,
       LENGTH(first_name) AS name_length
FROM actor;

-- LENGTH() with film title, Shows film titles sorted by longest title first
SELECT title,
       LENGTH(title) AS title_length
FROM film
ORDER BY title_length DESC;

-- LOCATE(): Finds the position of a substring inside a string
-- Shows the position where letter A appears first, If A is not found, it returns 0
SELECT title,
       LOCATE('A', title) AS position_of_A
FROM film;

-- SUBSTRING with LOCATE example on email, Extracts text after @ from email
SELECT email,
       SUBSTRING(email, 1, LOCATE('@', email) + 1) AS username_part
FROM customer;

-- SUBSTRING_INDEX(): Returns part of a string before or after a delimiter
-- Returns text before @
SELECT email,
       SUBSTRING_INDEX(email, '@', 1) AS username_part
FROM customer;

-- SUBSTRING_INDEX() after delimiter, Returns text after @
SELECT email,
       SUBSTRING_INDEX(email, '@', -1) AS domain_part
FROM customer;

-- UPPER(): Converts text into uppercase, Converts first_name into capital letters
SELECT first_name,
       UPPER(first_name) AS uppercase_name
FROM actor;

-- LOWER(): Converts text into lowercase, Converts first_name into small letters
SELECT first_name,
       LOWER(first_name) AS lowercase_name
FROM actor;

-- LEFT(): Extracts characters from the left side, Shows first 3 letters from first_name
SELECT first_name,
       LEFT(first_name, 3) AS first_three_letters
FROM actor;

-- RIGHT(): Extracts characters from the right side, Shows last 3 letters from last_name
SELECT last_name,
       RIGHT(last_name, 3) AS last_three_letters
FROM actor;

-- CASE statement: Used to create conditional output, Categorizes films based on rental_rate
SELECT title,
       rental_rate,
       CASE
           WHEN rental_rate = 0.99 THEN 'Cheap'
           WHEN rental_rate = 2.99 THEN 'Medium'
           WHEN rental_rate = 4.99 THEN 'Expensive'
           ELSE 'Other'
       END AS price_category
FROM film;

-- CASE statement with film length, Creates movie duration category based on length
SELECT title,
       length,
       CASE
           WHEN length < 60 THEN 'Short Movie'
           WHEN length BETWEEN 60 AND 120 THEN 'Average Movie'
           ELSE 'Long Movie'
       END AS movie_duration_type
FROM film;

-- REPLACE() with email, Replaces .org with .com in email
SELECT email,
       REPLACE(email, '.org', '.com') AS updated_email
FROM customer;

-- REGEXP contains pattern, Shows film titles containing LOVE or LIFE
SELECT title
FROM film
WHERE title REGEXP 'LOVE|LIFE';
-- WHERE first_name REGEXP '^[A-C]'; -- Shows actor first names starting with A, B, or C
-- WHERE first_name NOT REGEXP '^A'; -- Shows actors whose first_name does not start with A

-- NOT REGEXP: Used to exclude pattern matching results
-- Shows actors whose first_name does not start with A
SELECT first_name, last_name
FROM actor
WHERE first_name NOT REGEXP '^[aeiouAEIOU]';

-- COUNT with string condition, Counts actors whose first name starts with A
SELECT COUNT(*) AS names_starting_with_A
FROM actor
WHERE first_name LIKE 'A%';

-- -----------------------------------------------------------------
-- STRING FUNCTIONS COMBINED EXAMPLE
SELECT first_name,
       last_name,
       CONCAT(UPPER(LEFT(first_name, 1)),
              LOWER(SUBSTRING(first_name, 2)),
              ' ',
              UPPER(last_name)) AS formatted_full_name
FROM actor;
-- LEFT gets first letter
-- UPPER converts first letter to capital
-- SUBSTRING gets remaining letters
-- LOWER converts remaining letters to lowercase
-- CONCAT joins first name and last name

-- Displays multiple string operations on film title
SELECT title,
       LENGTH(title) AS title_length,
       LEFT(title, 5) AS first_5_chars,
       RIGHT(title, 5) AS last_5_chars,
       REVERSE(title) AS reversed_title,
       UPPER(title) AS uppercase_title
FROM film
LIMIT 10;
-- -----------------------------------------------------------------



