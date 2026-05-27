-- 21-05-2026 SUBQUERIES

# WHERE clause subquery
-- First, inner query finds the city_id of Aurora
-- Then outer query finds customers whose address belongs to that city_id
SELECT first_name, last_name
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id = (
        SELECT city_id
        FROM city
        WHERE city = 'Aurora'
    )
);

-- Inner query finds average rental_rate from all films
-- Outer query shows films having rental_rate greater than that average
SELECT title, rental_rate
FROM film
WHERE rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
);

-- Inner query calculates average payment amount
-- Outer query returns payments above average
SELECT payment_id, customer_id, amount
FROM payment
WHERE amount > (
    SELECT AVG(amount)
    FROM payment
);

-- ------------------------------------------------------------------------------
# SELECT subqueries - subquery is written inside the SELECT part.
-- ------------------------------------------------------------------------------

-- For each customer, inner query calculates total payment
-- This is useful when you want an extra calculated column
SELECT 
    customer_id,
    first_name,
    last_name,
    (
        SELECT SUM(amount)
        FROM payment
        WHERE payment.customer_id = customer.customer_id
    ) AS total_paid
FROM customer;

-- For each category, inner query counts how many films belong to it
-- film_category is the bridge table
SELECT 
    category_id,
    name,
    (
        SELECT COUNT(*)
        FROM film_category
        WHERE film_category.category_id = category.category_id
    ) AS film_count
FROM category;

-- ------------------------------------------------------------------------------
# DERIVED TABLED : A derived table is a subquery used inside the FROM clause.
# The subquery behaves like a temporary table.
-- ------------------------------------------------------------------------------

-- Find customers whose total payment is greater than 150
-- Inner query creates a temporary table with customer total payment
-- Outer query filters customers who paid more than 150
SELECT *
FROM (
    SELECT 
        customer_id,
        SUM(amount) AS total_paid
    FROM payment
    GROUP BY customer_id
) AS customer_totals
WHERE total_paid > 150;

-- Find categories with more than 60 films
-- Inner query counts films per category
-- Outer query filters categories having film_count greater than 60
SELECT *
FROM (
    SELECT 
        c.name AS category_name,
        COUNT(fc.film_id) AS film_count
    FROM category c
    JOIN film_category fc
        ON c.category_id = fc.category_id
    GROUP BY c.name
) AS category_summary
WHERE film_count > 60;

-- Find average rental duration by rating
-- Inner query groups films by rating
-- Outer query displays only ratings where average rental duration is more than 5
SELECT *
FROM (
    SELECT 
        rating,
        AVG(rental_duration) AS avg_rental_days
    FROM film
    GROUP BY rating
) AS rating_summary
WHERE avg_rental_days > 5;

-- ------------------------------------------------------------------------------
# Correlated Subquery: A correlated subquery depends on the outer query.
# Normal subquery: inner query can run alone.
# Correlated subquery: inner query uses value from outer query.
-- ------------------------------------------------------------------------------

-- Show customers who paid more than average payment of all customers
-- Inner query compares each customer's total payment
-- Outer query checks customer one by one
SELECT 
    customer_id,
    first_name,
    last_name
FROM customer c
WHERE (
    SELECT SUM(amount)
    FROM payment p
    WHERE p.customer_id = c.customer_id
) > (
    SELECT AVG(amount)
    FROM payment
);

-- Show films with more than 5 actors
-- For each film, inner query counts actors from film_actor
-- If actor count is more than 5, film is shown
SELECT 
    film_id,
    title
FROM film f
WHERE (
    SELECT COUNT(*)
    FROM film_actor fa
    WHERE fa.film_id = f.film_id
) > 5;

-- Show actors who acted in more than 20 films
-- Outer query goes actor by actor
-- Inner query counts how many films each actor acted in
SELECT 
    actor_id,
    first_name,
    last_name
FROM actor a
WHERE (
    SELECT COUNT(*)
    FROM film_actor fa
    WHERE fa.actor_id = a.actor_id
) > 20;

# Correlated Subquery with Bridge Table: A bridge table connects two tables.

-- Find films that have actor “NICK WAHLBERG”
-- actor table has actor details
-- film_actor connects actor and film
-- film table has film title
SELECT 
    film_id,
    title
FROM film f
WHERE film_id IN (
    SELECT fa.film_id
    FROM film_actor fa
    WHERE fa.actor_id = (
        SELECT actor_id
        FROM actor
        WHERE first_name = 'NICK'
          AND last_name = 'WAHLBERG'
    )
);

-- Find films in the “Action” category
-- category table has category name
-- film_category connects category and film
-- film table gives title
SELECT 
    film_id,
    title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Action'
    )
);


-- ------------------------------------------------------------------------------
-- When will a Subquery fail ?
-- ------------------------------------------------------------------------------

	-- 1. it returns multiple rows where only one row is expected
-- This subquery returns MANY category_ids
-- But '=' expects only ONE value
SELECT title
FROM film
WHERE film_id = ( # corrected version : WHERE film_id IN (
    SELECT film_id
    FROM film_category 
);
-- this failed because '=' expects one value, but subquery return multiple values
SELECT title
FROM film
WHERE film_id IN (   -- IN instead of =
    SELECT film_id
    FROM film_category
);

	-- 2. it returns multiple columns where one column is expected
SELECT title
FROM film
WHERE film_id = (
    SELECT film_id, category_id
    FROM film_category # use LIMIT 1, to mitigate the error.
);
-- correct way 
SELECT title
FROM film
WHERE film_id = (
    SELECT film_id        -- only 1 column ✅
    FROM film_category
    LIMIT 1               -- only 1 row ✅
);


	-- 3. wrong placement of subquery
SELECT
FROM (
    SELECT *
    FROM actor
);
-- this failed becasue Derived tables MUST have alias names.
-- corrected version is 
-- SELECT *
-- FROM (
--     SELECT *
--     FROM actor
-- ) AS actor_table;

	-- 4. data type mismatch
    
	-- 5. using aggregate incorrectly
SELECT first_name
FROM customer
WHERE SUM(store_id) > 1;
-- SUM() cannot be used directly inside WHERE. Aggregate functions work AFTER grouping.
-- CORRECT WAY
SELECT first_name, SUM(store_id) AS total
FROM customer
GROUP BY first_name
HAVING SUM(store_id) > 1;










