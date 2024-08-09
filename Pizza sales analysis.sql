PIZZA SALES ANALYSIS-

--Q1: The total number of order place

select sum(quantity) as total_order_placed
from `order_details.csv_order_details.csv`;


--Q2: The total revenue generated from pizza sales

select sum(a.quantity*b.price) as total_revenue
from `order_details.csv_order_details.csv` a
inner join `pizzas.csv_pizzas.csv` b
on a.pizza_id = b.pizza_id;


--Q3: The highest priced pizza

select a.price, a.size, b.name as pizza_type
from `pizzas.csv_pizzas.csv` a
inner join `pizza_types.csv_pizza_types.csv` b
on a.pizza_type_id = b.pizza_type_id
order by price desc;


--Q4: The most common pizza size ordered

select sum(a.quantity) as total_pizza_ordered, b.size
from `order_details.csv_order_details.csv` a
inner join `pizzas.csv_pizzas.csv` b
on a.pizza_id = b.pizza_id
group by b.size
order by sum(a.quantity) desc;

--Q5: The top 5 most ordered pizza types along their quantities

select sum(a.quantity) as total_ordered_pizza, c.name as pizza_type
from `order_details.csv_order_details.csv` a
inner join `pizzas.csv_pizzas.csv` b
on a.pizza_id = b.pizza_id
inner join `pizza_types.csv_pizza_types.csv` c
on b.pizza_type_id = c.pizza_type_id
group by c.name
order by sum(a.quantity) desc
limit 5;

--Q6: The quantity of each pizza categories ordered.

select sum(a.quantity) as total_ordered_pizza, c.category
from `order_details.csv_order_details.csv` a
inner join `pizzas.csv_pizzas.csv` b
on a.pizza_id = b.pizza_id
inner join `pizza_types.csv_pizza_types.csv` c
on b.pizza_type_id = c.pizza_type_id
group by c.category;


--Q7: The distribution of orders by hours of the day

select hour(a.time) as hours_of_the_day, sum(b.quantity) as num_of_orders
from `orders.csv_orders.csv` a
inner join `order_details.csv_order_details.csv` b
on a.order_id = b.order_id
group by  hour(time);


--Q8: The category-wise distribution of pizzas

select category, count(category) as total_pizza
from `pizza_types.csv_pizza_types.csv`
group by category;


--Q9: The average number of pizzas ordered per day
	
select avg(c.ordered_pizza) as avg_ordered_pizza_per_day 
from (select b.date as day, sum(a.quantity) as ordered_pizza
from `order_details.csv_order_details.csv` a
inner join `orders.csv_orders.csv` b
on a.order_id = b.order_id
group by b.date) c;


--Q10: Top 3 most ordered pizza type base on revenue.

select c.name as pizza_type, sum(a.quantity*b.price) as total_revenue
from `order_details.csv_order_details.csv` a
inner join `pizzas.csv_pizzas.csv` b
on a.pizza_id = b.pizza_id
inner join `pizza_types.csv_pizza_types.csv` c
on b.pizza_type_id = c.pizza_type_id
group by c.name
order by sum(a.quantity*b.price) desc
limit 3;


--Q11: The percentage contribution of each pizza type to revenue

create view revenue_table as select c.name as pizza_type, 
sum(a.quantity*b.price) as total_revenue
from `order_details.csv_order_details.csv` a
inner join `pizzas.csv_pizzas.csv` b
on a.pizza_id = b.pizza_id
inner join `pizza_types.csv_pizza_types.csv` c
on b.pizza_type_id = c.pizza_type_id
group by c.name;
select pizza_type, total_revenue,
round(total_revenue*100/t.s,2) as percentage_contribution
from revenue_table
cross join (Select Sum(total_revenue) as s from revenue_table) t;


--Q12: The cumulative revenue generated over time

select b.order_details_id, a.date, a.time, b.quantity*c.price as revenue
from `orders.csv_orders.csv` a
inner join `order_details.csv_order_details.csv` b
on a.order_id = b.order_id
inner join `pizzas.csv_pizzas.csv` c
on b.pizza_id = c.pizza_id;


--Q13: The top 3 most ordered pizza type based on revenue for each pizza category

select *
from(select c.category, c.name as pizza_type, a.quantity*b.price as revenue, 
row_number() 
over(partition by c.category order by a.quantity*b.price desc) as rn
from `order_details.csv_order_details.csv` a
inner join `pizzas.csv_pizzas.csv` b
on a.pizza_id = b.pizza_id
inner join `pizza_types.csv_pizza_types.csv` c
on b.pizza_type_id = c.pizza_type_id) as d
where d.rn<=3;

