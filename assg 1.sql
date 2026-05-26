USE sakila;

-- 1. Customers with first name starting with 'J' and active
SELECT * FROM customer
WHERE first_name LIKE 'J%'
AND active = 1;

-- 2. Films where title contains 'ACTION' or description contains 'WAR'

 SELECT * FROM film
WHERE title LIKE '%ACTION%'
OR description LIKE '%WAR%';

-- 3. Customers whose last name is not 'SMITH' and first name ends with 'a'

SELECT * FROM customer
WHERE last_name != 'SMITH'
AND first_name LIKE '%a';

-- 4. Films where rental rate > 3.0 and replacement cost is not null

SELECT * FROM film
WHERE rental_rate > 3.0
AND replacement_cost IS NOT NULL;

-- 5. Count of active customers per store

SELECT store_id, COUNT(*) AS active_customer_count
FROM customer
WHERE active = 1
GROUP BY store_id;

-- 6. Distinct film ratings

SELECT DISTINCT rating
FROM film;

-- 7. Number of films per rental duration where average length > 100 minutes

SELECT rental_duration, COUNT(*) AS film_count
FROM film
GROUP BY rental_duration
HAVING AVG(length) > 100;

-- 8. Payment dates and total amount where more than 100 payments were made

SELECT DATE(payment_date) AS payment_date,
       SUM(amount) AS total_amount
FROM payment
GROUP BY DATE(payment_date)
HAVING COUNT(*) > 100;

-- 9. Customers whose email is null or ends with '.org'

SELECT * FROM customer
WHERE email IS NULL
OR email LIKE '%.org';

-- 10. Films with rating 'PG' or 'G', ordered by rental rate descending

SELECT * FROM film
WHERE rating IN ('PG', 'G')
ORDER BY rental_rate DESC;

-- 11. Film count per length where title starts with 'T' and count > 5

SELECT length, COUNT(*) AS film_count
FROM film
WHERE title LIKE 'T%'
GROUP BY length
HAVING COUNT(*) > 5;

-- 12. Actors who have appeared in more than 10 films

SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10;

-- 13. Top 5 films with highest rental rate and longest length

SELECT title, rental_rate, length
FROM film
ORDER BY rental_rate DESC, length DESC
LIMIT 5;

-- 14. All customers with total rentals, ordered from most to least

SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(r.rental_id) AS total_rentals
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_rentals DESC;

-- 15. Film titles that have never been rented

SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;