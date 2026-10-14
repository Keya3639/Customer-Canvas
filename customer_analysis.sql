
-- 1. Monthly Revenue
SELECT
    DATE_TRUNC('month', invoicedate)::DATE AS month,
    ROUND(SUM(totalsales), 2) AS monthly_revenue
FROM customer_transactions
GROUP BY DATE_TRUNC('month', invoicedate)
ORDER BY month;


-- 2. Top 10 Customers by Revenue
SELECT
    customerid,
    ROUND(SUM(totalsales), 2) AS total_revenue,
    COUNT(DISTINCT invoiceno) AS total_orders
FROM customer_transactions
WHERE customerid IS NOT NULL
GROUP BY customerid
ORDER BY total_revenue DESC
LIMIT 10;


-- 3. Repeat vs One-time Customers
WITH customer_orders AS (
    SELECT
        customerid,
        COUNT(DISTINCT invoiceno) AS total_orders,
        SUM(totalsales) AS total_spent
    FROM customer_transactions
    WHERE customerid IS NOT NULL
    GROUP BY customerid
)
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-time Customers'
        ELSE 'Repeat Customers'
    END AS customer_type,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_orders), 2) AS avg_orders,
    ROUND(SUM(total_spent), 2) AS total_revenue
FROM customer_orders
GROUP BY customer_type
ORDER BY customer_count DESC;


-- 4. Top 10 Products by Revenue
SELECT
    stockcode,
    MAX(description) AS product_name,
    SUM(quantity) AS units_sold,
    ROUND(SUM(totalsales), 2) AS total_revenue
FROM customer_transactions
WHERE stockcode IS NOT NULL
  AND stockcode <> 'POST'
GROUP BY stockcode
HAVING SUM(quantity) > 0
ORDER BY total_revenue DESC
LIMIT 10;



