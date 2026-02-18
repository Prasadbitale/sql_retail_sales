# Retail Sales Analysis SQL Project

## Project Overview

This project demonstrates SQL techniques for analyzing retail sales data. It covers database setup, data cleaning, exploratory analysis, and business-driven insights using SQL queries. The project provides actionable insights on sales trends, customer behavior, and product performance.

---

## Objectives

- Create and populate a retail sales database  
- Perform data cleaning to handle missing or null values  
- Conduct exploratory data analysis (EDA)  
- Answer business questions to extract insights  

---

## Database Structure

### retail_sales Table

| Column | Data Type | Description |
|--------|----------|-------------|
| transactions_id | INT | Unique transaction ID |
| sale_date | DATE | Date of transaction |
| sale_time | TIME | Time of transaction |
| customer_id | INT | Customer ID |
| gender | VARCHAR(15) | Customer gender |
| age | INT | Customer age |
| category | VARCHAR(15) | Product category |
| quantiy | INT | Quantity sold |
| price_per_unit | FLOAT | Price per unit |
| cogs | FLOAT | Cost of goods sold |
| total_sale | FLOAT | Total sale amount |

### category_info Table

| Column | Data Type | Description |
|--------|----------|-------------|
| category | VARCHAR(15) | Product category |
| manager | VARCHAR(50) | Category manager |
| discount_percent | FLOAT | Discount percentage |

---

## Key SQL Queries & Analysis

**Retrieve sales on a specific date**
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND quantiy > 2
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


**Total sales and order count by category**
SELECT category, SUM(total_sale) AS total_sales, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;


**Average age of Beauty category customers**
SELECT AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


**Transactions above 1000**
SELECT * FROM retail_sales
WHERE total_sale > 1000;


**Transactions by gender & category**
SELECT category, gender, COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY category, gender;


**Best selling month per year**
SELECT sale_year, sale_month, avg_sale
FROM (
SELECT YEAR(sale_date) AS sale_year,
MONTH(sale_date) AS sale_month,
ROUND(AVG(total_sale)) AS avg_sale,
RANK() OVER(PARTITION BY YEAR(sale_date)
ORDER BY AVG(total_sale) DESC) AS rn
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
) t
WHERE rn = 1;


**Top 5 customers by total sales**
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


**Unique customers per category**
SELECT category, COUNT(DISTINCT customer_id) AS customer_count
FROM retail_sales
GROUP BY category;


**Shift-based order classification**
SELECT *,
CASE
WHEN HOUR(sale_time) < 12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
FROM retail_sales;


**Join sales with category information**
SELECT r.transactions_id, r.sale_date, r.category, r.total_sale,
c.manager, c.discount_percent
FROM retail_sales r
INNER JOIN category_info c
ON r.category = c.category;


**Multiple purchases in the same category & day**
SELECT r1.transactions_id AS sale1_id,
r2.transactions_id AS sale2_id,
r1.category,
r1.sale_date
FROM retail_sales r1
JOIN retail_sales r2
ON r1.category = r2.category
AND r1.sale_date = r2.sale_date
AND r1.transactions_id <> r2.transactions_id;


---

## Key Insights

- Sales occur across diverse customer demographics.  
- High-value transactions indicate premium purchase patterns.  
- Monthly and shift analysis reveals peak sales periods.  
- Top customers and high-performing categories are identifiable.  

---

## Usage

1. Clone the repository  
2. Run the SQL scripts to create and populate the database  
3. Execute queries to explore insights  
4. Modify queries for further analysis  

---

## Author

**Prasad Bitale**  
SQL & Data Analytics Portfolio

LinkedIn: https://www.linkedin.com/in/prasad-bitale







