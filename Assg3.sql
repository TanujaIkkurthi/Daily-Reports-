

-- 1. display all customer details who have made more than 5 payments.
SELECT *
FROM customer
WHERE customer_id IN
(
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    HAVING COUNT(payment_id) > 5
);
-- Inner query: counts payments for each customer
-- Outer query: displays full customer details for those customers

-- 2. Find the names of actors who have acted in more than 10 films.
SELECT
    first_name,
    last_name
FROM actor
WHERE actor_id IN
(
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 10
);


-- 3. Find the names of customers who never made a payment.
SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE customer_id NOT IN
(
    SELECT customer_id
    FROM payment
);

-- 4. List all films whose rental rate is higher than the average rental rate of all films.
SELECT
    title,
    rental_rate
FROM film
WHERE rental_rate >
(
    SELECT AVG(rental_rate)
    FROM film
);
-- Subquery calculates: average rental rate
-- Outer query compares each film against that average.

-- 5. List the titles of films that were never rented.
SELECT
    title
FROM film
WHERE film_id NOT IN
(
    SELECT DISTINCT film_id
    FROM inventory
    WHERE inventory_id IN
    (
        SELECT inventory_id
        FROM rental
    )
);

-- 6. Display the customers who rented films in the same month as customer with ID 5.
SELECT DISTINCT customer_id
FROM rental
WHERE MONTH(rental_date) IN
(
    SELECT MONTH(rental_date)
    FROM rental
    WHERE customer_id = 5
)
AND customer_id <> 5;
-- Inner query: finds rental months of customer 5
-- Outer query: finds other customers who rented in those months

-- 7. Find all staff members who handled a payment greater than the average payment amount.
SELECT DISTINCT
    s.staff_id,
    s.first_name,
    s.last_name
FROM staff s
JOIN payment p
ON s.staff_id = p.staff_id
WHERE p.amount >
(
    SELECT AVG(amount)
    FROM payment
);

-- 8. Show the title and rental duration of films whose rental duration is greater than the average.
SELECT
    title,
    rental_duration
FROM film
WHERE rental_duration >
(
    SELECT AVG(rental_duration)
    FROM film
);

-- 9. Find all customers who have the same address as customer with ID 1.
SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE address_id =
(
    SELECT address_id
    FROM customer
    WHERE customer_id = 1
)
AND customer_id <> 1;
-- Subquery finds: address_id of customer 1
-- Outer query: finds all customers with same address
-- There are no customersn who have the address as customer with ID 1.

-- 10. List all payments that are greater than the average of all payments.
SELECT
    payment_id,
    customer_id,
    amount
FROM payment
WHERE amount >
(
    SELECT AVG(amount)
    FROM payment
);







