create database classicmodels;
use classicmodels;

/*import the data via import wizard by using sql database file*/

/* basic understanding of tables */
show tables;

select * from customers;
select * from employees;
select * from offices;
select * from orderdetails;
select * from orders;
select * from payments;
select * from productlines;
select * from products;

-- sql insights

/* 1. Find the no of productlines */
select count(productline) as productlines
from productlines;

-- There are 7 productlines

/* 2.Find no of products in each productlines */ 
select p.productline, count(distinct productcode) as products_count
from productlines p
left join products pd
on p.productline = pd.productline
group by p.productline
order by products_count desc;

-- Classic cars and Vintage cars accounts for large portion of products 

/* # productline	products_count
	Classic Cars	38
	Vintage Cars	24 */
    
/*3. Find no of sales in each productlines */

with cte as (
select od.productcode,sum(od.quantityordered*od.priceeach) as revenue
from orders o
inner join orderdetails od
on o.ordernumber = od.ordernumber
group by od.productcode)
select pd.productline,sum(revenue) as total_sales
from cte c
inner join products p
on c.productcode = p.productcode
inner join productlines pd
on p.productline = pd.productline
group by pd.productline
order by total_sales desc;

-- classic cars and vintage cars sales are highest 
/* # productline	total_sales
	Classic Cars	3853922.49
	Vintage Cars	1797559.63 */


/* 4. Find the Top 5 countries in sales */
with cte as (
select c.country,sum(od.quantityordered*od.priceeach) as sales
from customers c
inner join orders o
on c.customernumber = o.customernumber
inner join orderdetails od
on o.ordernumber = od.ordernumber
group by c.country)
select *,round(sales/(select sum(sales) from cte),2)*100 as sales_contribution,
dense_rank() over(order by sales desc) as `rank`
from cte
order by `rank`;

-- Axon max sales comes from USA (34%), top 5 countries contributes 2/3 rd business

/*# country	sales	sales_contribution	rank
		USA	3273280.05			34.00		1
		Spain	1099389.09		11.00		2
		France	1007374.02		10.00		3
		Australia	562582.59	6.00		4
		New Zealand	476847.01	5.00		5 */
        
        
/* 5 Top cities sales in USA */


select c.city,sum(od.quantityordered*od.priceeach) as sales
from orderdetails od
inner join orders o
on od.ordernumber = o.ordernumber
inner join customers c
on o.customernumber = c.customernumber
where c.country = 'USA'
group by c.city
order by sales desc;

-- San Rafael and NYC cities have high sales in USA
/* # city	sales
San Rafael	591827.34
NYC	497941.50
San Francisco	199051.34
New Bedford	190500.01
Brickhaven	150665.17 /*




