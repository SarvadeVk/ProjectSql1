
--DDL

CREATE TRIGGER ddl_trigger
ON DATABASE
FOR DROP_TABLE 
AS 
BEGIN
	PRINT 'Drop permission denied'
	ROLLBACK TRANSACTION;
END

DROP TRIGGER ddl_trigger ON DATABASE

DROP TABLE PurchaseDetailsUK

--DML

CREATE TABLE SaleAudit
(
Id INT IDENTITY(1,1) PRIMARY KEY,
SaleData VARCHAR(200) NOT NULL,
SaleDate DATETIME NOT NULL
)
GO

CREATE TRIGGER trg_saleaudit
ON PurchaseDetails
FOR INSERT
AS
BEGIN
	DECLARE @Id INT
	DECLARE @Name VARCHAR(200)
	DECLARE @Saledata VARCHAR(200) 
	SELECT @Id = PurchaseID, @Name = EmailId from inserted
	SET @Saledata = 'A Purchase is made with ID = ' + CAST(@ID AS VARCHAR(10)) + ' by the customer = ' + @Name  
	INSERT INTO SaleAudit(Saledata,Saledate) VALUES (@Saledata , GETDATE())
END
GO

--DROP TRIGGER  trg_saleaudit

INSERT INTO PurchaseDetails VALUES('Franken@gmail.com','P143',2,'30-JAN-2022')
--DELETE FROM PurchaseDetails WHERE PurchaseId = 1167 
--SELECT * FROM PurchaseDetails  WHERE PurchaseId = 1168 

Select * from SaleAudit

--The data inserted in the PurchaseDetails will be inserted in the SaleAudit by the trg_saleaudit trigger. 
--Thus trigger is performing insertion after the insertion event in the specified table. Hence, it is known as For / After Trigger.
--For / After trigger can be used only on tables. It cannot be applied on views.


--INSTEAED OF TRIGGER

CREATE VIEW vwProductCategoryNames
AS
SELECT ProductId, ProductName, Price, QuantityAvailable, CategoryName 
FROM Products P INNER JOIN Categories C ON P.CategoryId = C.CategoryId

SELECT * FROM vwProductCategoryNames

INSERT INTO vwProductCategoryNames VALUES ('P750','Building Blocks', 750.00, 15, 'Toys') --Error

--Observe the error thrown by the insert statement, data is not getting inserted in the view because any modification to the view will affect multiple tables involved. 
--So, let us create a trigger which will validate the data before inserting it and insert the data directly in the base tables instead of inserting in view.

CREATE TRIGGER trg_vwProductCategoryNames
ON vwProductCategoryNames
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @CategoryId TINYINT
	SELECT @CategoryId = CategoryId FROM Categories C INNER JOIN inserted I ON c.CategoryName = I.CategoryName

	IF(@CategoryId IS NULL)
	BEGIN
		RAISERROR('Invalid Category Name',16,1)
		RETURN
	END

	INSERT INTO Products(ProductId,ProductName,Price,QuantityAvailable,CategoryId)
	SELECT ProductId,ProductName,Price,QuantityAvailable,@CategoryId FROM INSERTED
END
GO


INSERT INTO vwProductCategoryNames VALUES ('P750','Building Blocks', 750.00, 15, 'Toys') 

--The above trigger validates if the CategoryName provided is a valid name present in the Categories table. If it is present, then instead of inserting the data in the vwProductCategoryNames,
--the data will be inserted in the Products table. Hence it is known as Instead Of trigger.

SELECT * FROM sys.triggers


CREATE TRIGGER trg_one
ON products
AFTER INSERT
AS
BEGIN
	PRINT 'INSERT TRIGGER ONE'
END
GO

CREATE TRIGGER trg_two
ON products
AFTER INSERT
AS
BEGIN
	PRINT 'INSERT TRIGGER TWO'
END
GO

EXEC sys.sp_settriggerorder 
@triggername = 'trg_One',  
@order = 'FIRST',  
@stmttype = 'INSERT'
GO
EXEC sys.sp_settriggerorder 
@triggername = 'trg_Two',  
@order = 'LAST',  
@stmttype = 'INSERT'  
GO

--to set order of exceutio of trigger sys.sp_settriggerorder used

INSERT INTO Products VALUES ('P702','Denim T-Shirt',7,250.00,100)


