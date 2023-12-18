create database salesdata

CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct decimal(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct decimal(11,9),
    gross_income DECIMAL(12, 4),
    rating decimal(2, 1)
);

select*
from [WalmartSalesData.csv]

-------------------------feature engineering---------------------------------------
--(inserting the time of day the sales are being made)

select time,
(case when time between '00:00:00' and '12:00:00' then 'morning'
     when time between '12:00:01' and '16:00:00' then 'afternoon'
	 else 'evening' end) as time_of_day
from [WalmartSalesData.csv]

alter table [WalmartSalesData.csv]
add time_of_day varchar(50)

update [WalmartSalesData.csv]
set time_of_day =(case when time between '00:00:00' and '12:00:00' then 'morning'
     when time between '12:00:01' and '16:00:00' then 'afternoon'
	 else 'evening' end)

--inserting the day that the sales where made

select date,
datename (weekday,date)as day_name
from  [WalmartSalesData.csv]

alter table  [WalmartSalesData.csv]
add day_name varchar(50)

update  [WalmartSalesData.csv]
set day_name =datename (weekday,date)

--inserting the month that sales where made 
select date,
datename (month,date)as month_name
from  [WalmartSalesData.csv]

alter table  [WalmartSalesData.csv]
add month_name varchar(50)

update  [WalmartSalesData.csv]
set month_name =datename (month,date)


---------------------GENERIC QUESTIONS-----------------------
--HOW MANY UNIQUE CITIES DOES THE DATA HAVE

Select distinct(city)
from  [WalmartSalesData.csv]

--how many branch in each city
select city, branch
from  [WalmartSalesData.csv]
 

 ---------------PRODUCT----------------------
 -- How many unique product lines does the data have--

 SELECT  count(distinct product_line)
 from [WalmartSalesData.csv]

 --What is the most common payment method
 select payment,
 count(payment) as cnt
 from  [WalmartSalesData.csv]
 group by payment

 --What is the most selling product line
 select product_line,
 count(product_line) as cnt_product_line
 from  [WalmartSalesData.csv]
 group by Product_line
 order by cnt_product_line desc

 ---What is the total revenue by month?
 select month_name ,
 sum(total) as total_revenue
 from  [WalmartSalesData.csv]
 group by month_name
 order by total_revenue desc

 --What product line had the largest revenue
  select product_line ,
 sum(total) as total_revenue
 from  [WalmartSalesData.csv]
 group by product_line
 order by total_revenue desc

 --Which customer type buys the most?
 select customer_type,
 sum(quantity) as qtytotal
 from [WalmartSalesData.csv]
 group by Customer_type
 order by  qtytotal desc

 -- What is the city with the largest revenue?
 select city,
 sum(total) as total_revenue
 from [WalmartSalesData.csv]
 group by city
 order by total_revenue desc

 --What product line had the largest VAT?
 select Product_line,
 avg(Tax_5) as avg_tax
 from [WalmartSalesData.csv]
 group by Product_line
 order by avg_tax desc

 --Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
 select product_line,total,
( case when total> avg(total) over(partition by product_line order by total) then 'good'
     else 'bad'
	 end) as review
from  [WalmartSalesData.csv]

--Number of sales made in each time of the day per weekday
select time_of_day,
count(*) as total_sales_perday
from [WalmartSalesData.csv]
where day_name = 'sunday'
group by time_of_day

--Which of the customer types brings the most revenue?
select Customer_type,sum(total) as totalrev
from [WalmartSalesData.csv]
group by customer_type
order by totalrev desc

--Which city has the largest tax percent/ VAT (**Value Added Tax**)?
select City,avg(tax_5) as avgtax
from [WalmartSalesData.csv]
group by city
order by avgtax desc

-- Which customer type pays the most in VAT?
select Customer_type,avg(Tax_5) as vat
from [WalmartSalesData.csv]
group by customer_type
order by vat desc

--How many unique customer types does the data have?
select distinct(Customer_type),
       count(*) as memebers_in_each_ct
from [WalmartSalesData.csv]
group by Customer_type

--How many unique payment methods does the data have?
select distinct(Payment)
from [WalmartSalesData.csv]

-- Which customer type buys the most?
select customer_type,count(*) as totalrev
from [WalmartSalesData.csv]
group by Customer_type
order by totalrev  desc

--What is the gender of most of the customers?
select gender, count(*) genderct
from [WalmartSalesData.csv]
group by Gender
order by genderct desc

--What is the gender distribution per branch?
select gender,branch, count(*)
from [WalmartSalesData.csv]
group by branch, gender

--Which time of the day do customers give most ratings?
select time_of_day, avg(rating) as avgrating
from [WalmartSalesData.csv]
group by time_of_day
order by avgrating desc

--Which time of the day do customers give most ratings per branch?
select time_of_day,branch, avg(rating) as avgrating
from [WalmartSalesData.csv]
group by time_of_day,branch
order by avgrating desc

--Which day fo the week has the best avg ratings?
select day_name,avg(rating) as avgrating
from [WalmartSalesData.csv]
group by day_name
order by avgrating desc



