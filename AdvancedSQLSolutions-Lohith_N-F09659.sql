Exercise 1:

SELECT 
	FirstName,
	LastName,
	JobTitle,
	Rate,
	AverageRate,
	MaximumRate,
	DiffFromAvgRate = (Rate - AverageRate),
	PercentofMaxRate = ((Rate/MaximumRate)*100)
FROM
(SELECT 
	P.FirstName,
	P.LastName,
	E.JobTitle,
	H.Rate,
	AverageRate = AVG(H.Rate) OVER(),
	MaximumRate = Max(H.Rate) OVER()
FROM Person.Person P
INNER JOIN HumanResources.Employee E
	ON P.BusinessEntityID = E.BusinessEntityID
INNER JOIN HumanResources.EmployeePayHistory H
	ON E.BusinessEntityID =H.BusinessEntityID
) R;

Exercise 2:

SELECT 
	ProductName,
	ListPrice,
	ProductCategory,
	ProductSubCategory,
	AvgPriceByCategory,
	AvgPriceByCategoryAndSubcategory,
	ProductVsCategoryDelta = ListPrice - AvgPriceByCategory
FROM
(SELECT 
	ProductName = P.Name,
	P.ListPrice,
	ProductCategory = C.Name,
	ProductSubCategory = S.Name,
	AvgPriceByCategory = Avg(P.ListPrice) OVER(PARTITION BY C.Name ORDER BY C.Name),
	AvgPriceByCategoryAndSubcategory = Avg(P.ListPrice) OVER(PARTITION BY C.Name,S.Name ORDER BY C.Name,S.Name)
FROM Production.Product P
INNER JOIN Production.ProductSubCategory S
	ON P.ProductSubCategoryID = S.ProductSubCategoryID
INNER JOIN Production.ProductCategory C
	ON S.ProductCategoryID = C.ProductCategoryID
) R;


Exercise 3:

SELECT *,
	[Price Rank] = ROW_NUMBER() Over(Order by ListPrice DESC),
	[Category Price Rank] = ROW_NUMBER() Over(PARTITION BY Productcategory Order by Productcategory, ListPrice DESC),
	CASE
		WHEN ROW_NUMBER() Over(PARTITION BY Productcategory Order by Productcategory, ListPrice DESC) in ('1','2','3','4','5') then 'YES'
		ELSE 'NO'
	END
	AS 	[Top 5 Price In Category]
FROM
(SELECT 
	ProductName = P.Name,
	P.ListPrice,
	ProductCategory = C.Name,
	ProductSubCategory = S.Name
FROM Production.Product P
INNER JOIN Production.ProductSubCategory S
	ON P.ProductSubCategoryID = S.ProductSubCategoryID
INNER JOIN Production.ProductCategory C
	ON S.ProductCategoryID = C.ProductCategoryID) R;
 

Exercise 4:

SELECT *,
	[Price Rank] = ROW_NUMBER() Over(Order by ListPrice DESC),
	[Category Price Rank] = ROW_NUMBER() Over(PARTITION BY Productcategory Order by Productcategory, ListPrice DESC),
	CASE
		WHEN ROW_NUMBER() Over(PARTITION BY Productcategory Order by Productcategory, ListPrice DESC) in ('1','2','3','4','5') then 'YES'
		ELSE 'NO'
	END
	AS 	[Top 5 Price In Category],
	[Category Price Rank With Rank] = RANK() Over(PARTITION BY Productcategory Order by Productcategory, ListPrice DESC),
	[Category Price Rank With Dense Rank] = DENSE_RANK() Over(PARTITION BY Productcategory Order by Productcategory, ListPrice DESC)
FROM
(SELECT 
	ProductName = P.Name,
	P.ListPrice,
	ProductCategory = C.Name,
	ProductSubCategory = S.Name
FROM Production.Product P
INNER JOIN Production.ProductSubCategory S
	ON P.ProductSubCategoryID = S.ProductSubCategoryID
INNER JOIN Production.ProductCategory C
	ON S.ProductCategoryID = C.ProductCategoryID) R;


Exersice 5:

SELECT
	P.PurchaseOrderID,
	P.OrderDate,
	P.TotalDue,
	P.EmployeeID,
	P.VendorID,
	VendorName = V.Name,
	PrevOrderFromVendorAmt = LAG(P.TotalDue,1) OVER(PARTITION BY P.VendorID ORDER BY  P.VendorID, P.OrderDate Desc),
	NextOrderByEmployeeVendor = LEAD(V.Name,1) OVER(PARTITION BY P.EmployeeID ORDER BY  P.OrderDate, P.EmployeeID Desc),
	Next2OrderByEmployeeVendor = LEAD(V.Name,2) OVER(PARTITION BY P.EmployeeID ORDER BY P.OrderDate, P.EmployeeID Desc)
FROM
(SELECT 
	PurchaseOrderID,
	OrderDate,
	TotalDue,
	VendorID,
	EmployeeID
FROM Purchasing.PurchaseOrderHeader 
WHERE YEAR(OrderDate)>2012 
	AND TotalDue>50) P
 INNER JOIN Purchasing.Vendor V
	ON V.BusinessEntityID = P.VendorID;

Exercise 6:

SELECT *,
	Rolling3MonthTotal = SUM([Sub Total]) OVER(ORDER BY OrderYear, OrderMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),
	MovingAvg6Month = AVG([Sub Total]) OVER(ORDER BY OrderYear, OrderMonth ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING),
	MovingAvgNext2Months = AVG([Sub Total]) OVER(ORDER BY OrderYear, OrderMonth ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)
From (
SELECT
OrderYear = YEAR(OrderDate),
OrderMonth = MONTH(OrderDate),
[Sub Total] = SUM(SubTotal)
FROM Purchasing.PurchaseOrderHeader 
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)R
ORDER BY OrderYear,OrderMonth;

Exercise 7:

WITH Purchase as 
(
	SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
		) P
	WHERE OrderRank > 10
	GROUP BY OrderMonth
),

Sales as 
(
	SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Sales.SalesOrderHeader
		) S
	WHERE OrderRank > 10
	GROUP BY OrderMonth
)

SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM Sales A

JOIN Purchase B	ON A.OrderMonth = B.OrderMonth

ORDER BY 1;

Exersice 8:

SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)
	INTO #PURCHASE
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
		) P
	WHERE OrderRank > 10
	GROUP BY OrderMonth;


SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)
	INTO #Sales
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Sales.SalesOrderHeader
		) S
	WHERE OrderRank > 10
	GROUP BY OrderMonth;


SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM #Sales A

JOIN #Purchase B	ON A.OrderMonth = B.OrderMonth

ORDER BY 1;

Exercise 9:

CREATE TABLE #PersonContactInfo
(
	   BusinessEntityID INT
      ,Title VARCHAR(8)
      ,FirstName VARCHAR(50)
      ,MiddleName VARCHAR(50)
      ,LastName VARCHAR(50)
	  ,PhoneNumber VARCHAR(25)
	  ,PhoneNumberTypeID VARCHAR(25)
	  ,PhoneNumberType VARCHAR(25)
	  ,EmailAddress VARCHAR(50)
)

INSERT INTO #PersonContactInfo
(
	   BusinessEntityID
      ,Title
      ,FirstName
      ,MiddleName
      ,LastName
)

SELECT
	   BusinessEntityID
      ,Title
      ,FirstName
      ,MiddleName
      ,LastName

FROM AdventureWorks2019.Person.Person

--Adding Clustered index to #PersonalContactInfo

CREATE CLUSTERED INDEX PersonContactInfo_idx ON #PersonContactInfo(BusinessEntityID)


UPDATE A
SET
	PhoneNumber = B.PhoneNumber,
	PhoneNumberTypeID = B.PhoneNumberTypeID

FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID

--Adding nonclustered index Phonenumbertype ID

CREATE NONCLUSTERED INDEX PersonContactInfo_idx2 ON #PersonContactInfo(PhoneNumberTypeID)


UPDATE A
SET	PhoneNumberType = B.Name

FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.PhoneNumberType B
		ON A.PhoneNumberTypeID = B.PhoneNumberTypeID


UPDATE A
SET	EmailAddress = B.EmailAddress

FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.EmailAddress B
		ON A.BusinessEntityID = B.BusinessEntityID


SELECT * FROM #PersonContactInfo;


Exercise 10

Create View Sales.vw_Top10MonthOverMonth 
AS
WITH Sales AS
(SELECT
OrderDate
,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
,TotalDue
,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader) 
,Top10Sales AS(
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM Sales
WHERE OrderRank <= 10
GROUP BY OrderMonth
)
SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total
 FROM Top10Sales A
LEFT JOIN Top10Sales B
ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth);



