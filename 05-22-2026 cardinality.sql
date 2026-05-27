-- 22-05-2026 CARDINALITY, JOINS

USE sakila;

-- CARDINALITY: How many rows of one table can be related to rows of another table.

-- In simple words: One user can have many orders, One order can have many products, One user can have one profile
-- That connection count between tables is called cardinality.

-- Cardinality helps us: Design proper databases, Avoid duplicate data
-- Understand table relationships,Write correct JOIN queries

-- 4 Types of Relationships (Cardinality)
-- 1:1		One row related to one row : One record in Table A can connect to only one record in Table B.
-- 1:Many	One row related to many rows : One row in first table can connect to many rows in second table.
-- Many:1	Many rows related to one row : Many rows from first table connect to one row in second table. This is actually opposite view of 1:Many.
-- M:M		Many rows related to many rows : Many rows from first table connect to many rows in second table.This usually needs a bridge table (junction table).

-- ------------------------------------------------------------------------------------
-- JOINS: Combine data from multiple tables using a related column.
-- Usually: PRIMARY KEY from one table joins with FOREIGN KEY from another table.
-- ------------------------------------------------------------------------------------

-- 1. INNER JOIN : Returns only matching rows from both tables. If data does not match, SQL ignores that row.
-- Show customers who actually rented movies
SELECT
    c.customer_id,
    c.first_name,
    r.rental_id
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id;
-- customer table contains customers, rental table contains movie rentals
-- c.customer_id = r.customer_id, Only matching customers appear.

-- Show movie titles with language names
SELECT
    f.title,
    l.name AS language_name
FROM film f
INNER JOIN language l
ON f.language_id = l.language_id;

-- 2. LEFT JOIN : Returns ALL rows from left table, even if no match exists in right table. Non-matching rows become NULL.
-- Show all customers, even customers without rentals
SELECT
    c.customer_id,
    c.first_name,
    r.rental_id
FROM customer c
LEFT JOIN rental r
ON c.customer_id = r.customer_id;
-- Every customer appears. If customer has no rental: rental_id becomes NULL.

-- Show all actors and films if available
SELECT
    a.actor_id,
    a.first_name,
    f.title
FROM actor a
LEFT JOIN film_actor fa
ON a.actor_id = fa.actor_id
LEFT JOIN film f
ON fa.film_id = f.film_id;

# unmatched
-- Find customers with NO rentals
SELECT
    c.customer_id,
    c.first_name
FROM customer c
LEFT JOIN rental r
ON c.customer_id = r.customer_id
WHERE r.rental_id IS NULL;

-- WRONG:
-- Filtering wrongly after LEFT JOIN. This condition removes NULL rows. So LEFT JOIN behaves like INNER JOIN.
SELECT *
FROM customer c
LEFT JOIN rental r
ON c.customer_id = r.customer_id
WHERE r.customer_id = 1;

-- 3. RIGHT JOIN : Returns ALL rows from right table, even if no match exists in left table.
-- Example 1 : Show all rentals, even if customer data is missing
SELECT
    c.first_name,
    r.rental_id
FROM customer c
RIGHT JOIN rental r
ON c.customer_id = r.customer_id;

-- WRONG: unrelated join columns, store_id and customer_id are unrelated.
SELECT *
FROM customer c
RIGHT JOIN payment p
ON c.store_id = p.customer_id;

-- 4. FULL OUTER JOIN : Returns matching rows, left unmatched rows, right unmatched rows, Everything from both tables.
-- NOTE: MySQL does NOT support FULL JOIN directly. We simulate it using: LEFT JOIN UNION RIGHT JOIN

SELECT
    c.customer_id,
    r.rental_id
FROM customer c
LEFT JOIN rental r
ON c.customer_id = r.customer_id
UNION
SELECT
    c.customer_id,
    r.rental_id
FROM customer c
RIGHT JOIN rental r
ON c.customer_id = r.customer_id;

-- LEFT JOIN alone cannot show: rentals that have no customer
-- RIGHT JOIN alone cannot show: customers that have no rentals. We combine BOTH results. That is what UNION is doing.

-- THIS WILL FAIL IN MYSQL
-- All from both tables
SELECT c.first_name, r.rental_date
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
UNION
SELECT c.first_name, r.rental_date
FROM customer c
RIGHT JOIN rental r ON c.customer_id = r.customer_id;

-- 5. LEFT JOIN EXCLUDING INNER JOIN : Show only rows from the left table that do not have a match in the right table.
-- Shows films that do NOT have inventory copies.
-- These films exist in film table but not in inventory table.
SELECT
    f.film_id,
    f.title,
    i.inventory_id
FROM film f
LEFT JOIN inventory i
ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL;

-- 6. RIGHT JOIN EXCLUDING INNER JOIN : Show only rows from the right table that do not have a match in the left table.
-- Inventory Records Without Matching Film. Shows inventory rows that do not have matching film records.
-- Usually this may return empty because Sakila has proper foreign keys.
SELECT
    f.film_id,
    f.title,
    i.inventory_id
FROM film f
RIGHT JOIN inventory i
ON f.film_id = i.film_id
WHERE f.film_id IS NULL;

-- 7. FULL OUTER JOIN EXCLUDING INNER JOIN : Show only unmatched rows from both tables.
-- Since MySQL does not support FULL OUTER JOIN directly, we use:
-- LEFT JOIN excluding INNER JOIN  UNION  RIGHT JOIN excluding INNER JOIN

-- Film and Inventory Unmatched Rows. 
-- 1. Films without inventory
-- 2. Inventory rows without matching film
-- It removes matching rows.
SELECT
    f.film_id,
    f.title,
    i.inventory_id
FROM film f
LEFT JOIN inventory i
ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL
UNION
SELECT
    f.film_id,
    f.title,
    i.inventory_id
FROM film f
RIGHT JOIN inventory i
ON f.film_id = i.film_id
WHERE f.film_id IS NULL;

-- 8. CROSS JOIN : Returns every possible combination., no condition needed
-- Every customer with every store
SELECT
    c.first_name,
    s.store_id
FROM customer c
CROSS JOIN store s;
-- If: 100 customers, 2 stores, Result: 100 × 2 = 200 rows
-- NOTE : some cross joins leads to Huge combinations. unnecessary data. 

-- 9. SELF JOIN : means joining a table with itself.
-- Finds pairs of customers who belong to the same store.
-- c1 and c2 are both customer table, but used like two separate copies.
-- When the same table is used twice, SQL needs aliases. they help SQL understand which copy of the table you are referring to.
SELECT
    c1.customer_id AS customer_1_id,
    c1.first_name AS customer_1_name,
    c2.customer_id AS customer_2_id,
    c2.first_name AS customer_2_name,
    c1.store_id
FROM customer c1
INNER JOIN customer c2
ON c1.store_id = c2.store_id
WHERE c1.customer_id <> c2.customer_id;



-- Final Quick Revision Table
-- 	"Join Type"												"Simple Meaning"
-- 	INNER JOIN										Only matching rows
-- 	LEFT JOIN										All left rows + matching right rows
-- 	RIGHT JOIN										All right rows + matching left rows
-- 	FULL OUTER JOIN									Everything from both tables
-- 	LEFT JOIN EXCLUDING INNER JOIN					Only left-side unmatched rows
-- 	RIGHT JOIN EXCLUDING INNER JOIN					Only right-side unmatched rows
-- 	FULL OUTER JOIN EXCLUDING INNER JOIN			Only unmatched rows from both sides
-- 	CROSS JOIN										Every possible combination
-- 	SELF JOIN										Same table joined with itself









