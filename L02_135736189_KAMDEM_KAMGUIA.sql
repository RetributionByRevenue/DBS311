-- ***********************
-- Name: Stephane Kamdem Kamguia
-- ID: 135736189
-- Date: Monday, 8 June 2020
-- Purpose: Lab 02 DBS311
-- ***********************

--- Q1. For each job title display the number of employees. Sort the result according to the number
---    of employees.  

SELECT
   job_title,
   COUNT(job_title) AS "employess" 
FROM
   employees 
WHERE
   job_title BETWEEN 'A' AND 'z' 
GROUP BY
   job_title 
ORDER BY
   "employess";

--- Q2. Display the highest, lowest, and average customer credit limits. Name these results high,
---     low, and average. Add a column that shows the difference between the highest and the
---     lowest credit limits named “High and Low Difference”. Round the average to 2 decimal places.

SELECT
   MAX(credit_limit) AS "high",
   MIN(credit_limit) AS "low",
   round(AVG(credit_limit), 2) AS "average",
   MAX(credit_limit) - MIN(credit_limit) AS "high low difference" 
FROM
   customers;

--- Q3. Display the order id, the total number of products, and the total order amount for orders
---     with the total amount over $1,000,000. Sort the result based on total amount from the high
---     to low values.

SELECT
   order_id,
   SUM(quantity) AS "total_items",
   SUM(quantity*unit_price) AS "total_amount" 
FROM
   order_items 
GROUP BY
   order_id 
HAVING
   SUM(quantity*unit_price) > 1000000 
ORDER BY
   SUM(quantity*unit_price) DESC;

--- Q4. Display the warehouse id, warehouse name, and the total number of products for each
---     warehouse. Sort the result according to the warehouse ID.

SELECT
   w.warehouse_id,
   w.warehouse_name,
   SUM(i.quantity) AS "total_products" 
FROM
   warehouses w 
   INNER JOIN
      inventories i 
      ON w.warehouse_id = i.warehouse_id 
GROUP BY
   w.warehouse_id,
   w.warehouse_name 
ORDER BY
   w.warehouse_id;

--- Q5. For each customer display customer number, customer full name, and the total number of
---     orders issued by the customer.
---     ? If the customer does not have any orders, the result shows 0.
---     ? Display only customers whose customer name starts with ‘O’ and contains ‘e’.
---     ? Include also customers whose customer name ends with ‘t’.
---     ? Show the customers with highest number of orders first.

SELECT
   c.customer_id,
   c.name AS "customer name",
   COUNT(o.order_id) AS "total number OF orders" 
FROM
   customers c 
   LEFT JOIN
      orders o 
      ON c.customer_id = o.customer_id 
WHERE
   c.name LIKE 'O%e%' 
   OR c.name LIKE '%t' 
GROUP BY
   c.customer_id,
   c.name 
ORDER BY
   COUNT(o.order_id) DESC;

--- Q6. Write a SQL query to show the total and the average sale amount for each category. Round
---     the average to 2 decimal places.
SELECT
   p.category_id,
   SUM(o.quantity*o.unit_price) AS "total_amount",
   round(AVG(o.quantity*o.unit_price), 2) AS "average_amount" 
FROM
   order_items o 
   INNER JOIN
      products p 
      ON p.product_id = o.product_id 
GROUP BY
   p.category_id;






