-- Q1: Write a query to display the tomorrow’s date in the following format: January 10th of year 2019

SELECT to_char(sysdate+1, 'Mon" "dd" of year "yyyy') AS "Tomorrow" FROM dual;


-- Q2: For each product in category 2, 3, and 5, show product ID, product name, list price, 
       --and the new list price increased by 2%. Display a new list price as a whole number.

SELECT product_id,product_name,list_price,(list_price + (list_price * 0.02)) AS "new_list",
       (list_price + (list_price * 0.02) - list_price) AS "difference_list_prices" 
FROM products 
WHERE product_id IN ('2','3','5');

-- Q3: For employees whose manager ID is 2, write a query that displays the employee’s Full Name
      --and Job Title in the following format: SUMMER, PAYNE is Public Accountant.
      
SELECT (last_name|| ', ' || first_name ||' is '||job_title) AS "Employees jobs"
FROM employees
WHERE manager_id = 2;

-- Q4: For each employee hired before October 2016, display the employee’s last name, hire date 
       --and calculate the number of YEARS between TODAY and the date the employee was hired. Label the column Years worked. 
	   --Order your results by the number of years employed.  Round the number of years employed up to the closest whole number.
       
SELECT LAST_NAME, HIRE_DATE, EXTRACT(YEAR FROM (SYSDATE - HIRE_DATE) YEAR TO MONTH) "Years worked"
FROM EMPLOYEES
WHERE HIRE_DATE < '01-OCT-2016'
ORDER BY "Years worked" desc;

-- Q5: Display each employee’s last name, hire date, and the review date, which is the first Tuesday 
       --after a year of service, but only for those hired after 2016. Label the column REVIEW DAY. 
       --Format the dates to appear in the format like: TUESDAY, August the Thirty-First of year 2016 Sort by review date
       
SELECT last_name, hire_date, to_char(next_day((hire_date+365),'Thursday'),
       'DAY", "Month" the "dd" of year "yyyy')AS "Review Day"
FROM employees
WHERE hire_date >= to_date('2016-01-01','yyyy-mm-dd')
ORDER BY "Review Day";

-- Q6: For all warehouses, display warehouse id, warehouse name, city, and state. 
      --For warehouses with the null value for the state column, display “unknown”.

SELECT w.warehouse_id, w.warehouse_name, l.city, CASE WHEN l.state IS NULL THEN 'Unknown'
       ELSE l.state END AS "Provinces"
FROM warehouses w INNER JOIN locations l
ON w.warehouse_id = l.location_id;
 

