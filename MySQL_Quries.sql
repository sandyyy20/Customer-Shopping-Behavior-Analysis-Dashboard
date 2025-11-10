create database customers;
use customers;

select * from customers1;


-- Q1

select gender, sum(purchase_amount) as revenue
from customers1
group by gender;

-- Q2
 
select customer_id, purchase_amount
from customers1
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount) from customers1);

-- Q3

select item_purchased, round(avg(cast(review_rating as decimal (10,2))),2) as "Average Product Rating"
from customers1
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- Q4

select shipping_type, 
ROUND(AVG(purchase_amount),2)
from customers1
where shipping_type in ('Standard','Express')
group by shipping_type;

-- Q5

SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount),2) AS avg_spend,
       ROUND(SUM(purchase_amount),2) AS total_revenue
FROM customers1
GROUP BY subscription_status
ORDER BY total_revenue,avg_spend DESC;

-- Q6

SELECT item_purchased,
       ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS discount_rate
FROM customers1
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

-- Q7

with customer_type as (
SELECT customer_id, previous_purchases,
CASE 
    WHEN previous_purchases = 1 THEN 'New'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
FROM customers1)

select customer_segment,count(*) AS "Number of Customers" 
from customer_type 
group by customer_segment;

-- Q8

WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customers1
    GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;

-- Q9

SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customers1
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- Q10

SELECT 
    age_group,
    SUM(purchase_amount) AS total_revenue
FROM customers1
GROUP BY age_group
ORDER BY total_revenue desc;