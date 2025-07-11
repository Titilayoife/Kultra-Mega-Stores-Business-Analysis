CREATE DATABASE KMS
USE KMS

SELECT * FROM KMS_Sql_Case_Study

---Question 1---
---Product Category with the highest Sales---
SELECT TOP 10 Product_Category, Sales
FROM KMS_Sql_Case_Study
ORDER BY Sales DESC
;

---Question 2---
---Top 3 and Bottom 3 regions in terms of Sales---
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

--Question 3--
---Total Sales of appliances in Ontario---
Select SUM(Sales) as Total_Sales
FROM KMS_Sql_Case_Study
WHERE Product_Sub_Category = 'Appliances' and Province = 'Ontario'
;

---Question 4---
--- Bottom 10 Revenue---
SELECT TOP 10 
    Customer_Name, 
    Customer_Segment, 
    Product_Category,
    SUM(Order_Quantity * Unit_Price) AS Revenue
FROM KMS_Sql_Case_Study
GROUP BY Customer_Name, Customer_Segment, Product_Category
ORDER BY Revenue ASC;
/* Business Recommendations
- Target low spenders in Home Office and Consumer segments with offers and bundles.
- Encourage furniture purchases with payment plans and promotions.
- Increase office supply sales with combo deals and bulk discounts.
- Learn from top customers — replicate their buying patterns with others.
- Cut shipping cost issues by offering free shipping over a set amount or using cheaper delivery services.
*/

---Question 5---
--- The most expensive shipping method---
SELECT TOP 1  Ship_Mode, Shipping_Cost
FROM KMS_Sql_Case_Study
ORDER BY Shipping_Cost DESC
;

---Question 6---
--- Valuable customers and products/services they typically purchase---
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

---Question 7---
--- Small Business Customer with the highest Sales---
SELECT TOP 1 Customer_Name, Customer_Segment, Sales
FROM KMS_Sql_Case_Study
WHERE Customer_Segment = 'Small Business'
ORDER BY Sales DESC
;

---Question 8---
---Corporate with the most order between 2009 - 2012---
SELECT TOP 1 Order_ID, Order_Date, Order_Quantity, Customer_Name, Customer_Segment, Product_Category
FROM KMS_Sql_Case_Study
WHERE Customer_Segment = 'Corporate' and Order_Date between '2009' and '2012'
ORDER BY Order_Quantity DESC
;

---Question 9---
---Most Profitable consumer customer--
SELECT TOP 1 Customer_Name, Customer_Segment, Profit
FROM KMS_Sql_Case_Study
WHERE Customer_Segment = 'Consumer'
ORDER BY Profit DESC
;

---Question 10---
--- Customer who returned items and the segment they belong to---
SELECT Customer_Name, Customer_Segment, 
Product_Category, Product_Name
FROM  KMS_Sql_Case_Study
JOIN Order_Status 
on dbo. KMS_Sql_Case_Study.Order_ID = dbo.Order_Status.Order_ID
;

---Question 11---
---Shipping Costs based on the Order Priority---
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

 /* Shipping Cost Logic Review Based on Order Priority

Business Rule:
- Delivery Truck = slowest but cheapest
- Express Air = fastest but most expensive

Analysis Summary:
- Critical orders were sometimes shipped using Delivery Truck (slowest), which could delay urgent deliveries.
- Medium and Low priority orders used Express Air in several cases — too fast and expensive for non-urgent needs.
- Delivery Truck was used across all priority levels, which is not suitable for time-sensitive orders.

Conclusion:
No, the company didn’t always spend shipping money wisely.
Critical and High priority orders were sometimes shipped with slow, cheap methods, which could lead to late deliveries.
At the same time, some Medium and Low priority orders used fast, expensive shipping which to me is not necessary and costly

Recommendation:
Implement shipping rules that align shipping mode with order urgency to reduce cost and improve delivery satisfaction.
*/

