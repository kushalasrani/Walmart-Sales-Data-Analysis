CREATE DATABASE IF NOT EXISTS WalmartSales;

CREATE TABLE IF NOT EXISTS sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int(30) not null,
VAT float(6,4) not null,
total decimal(10,2) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,9) not null,
gross_income decimal(12,4) not null,
rating float(2,1) not null
);

--------------------------------------------------
--------- Feature Engineering --------------------

-- time_of_day
select time, 
(case 
  when time between "00:00:00" and "12:00:00" then "Morning"
   when time between "12:01:00" and "16:00:00" then "Afternoon"
   else "Evening"
   end
) as time_of_date
 from sales;
 
 ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day=(
case 
    when time between "00:00:00" and "12:00:00" then "Morning"
    when time between "12:01:00" and "16:00:00" then "Afternoon"
    else "Evening"
end
);

-- day_name
select date, dayname(date) AS day_name from sales;

 ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
 
 UPDATE sales 
 SET day_name= dayname(date);
 
 -- month_name
 
 select date, monthname(date) as month_name from sales;
 
 alter table sales add column month_name varchar(10);
 
 UPDATE sales 
 SET month_name= monthname(date);
 ----------------------------------------------------------------------------------------------------
 
 
 ----------------------------------------------------------------------------------------------------
 
 ---------------------------------- Generic Question -------------------------------------------------
 -- How many unique cities does the data have?
 select 
	distinct city
from sales;
 
 -- In which city is each branch?
 select 
	distinct branch
from sales;
  
 select 
	distinct city, branch
from sales; 

---------------------------------- Product -------------------------------------------------
 -- How many unique product lines does the data have?
  select 
	distinct product_line 
from sales;

-- What is the most common payment method?
select 
	payment_method, count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc;

-- What is the most selling product line?
select 
	product_line, count(product_line) as cnt
from sales
group by product_line
order by cnt desc;

-- What is the total revenue by month?
select 
	month_name as month, sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?
select 
	month_name as month, sum(cogs) as highest_cogs
from sales
group by month_name
order by highest_cogs desc;

-- What product line had the largest revenue?
select 
	product_line, sum(total) as largest_revenue
from sales
group by product_line
order by largest_revenue desc;

-- What is the city with the largest revenue?
select 
	branch, city, sum(total) as largest_revenue
from sales
group by city, branch
order by largest_revenue desc;

-- What product line had the largest VAT?
select 
	product_line, sum(vat) as largest_vat
from sales
group by product_line
order by largest_vat desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select 
	product_line, round(avg(total),2) as avg_sales,
    ( case when avg(total) > (select avg(total) from sales) then "GOOD"
	  else "BAD" end) as remarks
from sales
group by product_line;

-- Which branch sold more products than average product sold?
select
	branch, sum(quantity) as qty
from sales
group by branch
having qty > (select avg(quantity) from sales);

-- What is the most common product line by gender?
select 
	gender,product_line, count(gender) as cnt
from sales
group by product_line, gender
order by cnt desc;

-- What is the average rating of each product line?
select
	product_line, round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc;

---------------------------------- Sales -------------------------------------------------
-- Number of sales made in each time of the day per weekday
select 
	time_of_day, count(*) as total_sales
from sales
where day_name="Sunday"
group by time_of_day
order by total_sales desc;

-- Which of the customer types brings the most revenue?
select 
	customer_type, sum(total) as most_revenue
from sales
group by customer_type
order by most_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select 
	city, sum(vat) as largest_vat
from sales
group by city
order by largest_vat desc;

-- Which customer type pays the most in VAT?
select 
	customer_type, sum(vat) as most_vat_paid
from sales
group by customer_type
order by most_vat_paid desc;

---------------------------------- Customer -------------------------------------------------
-- How many unique customer types does the data have?
select distinct customer_type from sales;

-- How many unique payment methods does the data have?
select distinct payment_method from sales;

-- What is the most common customer type?
select customer_type, count(customer_type) as cnt
from sales
group by customer_type
order by cnt desc;

-- What is the gender of most of the customers?
select 
	gender, count(gender) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- What is the gender distribution per branch?
select 
	branch, gender, count(gender) as gender_cnt
from sales
group by branch,gender
order by gender_cnt desc;

-- Which time of the day do customers give most ratings?
select
	time_of_day, round(avg(rating),2) as most_ratings
from sales
group by time_of_day
order by most_ratings desc;

-- Which time of the day do customers give most ratings by branch?
select
	time_of_day, round(avg(rating),2) as most_ratings
from sales
where branch="A"
group by time_of_day
order by most_ratings desc;

-- Which day fo the week has the best avg ratings?
select
	day_name, round(avg(rating),2) as most_ratings
from sales
group by day_name
order by most_ratings desc;

-- Which day of the week has the best average ratings per branch?
select
	branch,day_name, round(avg(rating),2) as most_ratings
from sales
group by branch, day_name
order by most_ratings desc;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
