create table Amazon_Sale(
index int,
Order_ID VARCHAR(50),
Date DATE,
Status VARCHAR(50),
Fulfilment VARCHAR(50)	,
Sales_Channel VARCHAR(50),
ship_service_level VARCHAR(50),
Category VARCHAR(50)	,
Courier_Status VARCHAR(50),
Qty INT,
Amount NUMERIC(8,2),
ship_city VARCHAR(50),
ship_state VARCHAR(50),
B2B BOOLEAN,
fulfilled_by VARCHAR(50)

)


select * 
from Amazon_sale;


-- Finding dublicate order id

select Order_ID, COUNT(*)
FROM Amazon_sale
GROUP BY Order_ID
HAVING COUNT(*)>1
ORDER BY COUNT(*) DESC;

----   Finding the null value

SELECT
    COUNT(*) - COUNT(order_id) AS missing_order_id,
    COUNT(*) - COUNT(date) AS missing_date,
    COUNT(*) - COUNT(status) AS missing_status,
    COUNT(*) - COUNT(category) AS missing_category,
    COUNT(*) - COUNT(amount) AS missing_amount
FROM amazon_sale;

-- Finding why Null Values in Amount

select status, amount
from Amazon_sale
where amount is null;


---- Finding Any Negatuve Value In Amount

SELECT * 
from Amazon_sale
where amount <0;


---- CHecking is their spelling mistake in status

select distinct status
from Amazon_sale
order by status;

---------------- Bsuiness Insights


-- 1 Total Revenue Generated

select sum(qty*amount) as Total_Revenue
from amazon_sale;


-- 2 Finding monthly sales trend , which month performed best

select date_trunc('month',date) as month,
       sum(qty*amount) as Total_Revenue
from amazon_sale
group by month
order by month;


-- 3 Top category by revenues

select category, sum(qty*amount) as Total_Revenue
from amazon_sale
group by category
order by Total_Revenue desc ;


-- 4 Order satatus distribution

select status, count(*) 
from Amazon_sale
group by status
order by count(*) desc;

-- 5 Order Cancellation rate
select 
round(
      count(CASE WHEN status = 'Cancelled' THEN 1 END )*100.0/COUNT(*),
	  2
) AS CANCELLATION_RATE
from Amazon_sale;


-- 6 CANCELLATION RATE BY CATEGORY

SELECT category,
round(
         count(CASE WHEN status = 'Cancelled' THEN 1 END )*100.0/COUNT(*),
         2
) AS CANCELLATION_RATE
FROM Amazon_Sale
GROUP BY category
ORDER BY CANCELLATION_RATE DESC;

-- 7 B2B VS B2C REVENUE

SELECT B2B,
       sum(qty*amount) as Total_Revenue
FROM Amazon_sale
GROUP BY B2B;

-- 8 MOST RETURNED CATEGORY

SELECT category,
       COUNT(*) AS returned_count
FROM Amazon_sale
WHERE status IN ('Returning', 'Returned')
GROUP BY category
ORDER BY returned_count DESC;

-- 9 REVENUE SHARE BY CATEGORY

SELECT category,
       ROUND(
             SUM(qty*amount)*100.0
             /SUM(qty*amount) OVER(),
             2
       ) AS REVENUE_SHARE
FROM Amazon_sale
GROUP BY category
ORDER BY REVENUE_SHARE DESC;


---- 10 TOP 3 STATE BY REVENUE and rank

select ship_state, sum(qty*amount) AS TOTAL_REVENUE
from Amazon_sale
WHERE amount IS NOT NULL
GROUP BY ship_state
ORDER BY TOTAL_REVENUE DESC
LIMIT 3;
