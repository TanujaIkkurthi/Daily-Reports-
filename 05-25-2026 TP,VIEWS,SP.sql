-- 05-25-2026 
-- TEMPORARY TABLES:
-- Temporary tables are short-lived tables that exist only for the duration of a session or transaction — 
-- they're automatically dropped when the session ends. They're useful for storing intermediate results, 
-- breaking complex queries into steps, or improving performance by avoiding repeated subquery execution.
-- Step 1: Store the qualifying customers in a temp table
USE SAKILA;
-- Drop if exists
DROP TEMPORARY TABLE IF EXISTS temp_customers;
-- Create again
CREATE TEMPORARY TABLE temp_customers AS
SELECT customer_id, first_name, last_name
FROM customer
LIMIT 10;
-- Query it
SELECT * FROM temp_customers;

-- VIEWS:
-- Views are saved SQL queries stored in the database as virtual tables — 
-- they don't store data themselves, just the query definition. You can query a view just like a real table,
--  making complex queries reusable and simpler to call.They're great for hiding complexity, restricting data access, 
-- and keeping your queries clean.
-- Drop if exists
DROP VIEW IF EXISTS active_customer_view;
-- Step 1: Create a View
CREATE VIEW active_customer_view AS
SELECT customer_id, first_name, last_name, email
FROM customer
WHERE active = 1;
-- Step 2: Query the View
SELECT * FROM active_customer_view;


-- STORED PROCEDURES:
-- Stored Procedures in SQL.A stored procedure is a saved block of SQL code
--  that you can reuse by just calling its name — like a function in programming.
-- SIMPLE PARAMETER
DROP PROCEDURE IF EXISTS get_all_customers;

DELIMITER $$
CREATE PROCEDURE get_all_customers()
BEGIN
    SELECT customer_id, first_name, last_name FROM customer LIMIT 10;
END $$
DELIMITER ;

-- Call it
CALL get_all_customers();
-- INPUT PARAMETER:
DROP PROCEDURE IF EXISTS get_customer_by_id;

DELIMITER $$
CREATE PROCEDURE get_customer_by_id(IN cust_id INT)
BEGIN
    SELECT customer_id, first_name, last_name FROM customer WHERE customer_id = cust_id;
END $$
DELIMITER ;

-- Call it
CALL get_customer_by_id(5);
-- OUTPUT PARAMETER
DROP PROCEDURE IF EXISTS count_active_customers;

DELIMITER $$
CREATE PROCEDURE count_active_customers(OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total FROM customer WHERE active = 1;
END $$
DELIMITER ;

-- Call it
CALL count_active_customers(@total);
SELECT @total;
-- INOUT PARAMETER:
DROP PROCEDURE IF EXISTS double_the_value;

DELIMITER $$
CREATE PROCEDURE double_the_value(INOUT num INT)
BEGIN
    SET num = num * 2;
END $$
DELIMITER ;

-- Call it
SET @val = 10;
CALL double_the_value(@val);
SELECT @val;  -- Returns 20
-- Dynamic SQL in Stored Procedures
-- Dynamic SQL is SQL that is built and executed at runtime — meaning the query is constructed as a string and then executed. 
-- Used when table names, columns, or conditions are not known until runtime.
-- Key statements:

-- PREPARE — prepares the SQL string
-- EXECUTE — runs it
-- DEALLOCATE PREPARE — cleans it up
DROP PROCEDURE IF EXISTS dynamic_basic;

DELIMITER $$
CREATE PROCEDURE dynamic_basic()
BEGIN
    SET @sql = 'SELECT customer_id, first_name, last_name FROM customer LIMIT 5';
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END $$
DELIMITER ;

-- Call it
CALL dynamic_basic();

