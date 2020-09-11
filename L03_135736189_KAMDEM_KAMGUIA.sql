-- ***********************
-- Name: Stephane Kamdem Kamguia
-- ID: 135736189
-- Date: Monday, 8 June 2020
-- Purpose: Lab 02 DBS311
-- ***********************


-- Q1. Write a SQL query to display the last name and hire date of all employees who were hired before the
-- employee with ID 107 got hired but after March 2016. Sort the result by the hire date and then
-- employee ID.

SELECT
   last_name,
   to_char((hire_date), '[ddTH-fmMonth-yyyy]') AS "hire_date" 
FROM
   employees 
WHERE
   hire_date > '31/03/16'
   AND hire_date < (
   SELECT
      hire_date 
   FROM
      employees 
   WHERE
      employee_id = 107) 
   ORDER BY
      hire_date;

-- Q2. Write a SQL query to display customer name and credit limit for customers with lowest credit limit. 
--    Sort the result by customer ID.

SELECT
   name,
   credit_limit 
FROM
   customers 
WHERE
   credit_limit = ANY (
   SELECT
      MIN(credit_limit) 
   FROM
      customers) 
   ORDER BY
      customer_id;

-- Q3. Write a SQL query to display the product ID, product name, and list price of the highest paid product(s)
--       in each category. Sort by category ID and the product ID.

SELECT
   p.category_id,
   p.product_id,
   p.product_name,
   p.list_price 
FROM
   product_categories l,
   products p 
WHERE
   l.category_id = p.category_id 
   AND p.list_price = 
   (
      SELECT
         MAX(p.list_price) 
      FROM
         products p 
      WHERE
         l.category_id = p.category_id
   )
ORDER BY
   p.category_id;


-- Q4. Write a SQL query to display the category ID and the category name of the most expensive (highest list
--      price) product(s)

SELECT
   category_id,
   category_name 
FROM
   product_categories 
WHERE
   category_id IN 
   (
      SELECT
         category_id 
      FROM
         products 
      WHERE
         list_price IN 
         (
            SELECT
               MAX(list_price) 
            FROM
               products
         )
   )
;

-- 5. Write a SQL query to display product name and list price for products in category 1 which have the list
--     price less than the lowest list price in ANY category. Sort the output by top list prices first and then by
--     the product ID.

SELECT
   product_name,
   list_price 
FROM
   products 
WHERE
   category_id = 1 
   AND list_price < ANY (
   SELECT
      MIN(list_price) 
   FROM
      products 
   GROUP BY
      category_id) 
   ORDER BY
      list_price DESC,
      product_name;

-- Q6. Display the maximum price (list price) of the category(s) that has the lowest price product.

SELECT
   MAX(list_price) 
FROM
   products 
WHERE
   category_id IN 
   (
      SELECT
         category_id 
      FROM
         products 
      WHERE
         list_price IN 
         (
            SELECT
               MIN(list_price) 
            FROM
               products
         )
   )
;
