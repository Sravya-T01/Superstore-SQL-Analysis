# Superstore-SQL-Analysis
This project involves a series of SQL queries designed to analyze the Superstore Orders dataset. The dataset includes details about orders, customers, products, and sales performance across various regions. The queries aim to provide insights into customer behavior, sales trends, and product performance.

## Queries Overview

1. Top 5 Customers by Profit
   - This query identifies the top 5 customers who generated the highest profit. It aggregates the total profit by each customer and ranks them accordingly.
  
2. Customer Segmentation Based on Sales and Profit
   - This query classifies customers into segments based on their total sales and profit. Customers are categorized into:
     - High Value: Customers with sales ≥ $10,000 and profit ≥ $2,000
     - Medium Value: Customers with sales ≥ $5,000 and profit ≥ $1,000
     - Low Value: Customers below the above thresholds

3. Total Sales of Each Product in Q1
   - This query calculates the total sales of each product in the first quarter of the year (January to March) across all regions.
  
4. Average Sales per Transaction by Region
   - This query calculates the average sales per transaction in each region, providing insights into sales performance on a per-transaction basis.


5. Top 5 Selling Products from Each Category
   - This query ranks the top 5 selling products within each category based on total sales.


6. Top 3 and Bottom 3 Products by Sales in Each Region
   - This query retrieves the top 3 and bottom 3 products by sales in each region, offering a comparison of high and low-performing products.


7. Highest Month-Over-Month Growth by Sub-Category (Jan 2020)
   - This query identifies the sub-category with the highest month-over-month growth by sales in January 2020 compared to the previous month.


8. Top 3 Products by Rolling 3-Month Sales (Jan 2020)
   - This query calculates the total sales of each product in the 3 months leading up to January 2020 and ranks the top 3 products by sales in January 2020.


9. Products with No Decline in Month-Over-Month Sales
    - This query identifies products for which month-over-month sales have never declined, showing consistent growth or stability.



## Files in the Repository

**SQL File**: Contains the SQL queries used for the analysis, which provide insights into customer behavior, sales, and product performance.
**CSV File**: Includes the cleaned Superstore Orders dataset used in the analysis.
**License File**: Specifies the license for the project.
