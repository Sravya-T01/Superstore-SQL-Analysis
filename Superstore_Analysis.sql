-- 1. Find the top 5 customers who generated the most profit, including the profit they contributed.
WITH Customer_Profit AS (
    SELECT 
        Customer_ID, Customer_name,
        SUM(Profit) AS Total_Profit
    FROM Superstore_orders
    GROUP BY Customer_ID, Customer_name
)
SELECT TOP 5 
    Customer_ID, Customer_name,
    Total_Profit
FROM Customer_Profit
ORDER BY Total_Profit DESC;

-- 2. Classify customers into segments based on their total sales and profit.
WITH Customer_Segment AS (
    SELECT 
        Customer_ID, 
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit
    FROM Superstore_orders
    GROUP BY Customer_ID
)
SELECT 
    Customer_ID,
    CASE 
        WHEN Total_Sales >= 10000 AND Total_Profit >= 2000 THEN 'High Value'
        WHEN Total_Sales >= 5000 AND Total_Profit >= 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM Customer_Segment;

-- 3. Find the total sales of each product in the first quarter (Q1: Jan-Mar) across all regions.
WITH Q1_Sales AS (
    SELECT 
        Region,
        Product_ID,
        Product_Name,
        SUM(Sales) AS Total_Sales
    FROM Superstore_orders
    WHERE MONTH(Order_Date) BETWEEN 1 AND 3
    GROUP BY Region, Product_ID, Product_Name
)
SELECT 
    Region, 
    Product_ID,
    Product_Name,
    Total_Sales
FROM Q1_Sales
ORDER BY Total_Sales DESC;

-- 4. Calculate the average sales per transaction in each region.
WITH Region_Transaction_Count AS (
    SELECT 
        Region, 
        COUNT(*) AS Transaction_Count,
        SUM(Sales) AS Total_Sales
    FROM Superstore_orders
    GROUP BY Region
)
SELECT 
    Region,
    Total_Sales / Transaction_Count AS Average_Sales_Per_Transaction
FROM Region_Transaction_Count
ORDER BY Average_Sales_Per_Transaction DESC;


-- 5.Print top 5 selling products from each category

WITH RankedProducts AS (
    SELECT 
        Category,
        Product_Name,
        SUM(Sales) AS Total_Sales,
        RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS Rank_in_Category
    FROM Superstore_orders
    GROUP BY Category, Product_Name
)
SELECT 
    Category,
    Product_Name,
    Total_Sales,
    Rank_in_Category
FROM RankedProducts
WHERE Rank_in_Category <= 5
ORDER BY Category, Rank_in_Category;

-- 6. write a query to find top 3 and bottom 3 products by sales in each region.

with sales_agg as (
    SELECT
           region,
           product_name,
           sum(sales) as total_sales
    FROM Superstore_orders
    GROUP BY Region, Product_Name
)
,
product_sales as(
    SELECT *,
    DENSE_RANK() OVER(partition by region order by total_sales desc) as top_selling,
    dense_rank() OVER(partition by region order by total_sales asc) as bottom_selling
    from sales_agg
)

select region, product_name,total_sales,
CASE 
        WHEN top_selling <= 3 THEN 'Top Selling'
        WHEN bottom_selling <= 3 THEN 'Bottom Selling'
    END AS sales_category
from product_sales
where top_selling <=3 or bottom_selling<=3
order by region, top_selling;

-- 7. Among all the sub categories which sub category had highest month over month growth by sales in Jan 2020.

with subc as(
    SELECT Sub_Category,     
    CONCAT(YEAR(Order_Date), '-', RIGHT('0' + CAST(MONTH(Order_Date) AS VARCHAR), 2)) AS Year_Month,
    SUM(sales) as sales 
    FROM Superstore_orders
    GROUP BY
        Sub_Category,
        CONCAT(YEAR(Order_Date), '-', RIGHT('0' + CAST(MONTH(Order_Date) AS VARCHAR), 2))

)
, prev_month_sales AS (
    SELECT *, LAG(sales) OVER(partition by sub_category order by Year_Month) as prev_sales
    FROM subc
)

SELECT top 1 *,
    (sales - prev_sales)/prev_sales as mom_growth
FROM prev_month_sales
WHERE year_month = '2020-01'
ORDER BY mom_growth DESC

-- 8. write a sql to find top 3 products in each category by highest rolling 3 months total sales for Jan 2020

WITH RollingSales AS (
    SELECT 
        Category,
        product_ID,
        DATEPART(year, Order_Date) AS order_year,
        DATEPART(month, Order_Date) AS order_month,
        SUM(sales) AS total_sales
    FROM Superstore_orders
    WHERE Order_Date BETWEEN '2019-11-01' AND '2020-01-31'  -- Rolling 3 months (Nov, Dec, Jan)
    GROUP BY Category, product_ID, DATEPART(year, Order_Date), DATEPART(month, Order_Date)
),
RankedProducts AS (
    SELECT 
        Category,
        product_ID,
        total_sales,
        RANK() OVER (PARTITION BY Category ORDER BY total_sales DESC) AS rank
    FROM RollingSales
    WHERE order_year = 2020 AND order_month = 1  -- Only considering January 2020
)
SELECT Category, product_ID, total_sales
FROM RankedProducts
WHERE rank <= 3
ORDER BY Category, rank;
-- 9. write a query to find products for which month over month sales has never declined.

WITH MonthlySales AS (
    SELECT 
        product_ID,
        DATEPART(year, Order_Date) AS year,
        DATEPART(month, Order_Date) AS month,
        SUM(sales) AS total_sales
    FROM Superstore_orders
    GROUP BY product_ID, DATEPART(year, Order_Date), DATEPART(month, Order_Date)
),
SalesComparison AS (
    SELECT 
        product_ID,
        year,
        month,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY product_ID ORDER BY year, month) AS prev_month_sales
    FROM MonthlySales
)
SELECT DISTINCT product_ID
FROM SalesComparison
WHERE prev_month_sales IS NULL OR total_sales >= prev_month_sales
GROUP BY product_ID
HAVING COUNT(*) = COUNT(CASE WHEN prev_month_sales IS NULL OR total_sales >= prev_month_sales THEN 1 END);
