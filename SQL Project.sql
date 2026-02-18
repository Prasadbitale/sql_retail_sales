-- SQL retail sales analysis

create database sql_project;
use sql_project;

-- Create table 
drop table if exists retail_sales;

create table retail_sales
   (
        transactions_id int primary key,
        sale_date date,
        sale_time time,
        customer_id int,
        gender varchar(15),
        age int,
        category varchar(15),
        quantiy int,
        price_per_unit float,
        cogs float,
		total_sale float
        
	) ;


select * from retail_sales ;

select count(*) from retail_sales;

-- data cleaning 
-- checking null values 
select * from retail_sales
where transactions_id is null;

select * from retail_sales
where 
      transactions_id is null
      or
      sale_time is null
      or
      sale_date is null
      or 
      customer_id is null
      or 
      gender is null
      or 
      age is null
      or 
      category is null
      or 
      quantiy is null
      or 
      price_per_unit is null 
      or
      cogs is null
      or 
      total_sale is null;
      -- no null values detected 
      -- if we had found it we can use 
      
set sql_safe_updates = 0 ;
delete from retail_sales 
where 
      transactions_id is null
      or
      sale_time is null
      or
      sale_date is null
      or 
      customer_id is null
      or 
      gender is null
      or 
      age is null
      or 
      category is null
      or 
      quantiy is null
      or 
      price_per_unit is null 
      or
      cogs is null
      or 
      total_sale is null;
      
set sql_safe_updates = 1;

-- how many sales we have?
select count(*) as total_Sales from retail_sales;

-- how many unique customers we have ?
select count(distinct customer_id) as total_customers_we_have from retail_sales;

-- how many unique categories we have ?
select distinct category as total_categories_we_have from retail_sales;

-- Data analysis and Business key problems and answers

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
select * from retail_sales 
where sale_date = '2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022.
select * from retail_sales
where category = "Clothing" and quantiy>2 and sale_date between "2022-11-01" and "2022-11-30";

select * from retail_sales
where 
     category = "Clothing" 
     and 
     quantiy>2
     and
     date_format(sale_date , '%Y-%m') = "2022-11" ; 

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.

select category , sum(total_sale) as total_sales_by_category , count(quantiy) as total_ordres
from retail_sales 
group by category;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category , avg(age) as avg_age from retail_sales
where category = "Beauty";

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales 
where total_sale > 1000;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category , gender , count(DISTINCT transactions_id) as transaction_count
from retail_sales
group by category , gender
order by 1;

-- Q7. Write a SQL query to calculate the average sale for each month and find the best-selling month in each year.
select sale_year , sale_month , avg_Sale_per_month from (
select year(sale_date) as sale_year , 
month(sale_date) as sale_month , 
round(avg(total_sale)) as avg_Sale_per_month,
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rn
from retail_sales
group by year(sale_date) , month(sale_date)
) t1 where t1.rn=1 
order by sale_year;


-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id , sum(total_sale) as total_sales 
from retail_sales
group by customer_id
order by total_sales desc
limit 5;

-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
select category , count(distinct customer_id) as customers_count
from retail_sales 
group by category ;


-- Q10. Write a SQL query to create each shift and number of orders
-- Example:
-- Morning ≤ 12
-- Afternoon between 12 & 17

select * , 
       case 
           when hour(sale_time)<12 then "Morning"
           when hour(sale_time) between 12 and 17 then "Afternoon"
           else "Evening"
		end as Shift
from retail_sales;



-- Joins key problems 
CREATE TABLE category_info
(
    category VARCHAR(15) PRIMARY KEY,
    manager VARCHAR(50),
    discount_percent FLOAT
);
INSERT INTO category_info (category, manager, discount_percent) VALUES
('Beauty', 'Sophia', 10),
('Clothing', 'Sarah', 15),
('Electronics', 'John', 12);


-- Q11. Find all sales along with the manager of the category and the discount percentage
-- inner join
SELECT 
    r.transactions_id,
    r.sale_date,
    r.category,
    r.total_sale,
    c.manager,
    c.discount_percent
FROM retail_sales r
INNER JOIN category_info c
ON r.category = c.category;

-- Q12. List all sales and include category manager and discount information if available. If some sales belong to categories not in category_info, still include them.
-- left join 
SELECT 
    r.transactions_id,
    r.sale_date,
    r.category,
    r.total_sale,
    c.manager,
    c.discount_percent
FROM retail_sales r
LEFT JOIN category_info c
ON r.category = c.category;

-- Q13. Show all categories in category_info and any sales associated with them. If a category has no sales yet, still display it.
-- Right join 
SELECT 
    r.transactions_id,
    r.sale_date,
    c.category,
    r.total_sale,
    c.manager,
    c.discount_percent
FROM retail_sales r
RIGHT JOIN category_info c
ON r.category = c.category;

-- Q14.Create a report that lists all sales and all categories, matching sales to categories where possible. Include unmatched sales and unmatched categories.
SELECT 
    r.transactions_id,
    r.sale_date,
    r.category AS sale_category,
    r.total_sale,
    c.category AS info_category,
    c.manager,
    c.discount_percent
FROM retail_sales r
FULL OUTER JOIN category_info c
ON r.category = c.category;

-- Q15. Find pairs of sales in the same category on the same day to identify customers buying multiple items in a category on the same day.
SELECT 
    r1.transactions_id AS sale1_id,
    r2.transactions_id AS sale2_id,
    r1.category,
    r1.sale_date,
    r1.total_sale AS sale1_amount,
    r2.total_sale AS sale2_amount
FROM retail_sales r1
JOIN retail_sales r2
  ON r1.category = r2.category
  AND r1.sale_date = r2.sale_date
  AND r1.transactions_id <> r2.transactions_id;









 









