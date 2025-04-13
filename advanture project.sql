--                       AVANTURE WORKS                        --
# 1.total sales 
select concat("$ ", round(sum((UnitPrice * OrderQuantity) - DiscountAmount) / 1000000,2)," M") as Total_sales from sales;


# 2. TOTAL COST
    SELECT CONCAT("$ ",ROUND(SUM(ProductStandardCost/1000000),2)," M")AS TOTAL_COST FROM SALES;
    
# 3.TOTAL PROFIT
 SELECT CONCAT("$ ",ROUND((sum((UnitPrice * OrderQuantity) - DiscountAmount) - SUM(ProductStandardCost))/1000000,2)," M") AS TOTAL_PROFIT
 FROM SALES;
 
 # 4.TOTAL PRODUCT 
 select COUNT(distinct(ProductName))AS TOTAL_PRODUCT FROM products;
 
 # 5. CATOGARY and subcatogary OF PRODUCTS
 SELECT c.EnglishProductCategoryName as product_catogary,
 count(s.EnglishProductSubcategoryName)as total_subcatogary
 FROM dimproductcategory c join dimproductsubcategory s 
 on c.ProductcatogaryKey = s.ProductCategoryKey
 group by 1
 order by 2 desc;
 
 # 6. What is the Total sales by Location(Country,CONTINANT) for  Sales 
 SELECT T.SalesTerritoryCountry,T.SalesTerritoryGroup,
 CONCAT("$ ",ROUND(sum((S.UnitPrice * S.OrderQuantity) - S.DiscountAmount)/1000000 ,2)," M") sales
 FROM dimsalesterritory T LEFT JOIN sales S 
 ON T.ï»¿SalesTerritoryKey = S.SalesTerritoryKey 
 GROUP BY 1,2
 ORDER BY ROUND(sum((S.UnitPrice * S.OrderQuantity) - S.DiscountAmount)/1000000 ,2) DESC;
 
 
 # 7.SALES and profit BY YEAR QTR MONTH 
 SELECT YEAR(DATE(OrderDateKey))AS YEAR,
 quarter(DATE(OrderDateKey)) AS QTR,MONTHNAME(DATE(OrderDateKey))AS MONTH,
 concat("$",ROUND(SUM((UnitPrice*OrderQuantity)-DiscountAmount),2))AS SALES,
 concat("$",round((SUM((UnitPrice*OrderQuantity)-DiscountAmount))-(SUM(ProductStandardCost)),2)) as profit FROM sales
 GROUP BY 1,2,3
 ;
 
 # 8.TOP 10 PRODUCT BY SALES
select p.ProductName,concat("$",round(sum((s.UnitPrice*s.OrderQuantity)-s.DiscountAmount),2)) as sales from products p join sales s 
on p.ProductKey = s.ProductKey 
group by 1
order by round(sum((s.UnitPrice*s.OrderQuantity)-s.DiscountAmount),2) - ROUND(SUM(s.ProductStandardCost),2 ) desc
limit 10 ;

# 9. BOTTOM 10 PRODUCT BY profit
select p.ProductName,concat("$",round(sum((s.UnitPrice*s.OrderQuantity)-s.DiscountAmount),2) - ROUND(SUM(s.ProductStandardCost),2 )) as profit 
from products p join sales s 
on p.ProductKey = s.ProductKey 
group by 1
order by round(sum((s.UnitPrice*s.OrderQuantity)-s.DiscountAmount),2) - ROUND(SUM(s.ProductStandardCost),2 ) ASC
limit 10 ;

 # 10. gender-wise order quantity and sales percentage
 SELECT C.Gender, SUM(S.OrderQuantity)AS TOTAL_ORDERS 
 ,concat(round((SUM(S.OrderQuantity) * 100 / SUM(SUM(S.OrderQuantity)) over() ),1),"%")AS order_percentage 
 ,concat("$ ", round(sum((S.UnitPrice * S.OrderQuantity) - S.DiscountAmount),2 )) as sales,
  CONCAT(ROUND((SUM((S.UnitPrice * S.OrderQuantity) - S.DiscountAmount) * 100.0 / SUM(SUM((S.UnitPrice * S.OrderQuantity) - S.DiscountAmount)) OVER()),1), "%") 
  AS sales_percentage
 FROM sales S JOIN dimcustomer C 
 ON C.ï»¿CustomerKey = S.CustomerKey
 GROUP BY 1
 ORDER BY 2 DESC
 ;
 
 # 11. CUSTOMER INCOME-WISE TOTAL ORDER AND SALES 
SELECT C.YearlyIncome,
 SUM(S.OrderQuantity)AS TOTAL_ORDERS 
 ,concat("$ ", round(sum((S.UnitPrice * S.OrderQuantity) - S.DiscountAmount),2 )) as sales
 FROM SALES S JOIN dimcustomer C 
 ON C.ï»¿CustomerKey = S.CustomerKey
 GROUP BY 1
 ORDER BY 2 DESC
 ;
 
 # 12. TOP 10 CUSTOMER DETAILS BY SALES
 SELECT CONCAT(C.FirstName,C.MiddleName,C.LastName) AS NAME ,C.EmailAddress,C.Phone,C.AddressLine1,
 concat("$ ", round(sum((S.UnitPrice * S.OrderQuantity) - S.DiscountAmount),2 )) as sales,SUM(OrderQuantity) AS TOTAL_ORDERS
 FROM SALES S JOIN dimcustomer C 
 ON C.ï»¿CustomerKey = S.CustomerKey
 GROUP BY CONCAT(C.FirstName,C.MiddleName,C.LastName),2,3,4
 ORDER BY round(sum((S.UnitPrice * S.OrderQuantity) - S.DiscountAmount),2 ) DESC
 LIMIT 10;
 
 
# 13.  Monthly Active Customers for  Sales
SELECT MONTH(OrderDateKey) MONTH_NO,
YEAR(OrderDateKey) YEAR,
MONTHNAME(OrderDateKey) MONTH_NAME,
COUNT(DISTINCT(CustomerKey)) TOTAL_CUSTOMERS,
concat("$",round(sum((UnitPrice*OrderQuantity)-DiscountAmount),2)) sales
FROM SALES 
GROUP BY 1,2,3
ORDER BY YEAR(OrderDateKey)DESC,
MONTH(OrderDateKey)DESC;

# 14. MONTH OVER MONTH GROWTH ON SALES SINCE THE BEGNING OF THE BUSSINES
SELECT MONTH(OrderDateKey),YEAR(OrderDateKey)AS YEAR,
 MONTHNAME(OrderDateKey)AS MONTH,
 concat("$",ROUND(SUM((UnitPrice*OrderQuantity)-DiscountAmount),2))AS SALES,
 CONCAT(ROUND(100*(ROUND(SUM((UnitPrice*OrderQuantity)-DiscountAmount),2)
 -LAG(ROUND(SUM((UnitPrice*OrderQuantity)-DiscountAmount),2)) OVER (ORDER BY YEAR(OrderDateKey),MONTH(OrderDateKey)))
 /LAG(ROUND(SUM((UnitPrice*OrderQuantity)-DiscountAmount),2)) OVER (ORDER BY YEAR(OrderDateKey),MONTH(OrderDateKey)),2),"%") AS MOM_GROWTH
 FROM sales
 GROUP BY 1,2,3
 ORDER BY YEAR(OrderDateKey)DESC,MONTH(OrderDateKey)DESC;