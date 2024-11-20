CREATE DATABASE IF NOT EXISTS walmaartsales;

CREATE TABLE IF NOT EXISTS sales (
  invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
  branch VARCHAR(5) NOT NULL,
  city VARCHAR(30) NOT NULL,
  customer_type VARCHAR(30) NOT NULL,
  gender VARCHAR(10) NOT NULL,
  product_line VARCHAR(100) NOT NULL,
  unit_price DECIMAL (10,2) NOT NULL,
  quantity INT NOT NULL,
  vat FLOAT (6,4) NOT NULL,
  total DECIMAL (12,4) NOT NULL,
  date DATETIME NOT NULL,
  time TIME NOT NULL,
  payment_method VARCHAR(15) NOT NULL,
  cogs decimal ( 10,2) NOT NULL,
  gross_margin_percentage FLOAT (11,9) NOT NULL,
  gross_income DECIMAL ( 12,4) NOT NULL,
  rating FLOAT (2,1) NOT NULL
  
);

-- ------------------------------------------------------------- Feature Engineering --
-- time_of_day

SELECT 
	time,
    (CASE
         WHEN `time`BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
         WHEN `time`BETWEEN "12:00:00" AND "16:00:00" THEN "Afternoon"
         ELSE "Evining"
	 END
    ) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR (20);

UPDATE sales
SET time_of_day = (
    CASE
         WHEN `time`BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
         WHEN `time`BETWEEN "12:00:00" AND "16:00:00" THEN "Afternoon"
         ELSE "Evining"
    END
);

-- day_name --

SELECT date, 
DAYNAME (date) FROM sales;

ALTER TABLE sales 
ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name --

SELECT date,
MONTHNAME(date) FROM sales;

ALTER TABLE sales 
ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- Generic --
-- how many unique cities and Brances does the data have?

SELECT DISTINCT 
	   city FROM sales;

SELECT DISTINCT 
	   branch FROM sales;

-- In which cities are branches located
SELECT DISTINCT 
	   city, branch FROM sales;

-- ------------- Product -------------------------
-- How Many unique product lines does the data have?

SELECT 
COUNT(DISTINCT product_line) FROM sales;

-- what is the most common payment method ?

SELECT payment_method,
   COUNT(payment_method)AS CNT
FROM sales 
GROUP BY payment_method
ORDER BY CNT DESC;

-- What is the most selling product line?
SELECT product_line,
   COUNT(product_line)AS CNT
FROM sales 
GROUP BY product_line
ORDER BY CNT DESC;

-- what is the total revenue by month?

SELECT
    month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue DESC;

-- What month had the largest COGS (cost of goods sold) ------

SELECT
    month_name AS month,
    SUM(COGS) AS COGS
FROM sales
GROUP BY month_name 
ORDER BY COGS DESC;
