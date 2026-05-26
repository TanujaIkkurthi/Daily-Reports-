-- ASSIGNMENT_2 
USE sakila;

-- 1. Identify if there are duplicates in Customer table. Don't use customer id to check the duplicates
SELECT first_name, last_name, email, COUNT(*) AS duplicate_count
FROM customer
GROUP BY first_name, last_name, email
HAVING COUNT(*) > 1;
# result is empty, it means there are no duplicate customers. based on first_name, last_name, and email.

-- 2. Number of times letter 'a' is repeated in film descriptions
SELECT film_id, title, description,
    LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'a', '')) AS count_of_a
FROM film;
# we first convert all letters into lower case, then count the total length. now we replace the letter a with nothing, 
# then calculate the length of new string and subtract it from the length of original

-- 3. Number of times each vowel is repeated in film descriptions 
SELECT
    film_id,
    title,
    LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'a', '')) AS a_count,
    LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'e', '')) AS e_count,
    LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'i', '')) AS i_count,
    LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'o', '')) AS o_count,
    LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'u', '')) AS u_count
FROM film;

-- 4. Display the payments made by each customer
-- 4.1 Month-wise payments made by each customer
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    YEAR(p.payment_date) AS payment_year,
    MONTH(p.payment_date) AS payment_month_number,
    MONTHNAME(p.payment_date) AS payment_month,
    SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    YEAR(p.payment_date),
    MONTH(p.payment_date),
    MONTHNAME(p.payment_date)
ORDER BY
    c.customer_id,
    payment_year,
    payment_month_number;
    

-- 4.2 Year-wise payments made by each customer
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    YEAR(p.payment_date) AS payment_year,
    SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    YEAR(p.payment_date)
ORDER BY
    c.customer_id,
    payment_year;
    
-- 4.3 Week-wise payments made by each customer
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    YEAR(p.payment_date) AS payment_year,
    WEEK(p.payment_date) AS payment_week,
    SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    YEAR(p.payment_date),
    WEEK(p.payment_date)
ORDER BY
    c.customer_id,
    payment_year,
    payment_week;

-- 5. Check if any given year is a leap year or not. You need not consider any table from sakila database. 
-- Write within the select query with hardcoded date
SELECT
    2024 AS given_year,
    CASE
        WHEN (2024 % 400 = 0)
          OR (2024 % 4 = 0 AND 2024 % 100 <> 0)
        THEN 'Leap Year'
        ELSE 'Not a Leap Year'
    END AS result;
    
-- 6. Display number of days remaining in the current year from today.
SELECT
    CURDATE() AS today_date,
    CONCAT(YEAR(CURDATE()), '-12-31') AS year_end_date,
    DATEDIFF(CONCAT(YEAR(CURDATE()), '-12-31'), CURDATE()) AS days_remaining;

-- 7. Display quarter number(Q1,Q2,Q3,Q4) for the payment dates from payment table. 
SELECT
    payment_id,
    customer_id,
    payment_date,
    CONCAT('Q', QUARTER(payment_date)) AS quarter_number,
    amount
FROM payment
ORDER BY payment_date;

-- 8. Display the age in year, months, days based on your date of birth. 
-- For example: 21 years, 4 months, 12 days
SELECT
    '2000-08-09' AS date_of_birth,

    TIMESTAMPDIFF(YEAR, '2000-08-09', CURDATE()) AS years,

    TIMESTAMPDIFF(MONTH, '2000-08-09', CURDATE()) % 12 AS months,

    DATEDIFF(
        CURDATE(),
        DATE_ADD(
            '2000-08-09',
            INTERVAL TIMESTAMPDIFF(MONTH, '2000-08-09', CURDATE()) MONTH
        )
    ) AS days;





