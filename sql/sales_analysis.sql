
BASIC DATA EXPLORATION


-- View all records
SELECT *
FROM public_order_details;

-- Count total rows
SELECT COUNT(*)
FROM public_order_details;

-- View distinct categories
SELECT DISTINCT category
FROM public_order_details;

-- Count distinct categories
SELECT COUNT(DISTINCT category)
FROM public_order_details;



 BASIC AGGREGATIONS


-- Total Sales
SELECT SUM(amount) AS total_sales
FROM public_order_details;

-- Total Profit
SELECT SUM(profit) AS total_profit
FROM public_order_details;

-- Total Quantity Sold
SELECT SUM(quantity) AS total_quantity
FROM public_order_details;

-- Average Sales Amount
SELECT ROUND(AVG(amount),2) AS average_sales
FROM public_order_details;

-- Maximum Sale
SELECT MAX(amount) AS highest_sale
FROM public_order_details;

-- Minimum Sale
SELECT MIN(amount) AS lowest_sale
FROM public_order_details;



 SALES BY CATEGORY


SELECT
    category,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM public_order_details
GROUP BY category
ORDER BY total_sales DESC;



MONTHLY SALES PERFORMANCE


SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(od.amount) AS total_sales,
    SUM(od.profit) AS total_profit,
    SUM(od.quantity) AS total_quantity
FROM public_orders o
JOIN public_order_details od
    ON o.order_id = od.order_id
GROUP BY 1
ORDER BY 1;



 TOP CUSTOMERS


SELECT
    o.customer_name,
    SUM(od.amount) AS total_sales
FROM public_orders o
JOIN public_order_details od
    ON o.order_id = od.order_id
GROUP BY o.customer_name
ORDER BY total_sales DESC
LIMIT 5;



CUSTOMER SEGMENTATION


SELECT
    o.customer_name,
    SUM(od.amount) AS total_sales,
    CASE
        WHEN SUM(od.amount) >= 10000 THEN 'VIP'
        WHEN SUM(od.amount) >= 5000 THEN 'Regular'
        ELSE 'Small'
    END AS customer_segment
FROM public_orders o
JOIN public_order_details od
    ON o.order_id = od.order_id
GROUP BY o.customer_name
ORDER BY total_sales DESC;


 PROFITABILITY ANALYSIS


SELECT
    category,
    ROUND(AVG(profit),2) AS average_profit,
    SUM(profit) AS total_profit
FROM public_order_details
GROUP BY category
ORDER BY total_profit DESC;



 HAVING CLAUSE


SELECT
    category,
    SUM(amount) AS total_sales
FROM public_order_details
GROUP BY category
HAVING SUM(amount) > 100000
ORDER BY total_sales DESC;



CASE WHEN


SELECT
    category,
    amount,
    CASE
        WHEN profit > 0 THEN 'Profitable'
        ELSE 'Loss-Making'
    END AS profit_status
FROM public_order_details;



WINDOW FUNCTION - RANK


SELECT
    category,
    SUM(amount) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(amount) DESC
    ) AS sales_rank
FROM public_order_details
GROUP BY category;



WINDOW FUNCTION - DENSE_RANK


SELECT
    category,
    SUM(amount) AS total_sales,
    DENSE_RANK() OVER (
        ORDER BY SUM(amount) DESC
    ) AS sales_rank
FROM public_order_details
GROUP BY category;



CTE


WITH category_sales AS (
    SELECT
        category,
        SUM(amount) AS total_sales
    FROM public_order_details
    GROUP BY category
)
SELECT *
FROM category_sales
ORDER BY total_sales DESC;



RUNNING TOTAL


SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(od.amount) AS monthly_sales,
    SUM(SUM(od.amount))
        OVER (
            ORDER BY DATE_TRUNC('month', o.order_date)
        ) AS running_total
FROM public_orders o
JOIN public_order_details od
    ON o.order_id = od.order_id
GROUP BY 1
ORDER BY 1;



SALES TARGET ANALYSIS


SELECT
    month_of_order_date,
    SUM(target) AS total_target
FROM public_sales_target
GROUP BY month_of_order_date
ORDER BY month_of_order_date;



 DASHBOARD KPI QUERY


SELECT
    ROUND(SUM(amount),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders
FROM public_order_details;
