
				------------  SQL SKILL DEMO  ----------
		-------------------------------------------------
			      	-----------------------


USE AdventureWorks2019

GO
-- 1. Write a query that displays information about non-purchased products in the orders table.
--Display: Product ID, Product Name, Product Category, Order ID, Order Date

SELECT DISTINCT ProductID, Name,Color,ListPrice,Size
FROM Production.Product
EXCEPT
SELECT DISTINCT P.ProductID, Name,Color,ListPrice,Size
FROM Production.Product P JOIN Sales.SalesOrderDetail D
ON P.ProductID = D.ProductID
ORDER BY ProductID



--2. Write a query that displays information about customers who have not made any orders. 
--Display: Customer ID, Last Name, First Name (or 'Unknown' if not available)
--Sort the report by Customer ID in ascending order.


GO

SELECT CustomerID, LastName,FirstName
FROM(
		SELECT CustomerID
		FROM Sales.Customer
		WHERE PersonID IS NULL
		)D
LEFT JOIN Person.Person P 
ON P.BusinessEntityID = D.CustomerID
ORDER BY CustomerID



--03. Write a query that displays the details of the 10 customers who have made the most orders.
--Display CustomerID, FirstName, LastName, and the number of orders made by the customers, 
--sorted in descending order.


GO


SELECT DISTINCT TOP 10 D.CustomerID, FirstName, LastName
, COUNT(SalesOrderID)OVER(PARTITION BY D.CUSTOMERID) AS CountOfOrders
FROM(
		SELECT CustomerID,FirstName, LastName
		FROM Sales.Customer C JOIN Person.Person P
		ON C.PersonID = P.BusinessEntityID
		)D
JOIN Sales.SalesOrderHeader H
ON D.CustomerID = H.CustomerID
ORDER BY CountOfOrders DESC


--04. Write a query that displays information about employees and their job titles.
-- Display (FirstName, LastName, JobTitle, HireDate) along how many employees have the same job title as each employee.

GO


 SELECT FirstName, LastName, JobTitle, HireDate
 , COUNT(E.BusinessEntityID)OVER(PARTITION BY JobTitle) CountOfTitle
FROM Person.Person P JOIN HumanResources.Employee E
ON P.BusinessEntityID = E.BusinessEntityID




--05. Write a query that displays for each customer the date of their last order and the date of their second-to-last order.
--Display SalesOrderID, CustomerID, LastName, FirstName, the date of the last order, and the date of the second-to-last order.


GO 
-- To present only the last order and the one before it for each customer, resulting in an outcome of 19,119 rows, we'll use ROW_NUMBER instead of DENSE_RANK.
-- DENSE_RANK is being used to show 8 more customers who've made 2 orders on the same date.

WITH A
AS(
SELECT SalesOrderID, CustomerID, LastOrder, PrevOrder
FROM(	 SELECT SalesOrderID, CustomerID ,OrderDate AS LastOrder 
         , LAG(OrderDate)OVER(PARTITION BY CustomerID ORDER BY OrderDate) PrevOrder
		 , DENSE_RANK()OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC)RNK
	   --, ROW_NUMBER()OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC)RN
		FROM Sales.SalesOrderHeader
		GROUP BY CustomerID, OrderDate,SalesOrderID)D
WHERE RNK = 1
   -- RN = 1
)
SELECT SalesOrderID, A.CustomerID, LastName, FirstName ,LastOrder, PrevOrder
FROM A JOIN Sales.Customer C
ON A.CustomerID = C.CustomerID
LEFT JOIN Person.Person P
ON C.PersonID = P.BusinessEntityID



--06.  Write a query that displays the total amount of products in the most expensive order of each year, indicating to which customers these orders belong.
--Display the order year, order number, customer's last and first name, and a Total column based on the calculation UnitPrice*(1-UnitPriceDiscount)*OrderQty.
--Format the Total column as currency with one decimal point.


GO 

WITH HIGHST_BUY ([Year], SalesOrderID, LastName, FirstName ,total, RNK)
AS(	
	SELECT D.SalesOrderID, YEAR(OrderDate)[Year], LastName, FirstName
    ,FORMAT(SUM(UnitPrice*(1-unitpricediscount)*OrderQty),'#,#.0') total
	, DENSE_RANK()OVER(PARTITION BY YEAR(OrderDate) ORDER BY SUM(UnitPrice*(1-unitpricediscount)*OrderQty) DESC)RNK
	FROM Sales.SalesOrderHeader H JOIN Sales.SalesOrderDetail D
	ON H.SalesOrderID = D.SalesOrderID
	JOIN Sales.Customer C 
	ON H.CustomerID = C.CustomerID
	JOIN Person.Person P
	ON C.PersonID = P.BusinessEntityID
	GROUP BY D.SalesOrderID, YEAR(OrderDate), LastName, FirstName
	)

SELECT  [Year], SalesOrderID, LastName, FirstName, Total
FROM HIGHST_BUY 
WHERE RNK =1



--07. Display the number of orders made each month of the year using a matrix.


GO

SELECT [MONTH], ISNULL([2011],0)[2011],[2012],[2013],ISNULL([2014],0)[2014]
FROM(
	SELECT YEAR(ORDERDATE)[YEAR], MONTH(ORDERDATE)[MONTH],
	COUNT(SALESORDERID) S_COUNT
	FROM Sales.SalesOrderHeader
	GROUP BY YEAR(ORDERDATE), MONTH(ORDERDATE))D

PIVOT (SUM(S_COUNT) FOR [YEAR]IN([2011],[2012],[2013],[2014]))PVT
ORDER BY [MONTH]



--08. Write a query that displays the total amount of products in an order for each month of the year as well as the cumulative total for each year.
--sorted in descending order. Include a row that highlights the annual total."

GO


WITH YearlyRevenu 
AS(
    SELECT YEAR(H.Orderdate) AS [Year], MONTH(H.Orderdate) AS [Month],
        FORMAT(SUM(LineTotal),'0.00') AS [Sum_Price],
        SUM(SUM(LineTotal)) OVER (PARTITION BY YEAR(H.OrderDate) ORDER BY MONTH(H.OrderDate)) AS "Cum_Sum"
    FROM SALES.SalesOrderHeader H JOIN SALES.SalesOrderDetail D 
	ON H.SalesOrderID = D.SalesOrderID
    GROUP BY YEAR(H.Orderdate), MONTH(H.Orderdate)
	)
SELECT [Year], CAST([Month] AS VARCHAR) AS [Month], [Sum_Price], FORMAT([Cum_Sum],'0.00') AS [Cum_Sum]
FROM  YearlyRevenu 
UNION ALL
SELECT [Year], 'Grand Total' AS [Month], NULL AS [Sum_Price], CAST(MAX([Cum_Sum]) AS DECIMAL (18,2)) [Cum_Sum]
FROM  YearlyRevenu 
GROUP BY [Year]
ORDER BY [Year], 4
 
   



--09. Write a query that displays employees in each department sorted by their hiring date ascending. 
--Display the columns: Department Name, Employee ID, Full Name, Hire Date, Tenure in the company in months,
--Full Name and Hire Date of the employee hired before them, and the number of days between their hire date and the hire date of the preceding employee.


GO

SELECT D.Name AS DEP_NAME, E.BusinessEntityID AS EMP_ID, CONCAT(P.FirstName, ' ' , P.LastName) EMP_NAME
, HireDate
, DATEDIFF(mm, HireDate, GETDATE()) AS SENIORITY
, LEAD(CONCAT(P.FirstName, ' ' , P.LastName))OVER(PARTITION BY D.Name ORDER BY DATEDIFF(mm, HireDate, GETDATE())) PREV_EMP_NAME
, LEAD(HireDate)OVER(PARTITION BY D.Name ORDER BY HireDate DESC) PREV_EMP_DATE
, DATEDIFF(DD, LEAD(HireDate)OVER(PARTITION BY D.Name ORDER BY HireDate DESC), HireDate) DIFF_DAYS
FROM HumanResources.Department D JOIN HumanResources.EmployeeDepartmentHistory H
ON D.DepartmentID = H.DepartmentID
JOIN HumanResources.Employee E
ON H.BusinessEntityID = E.BusinessEntityID
JOIN Person.Person P
ON E.BusinessEntityID = P.BusinessEntityID
ORDER BY DEP_NAME



--10. Write a query that displays the details of employees who work in the same department and were hired on the same date.
--The details of the employees should be displayed as a list for each combination of hire date and department number,
--sorted by dates in descending order. (One option is to use XML Path)


GO


SELECT  E.HireDate,  H.DepartmentID
,  STUFF(( SELECT ' '+  CONCAT_WS(' ',EM.BusinessEntityID, FirstName, LastName)
										FROM Person.Person PE JOIN HumanResources.Employee EM
										ON PE.BusinessEntityID = EM.BusinessEntityID
										WHERE E.HireDate =EM.HireDate
										FOR XML PATH ('')),1,1,'') TEAM_EMPLOYEES
FROM HumanResources.EmployeeDepartmentHistory H
 JOIN HumanResources.Employee E
ON H.BusinessEntityID = E.BusinessEntityID
JOIN Person.Person P
ON E.BusinessEntityID = P.BusinessEntityID
WHERE H.EndDate IS NULL
GROUP BY E.HireDate, H.DepartmentID
ORDER BY  HireDate DESC

------
--*




