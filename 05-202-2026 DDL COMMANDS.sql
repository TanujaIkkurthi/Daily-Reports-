-- 20-05-2026 DQL COMMANDS

-- SELECT Used to retrieve data from a table, * means all columns from actor table
SELECT * FROM sakila.actor;

-- DISTINCT: Removes duplicate values, Shows unique actor first names
SELECT DISTINCT first_name FROM sakila.actor;

-- WHERE with NULL: IS NULL is used to find NULL values, Shows films where original_language_id is empty/null
SELECT * FROM sakila.film WHERE original_language_id IS NULL;

-- COUNT(*): Counts total rows in a table, Returns total number of films
SELECT COUNT(*) FROM sakila.film;

-- SELECT all columns from film table, Displays all rows and columns from film table
SELECT * FROM sakila.film;

-- DISTINCT with WHERE, Shows unique film titles where original_language_id is NULL
SELECT DISTINCT title FROM sakila.film WHERE original_language_id IS NULL;

-- COUNT DISTINCT: Counts only unique values, Returns count of unique film titles
SELECT COUNT(DISTINCT(title)) FROM sakila.film;

-- COUNT(column_name): Counts non-null values in a column, Counts total non-null first_name values
SELECT COUNT(first_name) FROM sakila.actor;

-- COUNT DISTINCT on column, Counts unique actor first names
SELECT COUNT(DISTINCT(first_name)) FROM sakila.actor;

-- LIMIT: Used to restrict the number of rows returned, Shows only first 10 actors
SELECT * FROM actor LIMIT 10;

-- LIMIT with selected columns, Shows only 5 actor names
SELECT first_name, last_name FROM actor LIMIT 5;

-- WHERE: Used to filter rows based on a condition, Shows only films with PG rating
SELECT * FROM film WHERE rating = 'PG';

-- WHERE with numeric condition, Shows films where rental rate is greater than 2.99
SELECT title, rental_rate FROM film WHERE rental_rate > 2.99;

-- ORDER BY: Used to sort the output, Sorts films by rental_rate in ascending order
SELECT title, rental_rate FROM film ORDER BY rental_rate;

-- ORDER BY DESC: Used to sort in descending order, Shows highest rental rate first
SELECT title, rental_rate FROM film ORDER BY rental_rate DESC;

-- AND: Both conditions must be true, Shows PG films with rental rate 2.99
SELECT title, rating, rental_rate FROM film WHERE rating = 'PG' AND rental_rate = 2.99;

-- OR: Any one condition can be true, Shows films with rating PG or G
SELECT title, rating FROM film WHERE rating = 'PG' OR rating = 'G';

-- AND + OR together: Use brackets to avoid confusion, Shows PG or G movies with rental rate 2.99
SELECT title, rating, rental_rate FROM film WHERE (rating = 'PG' OR rating = 'G') AND rental_rate = 2.99;

-- NOT: Used to exclude a condition, Shows films that are not PG
SELECT title, rating FROM film WHERE NOT rating = 'PG';

-- NOT IN: Excludes multiple values, Shows films excluding PG and G ratings
SELECT title, rating FROM film WHERE rating NOT IN ('PG', 'G');

-- LIKE with %: means any number of characters
-- Shows actors whose first name starts with A
SELECT first_name, last_name FROM actor WHERE first_name LIKE 'A%';
-- Shows actors whose first name ends with A
SELECT first_name, last_name FROM actor WHERE first_name LIKE '%A';

-- LIKE with _ means exactly one character, Shows actors whose second letter is A
SELECT first_name, last_name FROM actor WHERE first_name LIKE '_A%';

-- NULL value: Use IS NULL, do not use X = NULL, Shows films where original_language_id is NULL
SELECT title, original_language_id FROM film WHERE original_language_id IS NULL;

-- IS NOT NULL, Shows addresses where address2 has some value
SELECT address, address2 FROM address WHERE address2 IS NOT NULL;

-- BETWEEN: Used to filter values within a range, Includes both starting and ending values
-- Shows films with rental duration from 3 to 5
SELECT title, rental_duration FROM film WHERE rental_duration BETWEEN 3 AND 5;

-- BETWEEN with amount, Shows films with replacement cost between 10.99 and 20.99
SELECT title, replacement_cost 
FROM film 
WHERE replacement_cost 
BETWEEN 10.99 AND 20.99;

-- GROUP BY: Used to group similar values, Shows number of films for each rating
SELECT rating, COUNT(*) AS total_films 
FROM film 
GROUP BY rating;

-- HAVING: Used to filter grouped results, Shows only ratings having more than 200 films
SELECT rating, COUNT(*) AS total_films
FROM film
GROUP BY rating
HAVING COUNT(*) > 200;

-- GROUP BY + HAVING + ORDER BY, Groups films by rating
-- Filters only groups having count more than 150, Sorts highest count first
SELECT rating, COUNT(*) AS total_films
FROM film
GROUP BY rating
HAVING COUNT(*) > 150
ORDER BY total_films DESC;

-- ORDER BY COUNT: Sorting grouped result based on count, Shows ratings with highest number of films first
SELECT rating, COUNT(*) AS total_films
FROM film
GROUP BY rating
ORDER BY COUNT(*) DESC;

-- ORDER BY COUNT using alias, Same as above, but using alias name
SELECT rating, COUNT(*) AS total_films
FROM film
GROUP BY rating
ORDER BY total_films DESC;

-- Primary example: Count films by rating and sort by count, This is a common GROUP BY + COUNT + ORDER BY example
SELECT rating, COUNT(*) AS film_count
FROM film
GROUP BY rating
ORDER BY film_count DESC;

-- WHERE vs HAVING 
-- WHERE filters rows before grouping
-- HAVING filters groups after grouping
SELECT rating, COUNT(*) AS total_films
FROM film
WHERE rental_rate > 2.99
GROUP BY rating
HAVING COUNT(*) > 50;

-- SQL order of execution, This is the actual backend execution order
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT

