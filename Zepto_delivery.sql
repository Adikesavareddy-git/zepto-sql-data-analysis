select *from ZeptoDelivery


--data exploration

--count of rows
select count(*) from ZeptoDelivery;

--sample data
SELECT TOP 10 *  FROM ZeptoDelivery


--null values
SELECT * FROM ZeptoDelivery
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;


--different product categories
SELECT DISTINCT category
FROM ZeptoDelivery
ORDER BY category;


--products in stock vs out of stock
SELECT outOfStock, COUNT(Category) as Available 
FROM ZeptoDelivery
GROUP BY outOfStock;

--product names present multiple times 
select name, COUNT(Category) As "Nmber of Category"
from ZeptoDelivery
Group BY name
Having count(Category) > 1
Order by COUNT(Category) DESC

--data cleaning

--products with price = 0
SELECT * FROM ZeptoDelivery
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM ZeptoDelivery
WHERE mrp = 0;

--convert paise to rupees
UPDATE ZeptoDelivery
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM ZeptoDelivery;

--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT  DISTINCT  top 10 name, mrp, discountPercent
FROM ZeptoDelivery
ORDER BY discountPercent DESC;

--Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name,mrp
FROM ZeptoDelivery
WHERE outOfStock = 1 and mrp > 300
ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM ZeptoDelivery
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM ZeptoDelivery
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT top 5 category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM ZeptoDelivery
GROUP BY category
ORDER BY avg_discount DESC

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM ZeptoDelivery
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM ZeptoDelivery;

-- Q8. Total Inventory Weight Per Category

SELECT
    category,
    CAST(
        SUM(
            CAST(weightInGms AS BIGINT) *
            CAST(availableQuantity AS BIGINT)
        ) / 1000.0
        AS DECIMAL(12,2)
    ) AS total_weight_kg
FROM ZeptoDelivery
GROUP BY category
ORDER BY total_weight_kg DESC;