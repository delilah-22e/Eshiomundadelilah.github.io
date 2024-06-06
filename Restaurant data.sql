--This is an exploration of a restaurants orders and the performance of the different items on the menu.
---This exploration can help us understand how the different items on the menu are performing 

--List all menu items along with their prices.
SELECT item_name,price
FROM `Restaurant_data.Menu_items`

--How many orders were placed in total?
 SELECT COUNT(order_details_id) as total_orders
 FROM `Restaurant_data.Order_details`

--What are the unique categories of menu items available?
SELECT DISTINCT category
 FROM `Restaurant_data.Menu_items` 

--What is the average price of menu items?
select AVG(price)
from `Restaurant_data.Menu_items`

--Which menu item has the highest price?
SELECT item_name 
FROM `Restaurant_data.Menu_items`
WHERE price =(SELECT MAX(price) 
     FROM `Restaurant_data.Menu_items`)

--List the top 5 menu items ordered the most.
WITH Favourite_items as (SELECT item_name,COUNT(menu_item_id) as total_count
FROM `Restaurant_data.Menu_items` AS MI inner join `Restaurant_data.Order_details` AS OD ON MI.menu_item_id=OD.item_id
GROUP BY item_name
ORDER BY total_count DESC
LIMIT 5)
SELECT item_name 
FROM Favourite_items

--Find the category with the highest average price of its items.
SELECT category
FROM(SELECT category, AVG(price) as avg_price
      FROM `Restaurant_data.Menu_items`
       GROUP BY category)
ORDER BY avg_price DESC
LIMIT 1

--List menu items that have never been ordered.

SELECT item_name, item_id,order_details_id
FROM `Restaurant_data.Menu_items` AS RDM LEFT JOIN `Restaurant_data.Order_details` AS ROD
ON RDM.menu_item_id= ROD.item_id
WHERE ROD.item_id IS NULL

--SELECT item_name, item_id, order_details_id
--FROM `Restaurant_data.Menu_items` AS RDM 
--LEFT JOIN `Restaurant_data.Order_details` AS ROD
--ON RDM.menu_item_id = ROD.item_id
--WHERE ROD.item_id IS NULL

--What time of the day has the most orders term it as peak hours.
SELECT 
  Time_period,
  COUNT(order_details_id) AS Total_orders
FROM (
  SELECT 
    order_details_id,order_time,
    CASE 
      WHEN order_time BETWEEN '00:00:00 AM' AND '05:59:59 AM' THEN 'Night'
      WHEN order_time BETWEEN '06:00:00 AM' AND '11:59:59 AM' THEN 'Breakfast'
      WHEN order_time BETWEEN '12:00:00 PM' AND '5:59:59 PM' THEN 'Lunch'
      WHEN order_time BETWEEN '6:00:00 PM' AND '9:59:59 PM' THEN 'Dinner'
    END AS Time_period
  FROM `Restaurant_data.Order_details`
) AS Order_periods

GROUP BY Time_period
ORDER BY Total_orders DESC
--LIMIT 1

--What is the total revenue generated from orders on a specific date?
 
SELECT order_date, SUM(price) AS Total_revenue
     FROM `Restaurant_data.Order_details` AS a 
     INNER JOIN `Restaurant_data.Menu_items` AS b
     ON a.item_id= b.menu_item_id
     GROUP BY order_date

--Revenue Month on Month

SELECT FORMAT_DATE('%B', order_date) AS month,SUM(price) AS Total_revenue
     FROM `Restaurant_data.Order_details` AS a 
     INNER JOIN `Restaurant_data.Menu_items` AS b
     ON a.item_id= b.menu_item_id
     GROUP BY month

