
USE Quickcart;
--Inline Functions (no body only one select statement)

CREATE FUNCTION ufn_GetProductDetails(@CategoryId INT)
RETURNS TABLE
AS 
RETURN (SELECT * FROM Products WHERE CategoryId = @CategoryId)
GO

SELECT * from ufn_GetProductDetails(1)

--MultiValued Function ( have body with multi statement)

CREATE FUNCTION ufn_GetProductDetailsByCategory(@CategoryId INT)
RETURNS @ProductDetails TABLE (ProductId CHAR(4), ProductName varchar(50),
Price NUMERIC(8), QuantityAvailable INT)
AS 
BEGIN
	INSERT @ProductDetails
	SELECT ProductId,ProductName,Price, QuantityAvailable FROM Products WHERE CategoryId = @CategoryId
	RETURN
END
GO

SELECT * FROM ufn_GetProductDetailsByCategory(1)


--******************** Assigment ****************************

--1 $$$$$$$$$
--This function is used to return the details of the purchases made by a particular customer

CREATE FUNCTION ufn_FetchCustomerPurchases(@EmailId VARCHAR(50))
RETURNS TABLE
AS 
RETURN (SELECT ProductName, QuantityPurchased, SUM(QuantityPurchased *Price) as TotalAmount, DateOfPurchase, CategoryId FROM PurchaseDetails pd 
JOIN Products p ON p.ProductId = pd.Productid 
WHERE Emailid = @EmailId
GROUP BY ProductName, QuantityPurchased, DateOfPurchase, CategoryId)

--DROP FUNCTION ufn_FetchCustomerPurchases
SELECT * FROM ufn_FetchCustomerPurchases('Franken@gmail.com') order by 1

SELECT  p.ProductName,p.CategoryId,pd.DateOfPurchase,SUM(pd.QuantityPurchased) AS TotalQuantityPurchased,SUM(pd.QuantityPurchased * p.Price) AS TotalAmount 
FROM Products P JOIN PurchaseDetails PD ON P.PRODUCTID = PD.PRODUCTID WHERE EMAILID = 'Franken@gmail.com' group by p.ProductName,CategoryId,DateOfPurchase,Price


--2 $$$$$$$$$$$
--This function is used to return the details of all the purchases made by all the customers

CREATE FUNCTION ufn_FetchPurchasedProducts()
RETURNS @PurchasebyCustomers TABLE (ProductId CHAR(4), ProductName VARCHAR(50), Price INT, categoryName VARCHAR(20), 
QuantityPurchased TINYINT, TotalAmount INT, DateOfPurchase DATE)
AS
BEGIN
	DECLARE @TotalAmount INT, @productid CHAR(4), @price INT,@quantitypurchased INT
	SELECT @price=price FROM Products WHERE @productid = ProductId
	SELECT @quantitypurchased = QuantityPurchased FROM PurchaseDetails 
	SET @TotalAmount = @price * @quantitypurchased
	INSERT @PurchasebyCustomers
	SELECT DISTINCT p.ProductId,ProductName,Price,CategoryName,QuantityAvailable,@TotalAmount, DateOfPurchase FROM PRODUCTS P JOIN Categories C ON C.CategoryId = p.CategoryId
	JOIN PurchaseDetails pd on pd.Productid = p.ProductId
	RETURN
END
GO

--SELECT (sum_price * QuantityPurchased) FROM 

--(SELECT sum_price,DateOfPurchase,ProductId,EmailId FROM (SELECT SUM(p.price) as sum_price, pd.DateofPurchase,P.ProductId,pd.Emailid FROM products p INNER JOIN PurchaseDetails pd on p.ProductId = pd.Productid 
--	GROUP BY pd.DateofPurchase,P.ProductId,pd.Emailid) s ) a INNER JOIN PurchaseDetails p1 on p1.Productid = a.ProductId

SELECT * FROM ufn_FetchPurchasedProducts() ORDER BY DateOfPurchase desc
--DROP FUNCTION ufn_FetchPurchasedProducts
--SELECT * FROM Categories


--3
--This function is used to fetch the details of the last ten purchases made by a particular customer

CREATE FUNCTION ufn_FetchLastTenPurchases(@EmailId VARCHAR(50))
RETURNS TABLE
AS 
RETURN 
(SELECT TOP 10 PurchaseId,DateOfPurchase,ProductName,QuantityPurchased,(Price*QuantityPurchased) as totalAmount FROM PurchaseDetails pu JOIN Products p on pu.Productid = p.ProductId
WHERE Emailid = @EmailId order by pu.DateOfPurchase desc)

SELECT * FROM ufn_FetchLastTenPurchases('Timothy@gmail.com')

/*
SELECT emailid,count(*) FROM PurchaseDetails GROUP BY Emailid HAVING count(*)>10
SELECT * FROM PurchaseDetails
--SELECT * FROM sys.tables
SELECT * FROM ProductsOrdered
SELECT * FROM Products
SELECT * FROM Users

SELECT TOP 10 PurchaseId,DateOfPurchase,ProductName,QuantityPurchased,(Price*QuantityPurchased) as totalAmount,* FROM PurchaseDetails pu JOIN Products p on pu.Productid = p.ProductId
WHERE Emailid = 'Franken@gmail.com' order by pu.DateOfPurchase desc
*/

--4
--this function is used to retrieve all the categories

CREATE FUNCTION ufn_getcategories()
RETURNS TABLE
AS 
RETURN (SELECT categoryid,categoryname FROM Categories)

SELECT * FROM ufn_getcategories()


--5
--This function is used to retrieve the card details based on the card number

ALTER FUNCTION  ufn_GetCardDetails(@cardnumber NUMERIC(16))
RETURNS TABLE
AS 
RETURN (SELECT NameOnCard, CardType, CVVNumber, ExpiryDate, Balance FROM CardDetails WHERE CardNumber = @cardnumber)


SELECT * FROM ufn_GetCardDetails(1164916976389880)

--SELECT * FROM CardDetails



	





