/*--------------------------------------------------------
The purpose of this file is to demonstrate an application
that connects to a sql database and can interact and 
manipulate data within the database.
This is Assingment 2 of DBS311.
Our team numbher is #7 and consists of:

Farshad Muhit Rashid :: ID: 121065197

Daniel Chang :: ID: 131781197

Stephane Kamdem Kamguia :: ID: 135736189

Dated: 08/10/2020
--------------------------------------------------------*/



CREATE PROCEDURE find_product(product_id IN NUMBER, price OUT products.list_price%type) IS
BEGIN SELECT p.list_price into price from products p where p.product_id = product_id;
EXCEPTION
WHEN no_data_found THEN
price:= 0;
END;

CREATE PROCEDURE add_order(customer_id IN NUMBER, new_order_id OUT NUMBER) IS
max_order_id NUMBER;
BEGIN select max(order_id) into max_order_id from orders;
INSERT INTO orders values(max_order_id+1, customer_id, 'Shipped', 56, SYSDATE);
new_order_id:=max_order_id+1;
END;

CREATE PROCEDURE add_order_item(orderId IN order_items.order_Id%type,
itemId IN order_items.item_Id%type,
productId IN order_items.product_Id%type,
quantity IN order_items.quantity%type,
price IN order_items.unit_price%type) IS
BEGIN
INSERT INTO order_items values(orderId, itemId, productId, quantity, price);
END;

CREATE PROCEDURE find_customer(customer_id IN NUMBER, found OUT NUMBER) IS
BEGIN
SELECT 1 into found from customers c where c.customer_id = customer_id;
EXCEPTION
WHEN no_data_found THEN
found:= 0;
END;


