
-- 21-05-2026 MATH AND DATE TIME

USE sakila;

# math operations

-- Square of rental_duration from film table
SELECT title, rental_duration, POWER(rental_duration, 2) AS duration_square FROM film LIMIT 5;

-- 3. AVG(): AVG means average, Average payment amount from all customers
SELECT AVG(amount) AS average_payment FROM payment;

-- MOD(): MOD gives remainder after division, Find payment IDs that are even numbers
SELECT payment_id,amount FROM payment WHERE MOD(payment_id, 2) = 0 LIMIT 10;

-- CEIL(): CEIL rounds number UP, Example using payment amount
SELECT payment_id, amount, CEIL(amount) AS rounded_up_amount FROM payment LIMIT 10;

-- FLOOR(): FLOOR rounds number DOWN, Example using payment amount
SELECT payment_id, amount, FLOOR(amount) AS rounded_down_amount FROM payment LIMIT 10;

-- ROUND(): ROUND rounds the number normally, Example using film replacement cost
SELECT film_id, title, replacement_cost, ROUND(replacement_cost, 1) AS rounded_cost
FROM film LIMIT 10;

-- MIN() and MAX(), MIN gives smallest value, MAX gives highest value, Lowest and highest film replacement cost
SELECT
    MIN(replacement_cost) AS lowest_cost,
    MAX(replacement_cost) AS highest_cost
FROM film;

-- SUM() and COUNT(): SUM adds values, COUNT counts rows
SELECT COUNT(*) AS total_payments, SUM(amount) AS total_amount_collected, AVG(amount) AS average_amount
FROM payment;

-- GROUP BY with math functions: GROUP BY is used to summarize data category-wise, Total amount paid by each customer
SELECT
    customer_id,
    COUNT(*) AS total_payments,
    SUM(amount) AS total_paid,
    AVG(amount) AS average_payment,
    MAX(amount) AS highest_payment
FROM payment
GROUP BY customer_id
LIMIT 10;

-- Top 10 customers who paid the highest total amount
SELECT customer_id, SUM(amount) AS total_paid FROM payment
GROUP BY customer_id
ORDER BY total_paid DESC
LIMIT 10;


-- =========================================================
-- DATE AND TIME BASICS
-- =========================================================

-- NOW() gives current date and time
SELECT NOW() AS current_date_time;

-- DATE columns in Sakila, payment_date is available in payment table, rental_date and return_date are available in rental table
SELECT payment_id, customer_id, amount,payment_date FROM payment LIMIT 10;

-- Extract DATE from DATETIME, DATE() removes time and keeps only date
SELECT payment_id, payment_date, DATE(payment_date) AS only_payment_date FROM payment LIMIT 10;

-- DATE_ADD(): DATE_ADD adds days/months/years to a date
SELECT
    NOW() AS today_time,
    DATE_ADD(NOW(), INTERVAL 7 DAY) AS after_7_days,
    DATE_ADD(NOW(), INTERVAL 1 MONTH) AS after_1_month,
    DATE_ADD(NOW(), INTERVAL 1 YEAR) AS after_1_year;
    
-- If payment date is given, show payment date + 7 days
SELECT payment_id, payment_date, DATE_ADD(payment_date, INTERVAL 7 DAY) AS payment_plus_7_days
FROM payment LIMIT 10;

-- DATE_SUB(): DATE_SUB subtracts days/months/years from a date
SELECT
    NOW() AS today_time,
    DATE_SUB(NOW(), INTERVAL 7 DAY) AS before_7_days,
    DATE_SUB(NOW(), INTERVAL 1 MONTH) AS before_1_month;
    
-- DATEDIFF(): DATEDIFF gives difference between two dates
SELECT rental_id, rental_date, return_date, DATEDIFF(return_date, rental_date) AS rented_days
FROM rental WHERE return_date IS NOT NULL LIMIT 10;

-- DATE_FORMAT(): DATE_FORMAT changes how date is displayed
SELECT payment_id, payment_date,
    DATE_FORMAT(payment_date, '%Y-%m-%d') AS format_yyyy_mm_dd,
    DATE_FORMAT(payment_date, '%d-%m-%Y') AS format_dd_mm_yyyy,
    DATE_FORMAT(payment_date, '%M %d, %Y') AS readable_date,
    DATE_FORMAT(payment_date, '%W') AS day_name,
    DATE_FORMAT(payment_date, '%M') AS month_name
FROM payment LIMIT 10;

-- Common DATE_FORMAT symbols:
-- %Y = 4 digit year
-- %y = 2 digit year
-- %m = month number
-- %M = full month name
-- %d = day number
-- %W = full weekday name
-- %H = hour
-- %i = minutes
-- %s = seconds

-- GROUP BY date: Total payment collected per day
SELECT
    DATE(payment_date) AS payment_day,
    COUNT(*) AS total_payments,
    SUM(amount) AS total_amount
FROM payment GROUP BY DATE(payment_date) ORDER BY payment_day;

-- Latest payment by each customer
SELECT customer_id, MAX(payment_date) AS latest_payment_date
FROM payment GROUP BY customer_id ORDER BY latest_payment_date DESC LIMIT 10;

-- 30. Average rental duration
SELECT
    AVG(DATEDIFF(return_date, rental_date)) AS average_rental_days
FROM rental WHERE return_date IS NOT NULL;

-- DATE + GROUP BY + ORDER BY, Find daily revenue from payment table
SELECT
    DATE(payment_date) AS payment_date,
    COUNT(payment_id) AS total_transactions,
    SUM(amount) AS daily_revenue,
    ROUND(AVG(amount), 2) AS average_payment
FROM payment
GROUP BY DATE(payment_date)
ORDER BY daily_revenue DESC;

-- Filtering using date, Payments after a specific date
SELECT payment_id, customer_id, amount, payment_date
FROM payment WHERE payment_date > '2005-07-01'
ORDER BY payment_date LIMIT 10;

-- CASE with date logic, Create custom rental status
SELECT
    rental_id,
    rental_date,
    return_date,
    CASE
        WHEN return_date IS NULL THEN 'Not Returned'
        WHEN DATEDIFF(return_date, rental_date) <= 3 THEN 'Quick Return'
        WHEN DATEDIFF(return_date, rental_date) BETWEEN 4 AND 7 THEN 'Normal Return'
        ELSE 'Late Return'
    END AS rental_status
FROM rental
LIMIT 20;

-- Final combined practice query, Customer payment summary with math and date functions
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(p.payment_id) AS total_transactions,
    SUM(p.amount) AS total_paid,
    ROUND(AVG(p.amount), 2) AS average_payment,
    CEIL(MAX(p.amount)) AS highest_payment_rounded_up,
    FLOOR(MIN(p.amount)) AS lowest_payment_rounded_down,
    MIN(p.payment_date) AS first_payment_date,
    MAX(p.payment_date) AS latest_payment_date,
    DATEDIFF(MAX(p.payment_date), MIN(p.payment_date)) AS days_between_first_and_last_payment
FROM customer c
JOIN payment p
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_paid DESC
LIMIT 10;











