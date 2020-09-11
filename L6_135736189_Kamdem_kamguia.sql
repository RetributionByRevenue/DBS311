-- ***********************
-- Name: Stephane Kamdem Kamguia
-- ID: 135736189
-- Date: Sunday, 19 July 2020
-- Purpose: Lab 06 DBS311
-- ***********************

SET SERVEROUTPUT ON

-- Q1.	Write a store procedure that gets an integer number n and calculates and displays its factorial.

CREATE PROCEDURE factorial(numbers INT) as f INT: = 1; 
-- cannot set f to zero because in the loop statetemt f will be always equal to zero
BEGIN
   IF(numbers < 0) 
THEN
   dbms_output.put_line('Please enter positive numbers');
elsif (numbers = 0) 
THEN
   dbms_output.put_line('Factorial = 1');
ELSE
   FOR i IN 1..n loop f: = f * i;
END
loop;
dbms_output.put_line('Factorial: ' || f);
END
IF;
exception 
WHEN
   others 
THEN
   dbms_output.put_line('Error Occured');
END
;
BEGIN
   factorial(3);
END
;

-- Q2. Write a stored procedure named calculate_salary which gets an employee ID and for that employee 
--        calculates the salary based on the number of years the employee has been working in the company

CREATE PROCEDURE calculate_salary(i_empid number) IS l_fn employees.first_name % type;
l_ln employees.last_name % type;
l_hd employees.hire_date % type;
l_sal number(10): = 10000;
l_yr number (10);
BEGIN
   SELECT
      first_name,
      last_name,
      hire_date INTO l_fn,
      l_ln,
      l_hd 
   FROM
      employees 
   WHERE
      employee_id = i_empid;
dbms_output.put_line('First Name: ' || l_fn);
dbms_output.put_line('Last Name: ' || l_ln);
SELECT
(EXTRACT(YEAR 
FROM
   sysdate) - EXTRACT (YEAR 
FROM
   l_hd)) INTO l_yr 
FROM
   DUAL;
FOR i IN 1..l_yr loop l_sal : = l_sal*(1.05);
END
loop;
dbms_output.put_line('Salary: $' || l_sal);
exception 
WHEN
   no_data_found 
THEN
   dbms_output.put_line('Employee ID not exist');
WHEN
   others 
THEN
   dbms_output.put_line('Error Occured');
END
;
BEGIN
   calculate_salary(107);
END
;

-- Q3. Write a stored procedure named warehouses_report to print the warehouse ID, warehouse name, and the city 

CREATE PROCEDURE warehouse_report IS l_wid warehouses.warehouse_id % type;
l_wn warehouses.warehouse_name % type;
l_city locations.city % type;
l_state locations.state % type;
BEGIN
   FOR i IN 1..9 loop 
   SELECT
      w.warehouse_id,
      w.warehouse_name,
      l.city,
      nvl(l.state, 'no state') INTO l_wid,
      l_wn,
      l_city,
      l_state 
   FROM
      warehouses w 
      INNER JOIN
         locations l 
         ON (w.location_id = l.location_id) 
   WHERE
      w.warehouse_id = i;
dbms_output.put_line('Warehouse ID: ' || l_wid);
dbms_output.put_line('Warehouse name: ' || l_wn);
dbms_output.put_line('City: ' || l_city);
dbms_output.put_line('State: ' || l_state);
dbms_output.put_line('');
END
loop;
exception 
WHEN
   others 
THEN
   dbms_output.put_line('Error Occured');
END
;
BEGIN
   warehouse_report();
END
;
