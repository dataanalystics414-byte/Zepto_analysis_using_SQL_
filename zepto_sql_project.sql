DROP TABLE IF EXISTS ZEPTO;

CREATE TABLE ZEPTO (
	SKU_ID SERIAL PRIMARY KEY,
	CATEGORY VARCHAR(120),
	NAME VARCHAR(150) NOT NULL,
	MRP NUMERIC(8, 2),
	DISCOUNTPERCENT NUMERIC(5, 2),
	AVAILABLEQUANTITY INTEGER,
	DISCOUNTEDSELLINGPRICE NUMERIC(8, 2),
	WEIGHTINGMS INTEGER,
	OUTOFSTOCK BOOLEAN,
	QUANTITY INTEGER
);

--data exploration
--count of rows
SELECT
	COUNT(*)
FROM
	ZEPTO;

--sample data
SELECT
	*
FROM
	ZEPTO
LIMIT
	10;

--null values
SELECT
	*
FROM
	ZEPTO
WHERE
	NAME IS NULL
	OR CATEGORY IS NULL
	OR MRP IS NULL
	OR DISCOUNTPERCENT IS NULL
	OR DISCOUNTEDSELLINGPRICE IS NULL
	OR WEIGHTINGMS IS NULL
	OR AVAILABLEQUANTITY IS NULL
	OR OUTOFSTOCK IS NULL
	OR QUANTITY IS NULL;

--different product categories
SELECT DISTINCT
	CATEGORY
FROM
	ZEPTO
ORDER BY
	CATEGORY;

--products in stock vs out of stock
SELECT
	OUTOFSTOCK,
	COUNT(SKU_ID)
FROM
	ZEPTO
GROUP BY
	OUTOFSTOCK;

--product names present multiple times
SELECT
	NAME,
	COUNT(SKU_ID) AS "Number of SKUs"
FROM
	ZEPTO
GROUP BY
	NAME
HAVING
	COUNT(SKU_ID) > 1
ORDER BY
	COUNT(SKU_ID) DESC;

--data cleaning
--products with price = 0
SELECT
	*
FROM
	ZEPTO
WHERE
	MRP = 0
	OR DISCOUNTEDSELLINGPRICE = 0;

--convert paise to rupees
UPDATE ZEPTO
SET
	MRP = MRP / 100.0,
	DISCOUNTEDSELLINGPRICE = DISCOUNTEDSELLINGPRICE / 100.0;

--data analysis
-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT
	NAME,
	MRP,
	DISCOUNTEDSELLINGPRICE
FROM
	ZEPTO
ORDER BY
	DISCOUNTEDSELLINGPRICE DESC
LIMIT
	10;

--Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT
	NAME,
	MRP,
	DISCOUNTEDSELLINGPRICE,
	OUTOFSTOCK
FROM
	ZEPTO
WHERE
	OUTOFSTOCK = 'True'
	AND MRP > 300
ORDER BY
	MRP DESC;

--Q3.Calculate Estimated Revenue for each category
SELECT
	CATEGORY,
	SUM(DISCOUNTEDSELLINGPRICE * AVAILABLEQUANTITY) AS CATEGORY_REVENUE
FROM
	ZEPTO
GROUP BY
	CATEGORY
ORDER BY
	SUM(DISCOUNTEDSELLINGPRICE * AVAILABLEQUANTITY) DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT
	NAME,
	MRP,
	DISCOUNTPERCENT
FROM
	ZEPTO
WHERE
	MRP > 500
	AND DISCOUNTPERCENT > 10
ORDER BY
	MRP DESC,
	DISCOUNTPERCENT DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT
	CATEGORY,
	AVG(DISCOUNTPERCENT) AS HIGHEST_AVG_DISCOUNT
FROM
	ZEPTO
GROUP BY
	CATEGORY
ORDER BY
	AVG(DISCOUNTPERCENT) DESC
LIMIT
	5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT
	NAME,
	WEIGHTINGMS,
	DISCOUNTEDSELLINGPRICE,
	ROUND(WEIGHTINGMS / DISCOUNTEDSELLINGPRICE, 2) AS PRICE_PER_GRAM
FROM
	ZEPTO
WHERE
	WEIGHTINGMS > 100
ORDER BY
	PRICE_PER_GRAM DESC;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT
	NAME,
	WEIGHTINGMS,
	CASE
		WHEN WEIGHTINGMS < 1000 THEN 'low'
		WHEN WEIGHTINGMS < 5000 THEN 'meadium'
		ELSE 'Bulk'
	END AS WEIGHT_CATEGORY
FROM
	ZEPTO;

--Q8.What is the Total Inventory Weight Per Category 
SELECT
	CATEGORY,
	SUM(WEIGHTINGMS * QUANTITY) AS CATEGORY_WEIGHT
FROM
	ZEPTO
GROUP BY
	CATEGORY
ORDER BY
	CATEGORY_WEIGHT DESC;

--9. Forecasting Inventory Depletion
-- Predict which products might go out of stock soon based on availableQuantity and quantity ordered.
SELECT
	NAME,
	AVAILABLEQUANTITY,
	QUANTITY,
	CASE
		WHEN QUANTITY = 0 THEN NULL
		ELSE ROUND(1.0 * AVAILABLEQUANTITY / QUANTITY, 1)
	END AS ESTIMATED_DAYS_LEFT
FROM
	ZEPTO
WHERE
	OUTOFSTOCK = FALSE
ORDER BY
	ESTIMATED_DAYS_LEFT ASC
LIMIT
	10;

--10. Revenue Loss Due to Out-of-Stock Products
--Total potential revenue missed.
SELECT SUM(discountedSellingPrice * quantity) AS estimated_lost_revenue
FROM zepto
WHERE outOfStock = 'true';


--11. Dead Stock Detection
--Products with stock but zero demand.
select name, category, availableQuantity,quantity 
from zepto 
where quantity = 0 and  availablequantity > 0 
order   by availableQuantity  desc;


--12. High-Weight, Low-Value Products
--For logistics optimization.
SELECT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice * 1.0 / weightInGms, 2) AS value_per_gram
FROM zepto
WHERE weightInGms > 500 AND discountedSellingPrice < 100
ORDER BY value_per_gram;

--13. Flag Suspicious Discounts
--Sometimes fake discount % is shown (e.g., MRP 5000, discount 90%, final price still ₹4500).
SELECT name, mrp, discountedSellingPrice, discountPercent
FROM zepto
WHERE ROUND((1 - discountedSellingPrice * 1.0 / mrp) * 100, 2) < discountPercent - 5;

--14. Calculate Discount Gap (Actual vs. Reported)
--Add a column to highlight where discount % is inaccurate.
SELECT name, mrp, discountedSellingPrice, discountPercent,
       ROUND((1 - discountedSellingPrice * 1.0 / mrp) * 100, 2) AS actual_discount,
       discountPercent - ROUND((1 - discountedSellingPrice * 1.0 / mrp) * 100, 2) AS discount_gap
FROM zepto
ORDER BY ABS(discountPercent - ROUND((1 - discountedSellingPrice * 1.0 / mrp) * 100, 2)) DESC
LIMIT 10;

--15. Compare Average Discounts Across Weight Categories
--Insights by ‘Low’, ‘Medium’, ‘Bulk’.
SELECT 
  CASE 
    WHEN weightInGms < 1000 THEN 'Low'
    WHEN weightInGms < 5000 THEN 'Medium'
    ELSE 'Bulk'
  END AS weight_category,
  ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY weight_category
ORDER BY avg_discount DESC;

--16. Revenue Contribution % per Category
--Helps identify which category is the biggest contributor to sales.
WITH total AS (
  SELECT SUM(discountedSellingPrice * availableQuantity) AS total_revenue
  FROM zepto
)
SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS category_revenue,
       ROUND(100.0 * SUM(discountedSellingPrice * availableQuantity) / t.total_revenue, 2) AS revenue_percent
FROM zepto, total t
GROUP BY category, t.total_revenue
ORDER BY revenue_percent DESC;

--17. Most Common Weights Sold
--Find popular product weights (e.g., 250g, 1kg, etc.) — useful for packaging and procurement.
WITH top_weights AS (
  SELECT weightInGms
  FROM zepto
  GROUP BY weightInGms
  ORDER BY COUNT(*) DESC
  LIMIT 10
)

SELECT z.weightInGms, z.name, z.category
FROM zepto z
JOIN top_weights tw ON z.weightInGms = tw.weightInGms
ORDER BY z.weightInGms;

 --18. Create a SKU Profitability Index
--Approximate profitability by considering price per gram and stock demand.
SELECT name, category,
       ROUND(discountedSellingPrice * 1.0 / weightInGms, 2) AS price_per_gram,
       quantity,
       ROUND((discountedSellingPrice * quantity) / weightInGms, 2) AS profit_index
FROM zepto
WHERE weightInGms IS NOT NULL AND weightInGms > 0
ORDER BY profit_index DESC
LIMIT 10;

--19. Flag Inventory Imbalance
--Too much stock with very low demand can be a waste.
SELECT name, category, availableQuantity, quantity,
       (availableQuantity - quantity) AS excess_stock
FROM zepto
WHERE quantity < 5 AND availableQuantity > 20
ORDER BY excess_stock DESC;

--20. Customer Pain Point Tracker
--Products ordered multiple times but often out of stock.
SELECT name, COUNT(*) AS out_of_stock_count
FROM zepto
WHERE outOfStock = TRUE AND quantity >= 2
GROUP BY name
ORDER BY out_of_stock_count DESC
LIMIT 10;

--21. Seasonal/Product Launch Planning (Assumption-Based)
--Flag products with high quantity and high MRP that are still in stock maybe they're not selling as expected:
SELECT name, category, mrp, quantity, availableQuantity
FROM zepto
WHERE availableQuantity > 100 AND quantity < 10 AND mrp > 300
ORDER BY mrp DESC;

--22. Category-Wise Inventory Turnover Ratio
--How fast inventory moves in each category:
WITH turnover AS (
  SELECT category,
         SUM(quantity)::NUMERIC / NULLIF(SUM(availableQuantity), 0) AS turnover_ratio,
         SUM(discountedSellingPrice * quantity) AS total_sales
  FROM zepto
  GROUP BY category
)
SELECT t.category, t.turnover_ratio, t.total_sales, z.name AS example_product
FROM turnover t
JOIN zepto z ON t.category = z.category
GROUP BY t.category, t.turnover_ratio, t.total_sales, z.name
ORDER BY t.turnover_ratio DESC
LIMIT 10;

--23. Time to Stock Out Simulation
--Assume fixed order rate to forecast which categories may deplete first.
SELECT category,
       ROUND(SUM(availableQuantity)::NUMERIC / NULLIF(SUM(quantity), 0), 1) AS days_to_stockout
FROM zepto
GROUP BY category
ORDER BY days_to_stockout;





















