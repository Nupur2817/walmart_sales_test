use walmart_db;

--  Business Problems

-- Project Question#1 Find different payment method and number of transactions, number of qty sold

SELECT 
    payment_method,
    COUNT(*) AS no_of_transactions,
    SUM(quantity) AS no_of_qtysold
FROM
    walmart
GROUP BY payment_method;


-- Project Question #2
-- Identify the highest-rated category in each branch, displaying the branch, category
-- AVG RATING

SELECT 
    branch, category, AVG(rating) AS avg_rating
FROM
    walmart
GROUP BY branch , category;


-- Q.3 Identify the busiest day for each branch based on the number of transactions

SELECT 
    branch,
    DAYNAME(STR_TO_DATE(`date`, '%d/%m/%y')) AS day_name,
    COUNT(*) AS no_transactions
FROM walmart
GROUP BY branch, day_name
ORDER BY branch, no_transactions desc;

-- Q. 4 
-- Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.


SELECT 
    payment_method,
    COUNT(*) AS no_of_transactions,
    SUM(quantity) AS no_of_qtysold
FROM
    walmart
GROUP BY payment_method;


-- Q.5
-- Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_rating.


SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM
    walmart
GROUP BY city , category;


-- Q.6
-- Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.

SELECT 
    category,
    SUM(total) AS total_revenue,
    SUM(total * profit_margin) AS total_profit
FROM
    walmart
GROUP BY category;


-- Q.7
-- Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

with cte
as 
(select branch,
payment_method,
count(*) as total_trans
from walmart
group by branch,payment_method) 
select * from cte;


-- Q.8
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

select * from walmart ;

select convert (time,TIME)
from walmart;

SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;


-- Q9: Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)

WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    r2022.branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;
