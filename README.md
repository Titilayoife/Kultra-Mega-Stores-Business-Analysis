# 🧾 KMS SQL Case Study – Amazon Product Data Analysis

This project contains a series of SQL queries used to analyze product sales, customer behavior, shipping costs, and profitability using a sample dataset from an Amazon-like business (KMS). The goal is to uncover insights that can guide business decisions such as boosting revenue, reducing shipping costs, and identifying valuable customers.

---

## 📌 Business Goals Covered

- Identify top-selling product categories
- Find the most valuable customers and what they buy
- Understand low-revenue customer segments
- Review how shipping choices affect cost and urgency
- Highlight opportunities to increase revenue through smarter strategies

---

## 🧮 Questions 

1. Which product category has the highest sales?
2. What are the top 3 and bottom 3 regions by sales?
3. What is the total sales of appliances in Ontario?
4. Who are the bottom 10 customers by revenue?
5. What is the most expensive shipping method?
6. Who are the top 10 customers, and what categories do they buy?
7. Which small business customer spends the most?
8. Which corporate customer made the most orders between 2009–2012?
9. Who is the most profitable consumer customer?
10. Which customers returned products, and what are their segments?
11. Is shipping mode being used appropriately based on order priority?

---

## Answers
CREATE DATABASE KMS
USE KMS

SELECT * FROM KMS_Sql_Case_Study


**Question 1**

**Product Category with the highest Sales**

SELECT TOP 10 Product_Category, Sales
FROM KMS_Sql_Case_Study
ORDER BY Sales DESC
;


**Question 2**

**Top 3 and Bottom 3 regions in terms of Sales**

SELECT Region, Sales
FROM 
(
    SELECT TOP 3 Region, Sales
    FROM KMS_Sql_Case_Study
    ORDER BY Sales DESC
) AS Top3

UNION ALL

SELECT Region, Sales
FROM 
(
    SELECT TOP 3 Region, Sales
    FROM KMS_Sql_Case_Study
    ORDER BY sales ASC
) AS Bottom3;


**Question 3**

**Total Sales of appliances in Ontario**

SELECT SUM(Sales) as Total_Sales
FROM KMS_Sql_Case_Study
WHERE Product_Sub_Category = 'Appliances' and Province = 'Ontario'
;


**Question 4**

**Bottom 10 Revenue**

SELECT TOP 10 
    Customer_Name, 
    Customer_Segment, 
    Product_Category,
    SUM(Order_Quantity * Unit_Price) AS Revenue
FROM KMS_Sql_Case_Study
GROUP BY Customer_Name, Customer_Segment, Product_Category
ORDER BY Revenue ASC;

**How can the management increase botton revenue?**

- By Targeting low spenders in Home Office and Consumer segments with offers and bundles.
- Encouraging furniture purchases with payment plans and promotions.
- Increasing office supply sales with combo deals and bulk discounts.
- Learning buying patterns from top customers and replicating them.
- Cutting shipping cost issues by offering free shipping over a set amount or using cheaper delivery services.


**Question 5**

**The most expensive shipping method**

SELECT TOP 1  Ship_Mode, Shipping_Cost
FROM KMS_Sql_Case_Study
ORDER BY Shipping_Cost DESC
;


**Question 6**

**Valuable customers and products/services they typically purchase**

WITH Customer_Sales AS (
    SELECT 
        TRIM(UPPER([Customer_Name])) AS Customer_Name, 
        SUM([Sales]) AS Total_Sales
    FROM KMS_Sql_Case_Study
    GROUP BY TRIM(UPPER([Customer_Name]))
),

Top_Customers AS (
    SELECT TOP 10 Customer_Name, Total_Sales
    FROM Customer_Sales
    ORDER BY Total_Sales DESC
),

Customer_Category_Sales AS (
    SELECT 
        TRIM(UPPER(o.[Customer_Name])) AS Customer_Name, 
        o.[Product_Category],
        SUM(o.[Sales]) AS Category_Sales
    FROM KMS_Sql_Case_Study AS o
    JOIN Top_Customers AS tc
        ON TRIM(UPPER(o.[Customer_Name])) = tc.Customer_Name
    GROUP BY TRIM(UPPER(o.[Customer_Name])), o.[Product_Category]
)

SELECT 
    ccs.Customer_Name,
    ccs.Product_Category,
    ccs.Category_Sales
FROM Customer_Category_Sales AS ccs
ORDER BY ccs.Category_Sales DESC
;


**Question 7**

**Small Business Customer with the highest Sales**

SELECT TOP 1 Customer_Name, Customer_Segment, Sales
FROM KMS_Sql_Case_Study
WHERE Customer_Segment = 'Small Business'
ORDER BY Sales DESC
;


**Question 8**

**Corporate with the most order between 2009 - 2012**

SELECT TOP 1 Order_ID, Order_Date, Order_Quantity, Customer_Name, Customer_Segment, Product_Category
FROM KMS_Sql_Case_Study
WHERE Customer_Segment = 'Corporate' and Order_Date between '2009' and '2012'
ORDER BY Order_Quantity DESC
;


**Question 9**

**Most Profitable consumer customer**

SELECT TOP 1 Customer_Name, Customer_Segment, Profit
FROM KMS_Sql_Case_Study
WHERE Customer_Segment = 'Consumer'
ORDER BY Profit DESC
;


**Question 10**

**Customer who returned items and the segment they belong to**

SELECT Customer_Name, Customer_Segment, 
Product_Category, Product_Name
FROM  KMS_Sql_Case_Study
JOIN Order_Status 
on dbo. KMS_Sql_Case_Study.Order_ID = dbo.Order_Status.Order_ID
;


**Question 11**

**Shipping Costs based on the Order Priority**

SELECT (Order_Priority), (Ship_Mode),
Count (*) AS Number_Of_Orders,
SUM(Shipping_Cost) AS Total_Shipping_Cost,
AVG(Shipping_Cost) AS Avg_Shipping_Cost
FROM KMS_Sql_Case_Study
GROUP BY (Order_Priority),(Ship_Mode)
ORDER BY 
CASE (Order_Priority)
  WHEN 'Critical' THEN 1
  WHEN 'High' THEN 2
  WHEN 'Medium' THEN 3
  WHEN 'Low' THEN 4
  ELSE 5
 END,
 Ship_Mode; 

---

## 💡 Sample Insights

### 📦 Low Revenue Customers
- Most of them belong to the **Home Office** or **Consumer** segments
- Furniture and Office Supplies appeared frequently in low-revenue combinations

**Business Recommendation:**
- Offer bundles and discounts to these segments
- Promote furniture sales with installment plans and better ads
- Upsell office supplies with combo deals

---

## 🚚 Shipping Strategy: Was It Used Correctly?

This section reviews whether the company spent shipping costs appropriately based on order priority.

**Business Rule:**
- **Delivery Truck** = slowest but cheapest  
- **Express Air** = fastest but most expensive

**What We Found:**
- Critical orders sometimes used the slowest (Delivery Truck) which can cause delays
- Low-priority orders used Express Air which according to the business rule is expensive and highly unnecessary
- Shipping choices don’t always match urgency

**Recommendation:**
- Use fast shipping (Express Air) only for critical orders
- Use cheaper options (Delivery Truck or Regular Air) for low/medium priorities
- Set rules to match shipping with urgency to control costs and improve delivery timing

---

## 🛠️ Tools Used

- SQL Server
- Common Table Expressions (CTEs)
- Aggregation (`SUM`, `AVG`, `COUNT`)
- Filtering and sorting
- Joins and grouping
- CASE statements

---

## 👤 Author

**Oyegunwa Titilayo**  
Finance & Data Analysis Enthusiast  

> *This project shows how SQL can turn raw business data into clear insights and actionable advice.*
