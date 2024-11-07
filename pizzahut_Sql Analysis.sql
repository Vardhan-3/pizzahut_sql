-- Retrive total no of orders
SELECT COUNT(order_id) AS Total_orders FROM pizzahut.orders; 

-- Calculate the total revenue generated from pizza sales
USE  pizzahut;
SELECT ROUND(SUM(order_details.quantity * price),2) as total_sales
FROM pizzahut.order_details JOIN pizzahut.pizzas
ON pizzas.pizza_id = order_details.pizza_id;


-- Identify Higest-priced pizza
SELECT pizza_types.name, pizzas.price
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price desc limit 1;

-- Identify most common ordered pizza size
SELECT pizzas.size, COUNT(order_details.order_details_id) AS Quantity
FROM pizzas JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;

-- List Top 5 most ordered pizzas along with their quantities
SELECT pizza_types.name, sum(order_details.quantity) AS quantity
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name ORDER BY quantity DESC
LIMIT 5;

-- Join necessary colummns to find total quantity of each pizza category ordered
select pizza_types.category, sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;

-- Distribution of Orders by hour of the day
SELECT HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM orders
GROUP BY HOUR (order_time);

-- Category wise distribution of pizzas
SELECT category, count(name) FROM pizza_types 
GROUP BY category;

-- Group orders by date and calculate avg num of pizzas ordered per day
SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
    
-- Determine the top 3 most ordered pizza types based on revenue
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

-- ADV
-- Calculate the percentage contribution of each pizza type as total revenue

SELECT pizza_types.category,
(sum(order_details.quantity*pizzas.price) / (SELECT
    ROUND (SUM(order_details.quantity * pizzas.price), 
    2) AS total_sales
FROM order_details
JOIN
    pizzas ON (pizzas.pizza_id = order_details.pizza_id) )*100,2) AS Revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue DESC;

USE Pizzahut;
SELECT pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100, 2) AS revenue
FROM pizza types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;