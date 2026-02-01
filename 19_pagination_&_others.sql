
--Pivot

SELECT * INTO #SalesDetails FROM (SELECT ProductId, YEAR(DateOfPurchase) AS [YEAR] FROM PurchaseDetails) AS p
PIVOT(COUNT(ProductID) FOR YEAR IN ([2013],[2014],[2015])) AS PVT

SELECT * FROM #SalesDetails

SELECT * FROM #SalesDetails
UNPIVOT(
ProductId FOR
[Year] IN ([2013],[2014],[2015])
) AS Unpvt

--Pagination

SELECT * FROM Products 
ORDER BY productid
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY

BEGIN
	DECLARE @NumberOfRowsPerPage INT =10 , @TotalNumberOfRows INT, @Counter INT =0
	SELECT @TotalNumberOfRows = COUNT(ProductID) FROM Products
	WHILE (@Counter < = @TotalNumberOfRows)
	BEGIN
		SELECT * FROM Products 
		ORDER BY productid
		OFFSET @Counter ROWS
		FETCH NEXT @NumberOfRowsPerPage ROWS ONLY
		SET @Counter=@Counter+@NumberofRowsPerPage
	END
END


BEGIN
	DECLARE @NumberOfRowsPerPage INT =10 , @TotalNumberOfRows INT, @Counter INT =0
	SELECT @TotalNumberOfRows = COUNT(PurchaseId) FROM PurchaseDetails
	WHILE (@Counter < = @TotalNumberOfRows)
	BEGIN
		SELECT * FROM PurchaseDetails
		ORDER BY PurchaseId
		OFFSET @Counter ROWS
		FETCH NEXT @NumberOfRowsPerPage ROWS ONLY
		SET @Counter=@Counter+@NumberofRowsPerPage
	END
END

--Speacial clause

SET CONCAT_NULL_YIELDS_NULL OFF

SELECT 'SQL SERVER' + NULL AS RES

SET ANSI_NULLS OFF

SELECT * FROM Users WHERE RoleId = NULL

