-- 22-05-2026 | CTE

-- ------------------------------------------------------------------------------------------------------------
-- CTE — Common Table Expression : A CTE is a temporary result table that you create inside a query.
-- A CTE lets you write a small query first, give it a name, and then use that named result in the main query.
-- ------------------------------------------------------------------------------------------------------------

-- Why do we use CTE? : We use CTE to make SQL easier to read.
-- Instead of writing one big confusing query, we break it into small steps.
-- CTE is useful when:
		-- query is becoming long
		-- same logic is needed before final result
		-- we want to filter after grouping
		-- we want to make query readable
		-- we want to use aggregated results in another query


-- Basic CTE structure
WITH cte_name AS (
    -- Step 1: Write a query and give it a name
    SELECT
        column1,
        column2
    FROM table_name
)
-- Step 2: Use that named result like a table
SELECT
    *
FROM cte_name;

-- --------------------------------------------------------------
-- Example: Find total payment made by each customer
-- --------------------------------------------------------------
WITH customer_total_payment AS (
    -- This CTE calculates total payment per customer
    SELECT
        customer_id,
        SUM(amount) AS total_amount
    FROM payment
    GROUP BY customer_id
)
-- Main query uses the CTE result
SELECT
    customer_id,
    total_amount
FROM customer_total_payment;

-- Explanation: The CTE creates a temporary result like this:
-- customer_id	 total_amount
-- 		1			118.68
-- 		2			128.73
-- Then the main query reads from that result.

-- --------------------------------------------------------------
-- Example: Categories with Number of Films. Find how many films are in each category.
-- Count films in each category
-- --------------------------------------------------------------

WITH category_film_count AS (
    -- Count films for each category
    SELECT
        category_id,
        COUNT(film_id) AS total_films
    FROM film_category
    GROUP BY category_id
)
SELECT
    c.category_id,
    c.name AS category_name,
    cfc.total_films
FROM category c
INNER JOIN category_film_count cfc
ON c.category_id = cfc.category_id
ORDER BY cfc.total_films DESC;

-- film_category is also a bridge table. It connects: film, category
-- CTE counts films per category. Main query gets category names.

-- --------------------------------------------------------------
-- Multiple CTEs Together: Find customer total payment and total rental count together.
-- Multiple CTEs in one query
-- --------------------------------------------------------------

WITH customer_payment_total AS (
    -- First CTE: total amount paid by each customer
    SELECT
        customer_id,
        SUM(amount) AS total_paid
    FROM payment
    GROUP BY customer_id
),

customer_rental_total AS (
    -- Second CTE: total rentals by each customer
    SELECT
        customer_id,
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    cpt.total_paid,
    crt.total_rentals
FROM customer c
INNER JOIN customer_payment_total cpt
ON c.customer_id = cpt.customer_id
INNER JOIN customer_rental_total crt
ON c.customer_id = crt.customer_id
ORDER BY cpt.total_paid DESC;

-- Here we created two temporary results: customer_payment_total, customer_rental_total
-- Then we joined both CTEs with customer.

-- --------------------------------------------------------------------------------------------------
-- Recursive CTE: A recursive CTE is a CTE that calls itself again and again until a condition stops it.
-- --------------------------------------------------------------------------------------------------
WITH RECURSIVE cte_name AS (
    
    -- 1. Anchor query: This is the starting point
    SELECT *

    UNION ALL

    -- 2. Recursive query: This repeats again and again
    SELECT *
    FROM cte_name
    WHERE stop_condition # This prevents infinite loop.
)

SELECT *
FROM cte_name;


-- Generate Daily Revenue Dates and Match Payments
-- Generate a sequence of dates using Recursive CTE and show total payment amount for each day.

WITH RECURSIVE date_list AS (

    -- Anchor Query
    -- Start from the minimum payment date in payment table
    SELECT MIN(DATE(payment_date)) AS payment_day
    FROM payment

    UNION ALL

    -- Recursive Query
    -- Add 1 day each time
    SELECT DATE_ADD(payment_day, INTERVAL 1 DAY)
    FROM date_list

    -- Stop Condition
    -- Stop when maximum payment date is reached
    WHERE payment_day < (
        SELECT MAX(DATE(payment_date))
        FROM payment
    )
),

daily_payments AS (

    -- Calculate total payment amount per day
    SELECT
        DATE(payment_date) AS payment_day,
        SUM(amount) AS total_amount
    FROM payment
    GROUP BY DATE(payment_date)
)
WITH daily_payments AS (
    -- Calculate total payment amount per day
    SELECT
        DATE(payment_date) AS payment_day,
        SUM(amount)        AS total_amount
    FROM payment
    GROUP BY DATE(payment_date)
)
SELECT *
FROM daily_payments;
-- Final Query
-- Join generated dates with payment totals
SELECT
    dl.payment_day,
    COALESCE(dp.total_amount, 0) AS total_amount
FROM date_list dl

LEFT JOIN daily_payments dp
ON dl.payment_day = dp.payment_day

ORDER BY dl.payment_day;








