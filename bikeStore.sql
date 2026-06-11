use BikeStore;

/* 
Business Request #1:
"Can you identify our top 10 customers by lifetime revenue?"

Executive Summary:
The top revenue-generating customers produced between $49k to $69k in total revenue.
Shayn Hopkins ranked first with approximately $69.6k in sales, followed closely by
Pamelia Newman and Abby Gamble.  Several top-performing customers achieved their revenue through 
only two or three orders, indicating that a small number of high-value purchases can have a significant 
impact on overall revenue.  Targeted retention efforts focused on these customers could help sustain future
sales growth.
*/

select
	top 10
	c.customer_id,
	c.first_name,
	c.last_name,
	count(distinct o.order_id) as Total_orders,
	sum(oi.quantity * oi.list_price * (1 - oi.discount)) as Total_revenue
from customers c
join orders o
	on c.customer_id = o.customer_id
join order_items oi
	on o.order_id = oi.order_id
group by
	c.customer_id,
	c.first_name,
	c.last_name
order by
	Total_revenue desc


/* 
Business Request #2:
What were our monthly sales trends over the past two years?

Executive Summary:
Sales performance showed periods of strong growth throughout 2017 and early 2018,
culminating in a peak revenue month of approximately $1.63M in June 2018.  Revenue levels
were generally highest during the first half of each year.  While the latter half of 2018
experienced a notable decline in sales activity.  Understanding the drivers behind these
fluctuations may help improve forecasting and promotional planning.
*/

with Monthly_sales as (
	select
		DATEFROMPARTS(year(o.order_date), month(o.order_date), 1) as month_start,
		round(sum(oi.quantity * oi.list_price * (1 - discount)), 2) as total_revenue
	from orders o
	join order_items oi
		on o.order_id = oi.order_id
	where o.order_date >= DATEADD(
		Year,
		-2,
		(select max(order_date) from orders)
	)
	group by
		year(o.order_date),
		month(o.order_date)
)

select
	month_start
	total_revenue,
	LAG(total_revenue) over (order by month_start) as previous_month_revenue
from Monthly_sales
order by month_start


/*
Business Request #3:
Which stores generated the most revenue? 

Executive Summary:
Baldwin Bikes generated the hightest revenue at $10.43M, accounting for approximately
67.8% of total company revenue.  This makes Baldwin the strongest revenue driver across
all store locations.
*/

select
	s.store_name,
	s.city,
	s.state,
	ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_revenue
	from stores s
join orders o
	on s.store_id = o.store_id
join order_items oi
	on o.order_id = oi.order_id
group by
	s.store_name,
	s.city,
	s.state
order by
	total_revenue desc


/*
Business Request #4:
Which Product categories generate the most revenue?

Executive Summary:
Mountain Bikes generated the highest revenue at approximately $5.43M,
followed by Road Bikes at $3.33M and Cruisers Bicycles at $1.99M,
Mountain Bikes are the strongest revenue-driving category and should be
prioritized for inventory planning and promotional strategy.
*/

select
	c.category_name,
	SUM(oi.quantity) as units_sold,
	ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_revenue
from categories c
join products p
	on c.category_id = p.category_id
join order_items oi
	on p.product_id = oi.product_id
group by
	c.category_name
order by
	Total_Revenue desc


/* 
Business Request #5:
Which customers haven't purchased recently?

Executive Summary:
This query identifies customers with the longest time since their last purchase,
using the latest order date in the datset as the comparison point,
These customers may be good candidates for re-engagement campaigns.
*/

select
	c.customer_id,
	c.first_name,
	c.last_name,
	max(o.order_date) as last_purchase_date,
	datediff(
		day,
		Max(o.order_date),
		(select Max(order_date) from orders)
	) as days_since_last_purchase		
from customers c
join orders o
	on c.customer_id = o.customer_id
group by
	c.customer_id,
	c.first_name,
	c.last_name
order by
	days_since_last_purchase desc


/* 
Business Request #6:
What percentage of customers are repeat customers versus one-time customers?

Executive Summary:
One-time customers make up the majority of the customer base, with 1,314 customers
or approximately 90.93% placing only one order.  Repeat customers account for only
131 customers, or about 9.07%.  This suggest that improvement is needed to help improve
customer loyalty.
*/

with customer_orders AS (
	select
		c.customer_id,
		count(o.order_id) as order_count
	from customers c
	join orders o
		on c.customer_id = o.customer_id
	group by
		c.customer_id
)

select
	case 
		when order_count = 1 then 'one-time'
		else 'repeat'
	end as customer_type,
	count(*) as customer_count,
	round(
		count(*) * 100.0 / sum(count(*)) over (),
		2
		) as percentage
from customer_orders
group by
	case
		when order_count = 1 then 'one-time'
		else 'repeat'
	end;


/* 
Business Request #7:
Which Brands generated the most revenue?

Executive Summary:
Trek generated the highest brand revenue, followed by Electra.
These brands are the strongest revenue drivers and may deserve priority
for inventory planning and promotional campaigns.
*/

select
	b.brand_id,
	b.brand_name,
	round(sum(oi.quantity * oi.list_price * (1 - oi.discount)),2) as revenue
from brands b
join products p
	on b.brand_id = p.brand_id
join order_items oi
	on p.product_id = oi.product_id
group by
	b.brand_id,
	b.brand_name
order by
	revenue desc


/* 
Business Request #8:
Which customers place the largest average orders?

Executive Summary:
Customers with the highest average order values generated substantial revenue despite placing relatively few orders.  
Pamelia Newman recorded the highest average order value at approximately $22,462 per order, followed by several other customers
with consitently high-spending purchase behavior.  These customers may represent valueable opportunities for targeted retention and loyalty initiatives.
*/

select
	c.customer_id,
	c.first_name,
	c.last_name,
	count(distinct(o.order_id)) as total_orders,
	round(sum(oi.quantity * oi.list_price * (1 - oi.discount)),2) as total_revenue,
	round(
		sum(oi.quantity * oi.list_price * (1 - oi.discount))
		/ count(distinct o.order_id),
		2
	) as average_order_value
from customers c
join orders o
	on c.customer_id = o.customer_id
join order_items oi
	on o.order_id = oi.order_id
group by
	c.customer_id,
	c.first_name,
	c.last_name
order by
	total_orders desc,
	average_order_value desc
	

/* 
Business Request #9:
Which products have never been sold?

Executive Summary:
Several products across multiple categories recorded no sales activity.
Road Bikes and Mountain Bikes contained several unsold products, including
multiple Trek models.  These products may warrant further investigation to
determine whether pricing, inventory levels, product visibility, or customer
demand contributed to the lack of sales.
*/

select
	p.product_id,
	p.product_name,
	c.category_name,
	b.brand_name
from products p
join categories c
	on p.category_id = c.category_id
join brands b
	on p.brand_id = b.brand_id
left join order_items oi
	on p.product_id = oi.product_id
where oi.product_id is NULL
order by
	c.category_name,
	b.brand_name,
	p.product_name


/* 
Business request #10:
What is the highest revenue product within each category?

Executive Summary:
The top revenue-driving product varied by category, with Trek Slash 8 27.5-2016 leading
mountain bikes and Trek Condit+ -2016 leading Electric Bikes.  These prodcts represent
the strongest performers within their respective categories and may be good candidates for 
promotional focus, inventory planning, or featured product placement.
*/

with product_revenue as (
	select
		c.category_name,
		p.product_name,
		sum(oi.quantity * oi.list_price * (1 - oi.discount)) as revenue
	from products p
	join categories c
		on p.category_id = c.category_id
	join order_items oi
		on p.product_id = oi.product_id
	group by
		p.product_name,
		c.category_name
),
ranked_products as (
	select
		category_name,
		product_name,
		revenue,
		row_number() over (
			partition by category_name
			order by revenue desc
		) as product_rank
	from product_revenue
)

select
	category_name,
	product_name,
	ROUND(revenue, 2) as revenue
from ranked_products
where product_rank = 1
order by revenue desc
