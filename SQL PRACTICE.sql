USE Sakila;
-- EXAMPLE FOR SQL
-- Top 10 rented movies
SELECT title, rental_rate FROM film 
ORDER BY rental_rate DESC LIMIT 10;

-- How many films are in each category
SELECT c.name, COUNT(*) as total
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;

-- DBMS VS RDBMS:

-- DBMS Style Query
-- No relationships — fetch data from ONE table only
-- Just get data from single table, no connection
SELECT * FROM customer;

SELECT first_name, last_name FROM customer;

SELECT * FROM film;
-- RDBMS Style Query
-- With relationships — connect MULTIPLE tables
-- Connect 3 tables: customer + rental + film
SELECT customer.first_name, film.title, rental.rental_date
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id;
-- TABLES,ROWS,COLUMNS
SELECT customer.first_name, customer.last_name, film.title, rental.rental_date
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
LIMIT 5;
-- SCHEMAS AND DATABASES
SELECT 
    TABLE_SCHEMA AS database_name,
    TABLE_NAME AS table_name,
    TABLE_ROWS AS total_rows
FROM information_schema.tables
WHERE TABLE_SCHEMA = 'sakila';
-- SQL SYNTAX RULES:
SELECT DISTINCT                             -- RULE 15
    customer.first_name  AS name,           -- RULE 6,14
    customer.last_name   AS lastname,       -- RULE 6,14
    film.title           AS movie,          -- RULE 6,14
    film.rental_rate     AS price,          -- RULE 6,14
    rental.rental_date   AS rented_on       -- RULE 6,14
FROM customer                               -- RULE 3 (FROM)
JOIN rental                                 -- RULE 3 (JOIN)
ON customer.customer_id = rental.customer_id
JOIN inventory                              -- RULE 3 (JOIN)
ON rental.inventory_id = inventory.inventory_id
JOIN film                                   -- RULE 3 (JOIN)
ON inventory.film_id = film.film_id
WHERE customer.active = 1                   -- RULE 3,5 (WHERE)
AND customer.first_name LIKE 'M%'           -- RULE 10,11
AND film.rental_rate BETWEEN 2.99 AND 4.99  -- RULE 13
AND film.rating IN ('PG', 'PG-13')          -- RULE 12
AND customer.email IS NOT NULL              -- RULE 9
ORDER BY rental.rental_date DESC            -- RULE 3 (ORDER BY)
LIMIT 5;                                    -- RULE 3,2 (LIMIT + ;)

-- SQL KEYWORDS AND IDENTIFIERS:
--      KEYWORDS          IDENTIFIERS
--      --------          -----------
SELECT DISTINCT                             
    customer.first_name  AS name,           
    customer.last_name   AS lastname,       
    film.title           AS movie,          
    film.rental_rate     AS price,          
    COUNT(*) AS total_rentals               
FROM customer                               
JOIN rental                                 
ON customer.customer_id = rental.customer_id
JOIN inventory                              
ON rental.inventory_id = inventory.inventory_id
JOIN film                                  
ON inventory.film_id = film.film_id        
WHERE customer.active = 1                   
AND film.rental_rate BETWEEN 2.99 AND 4.99  
AND film.rating IN ('PG', 'PG-13')          
AND customer.email IS NOT NULL              
GROUP BY customer.first_name,              
         customer.last_name,               
         film.title,                       
         film.rental_rate                  
HAVING COUNT(*) > 1                        
ORDER BY total_rentals DESC                
LIMIT 5;
-- CREATING A DATA BASE
SELECT
    customer.first_name  AS customer,
    film.title           AS movie,
    film.rental_rate     AS price,
    film.rating          AS rating,
    rental.rental_date   AS rented_on
FROM customer
JOIN rental  ON customer.customer_id = rental.customer_id
JOIN film    ON rental.film_id       = film.film_id
WHERE customer.is_active = 1
ORDER BY rental.rental_date;
