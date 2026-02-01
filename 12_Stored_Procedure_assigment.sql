
USE Quickcart;
--Stored procedure exercise

--1

CREATE PROCEDURE usp_AddProduct
(
	@ProductID CHAR(4),
	@ProductName VARCHAR(50),
	@CategoryId INT,
	@Price NUMERIC(8),
	@QuantityAvailable NUMERIC(8)
)
AS 
BEGIN
 BEGIN TRY
	IF @ProductID IS NULL 
	BEGIN
	 PRINT 'ProductId should not be NULL'
	 RETURN -1
	END
	IF @ProductID not like 'P%' OR LEN(@ProductID) != 4
	 BEGIN
		PRINT 'ProductID not start with P or length is not 4'
		RETURN -2
	 END
	IF @ProductName IS NULL
	 BEGIN
		PRINT 'Product Name should not be null'
		RETURN -3
	 END
	IF @CategoryId IS NULL
	 BEGIN 
		PRINT 'CategoryID should not be null'
		RETURN -4
	 END
	IF NOT EXISTS (SELECT CategoryId FROM Categories WHERE CategoryId = @CategoryId)
	 BEGIN 
		PRINT 'CategoryId is not valid'
		RETURN -5
	 END
	IF @Price<= 0 OR @Price IS NULL
	 BEGIN
		PRINT 'Price should be greater than 0 or should not null'
		RETURN -6
	 END
	IF @QuantityAvailable<= 0 OR @QuantityAvailable IS NULL
	 BEGIN
		PRINT 'Quantity Available should be greater than 0 or should not null'
		RETURN -7
	 END
	IF @ProductName IS NULL OR @CategoryId IS NULL OR @Price IS NULL OR @QuantityAvailable IS NULL
	 BEGIN
		PRINT 'Some input parameter is null'
	 END
	BEGIN
		BEGIN TRAN
			INSERT INTO Products VALUES(@ProductID,@ProductName,@CategoryId,@Price,@QuantityAvailable)
			COMMIT TRAN
			PRINT 'insert done successfully'
			RETURN 1
	END
 END TRY

 BEGIN CATCH
 ROLLBACK TRAN
 PRINT 'rollback executed'
 RETURN -99
 END CATCH
END
GO

--DROP PROCEDURE usp_AddProduct

DECLARE @RESULT INT
EXEC @RESULT = usp_AddProduct 'P160','checking item', 5, 1000, 10
select @RESULT


--select * from Products
--SELECT * FROM Categories
------------------------------------------------------------------------------------------------------------------
--2 

CREATE PROCEDURE usp_UpdateBalance
(
	@CardNumber NUMERIC(16,0),
	@NameOnCard VARCHAR(40),
	@CardType CHAR(1),
	@CVVNumber NUMERIC(3,0),
	@ExpiryDate DATETIME,
	@Price DECIMAL(10,2)
)
AS 
BEGIN
	BEGIN TRY
	 IF @CardNumber IS NULL
	 BEGIN
	  PRINT 'card number is null'
	  RETURN -1
	 END
	 IF NOT EXISTS(SELECT cardNumber from CardDetails where @CardNumber = CardNumber)
	 BEGIN
	  PRINT 'card deatils not exist'
	  RETURN -2
	 END
	 IF @NameOnCard IS NULL OR @nameoncard != (SELECT NameOncard from CardDetails WHERE @CardNumber = CardNumber)
	 BEGIN
	  PRINT 'Name on card is not valid or it"s null'
	  RETURN -3
	 END
	 IF @CardType IS NULL OR @CardType != (SELECT Cardtype FROM CardDetails WHERE @CardNumber= CardNumber)
	 BEGIN
	  PRINT 'card type is not valid or it"s null'
	  RETURN -4
	 END
	 IF @CVVNumber IS NULL OR @CVVNumber != (SELECT cvvnumber FROM CardDetails WHERE @CardNumber = CardNumber)
	 BEGIN
	  PRINT 'CVV number is not valid or null'
	  RETURN -5
	 END
	 IF @ExpiryDate IS NULL OR @ExpiryDate != (SELECT Expirydate FROM CardDetails WHERE @CardNumber = CardNumber)
	 BEGIN
	  PRINT 'Expiry date is not valid or null'
	  RETURN -6
	 END
	 IF @Price IS NULL OR @price<0
	 BEGIN 
	  PRINT 'Price is not valid or null'
	  RETURN -7
	 END
	 DECLARE @Balance NUMERIC(8,2)
	 SELECT @Balance = Balance FROM CardDetails WHERE @CardNumber = CardNumber
	 IF @Balance < @Price
	 BEGIN 
	  PRINT 'Suffcient Balance is not available'
	  RETURN -8
	 END
	 BEGIN
		BEGIN TRAN
		 UPDATE CardDetails SET Balance = Balance - @Price WHERE @CardNumber = CardNumber
		COMMIT TRAN
		PRINT 'update done successfully'
		RETURN 1
	 END
	END TRY

 BEGIN CATCH
	PRINT 'Some error occured'
	ROLLBACK
	RETURN -99
 END CATCH 
END
GO

DROP PROCEDURE usp_UpdateBalance

DECLARE @RESULT INT
EXEC @RESULT = usp_UpdateBalance 1190676541467400, 'Brown', 'V', 390,'2036-01-25',1000
SELECT @RESULT as result

SELECT * FROM CardDetails WHERE CardNumber =  '1190676541467400';

--UPDATE CardDetails SET Balance += 1000 WHERE CardNumber =  '1190676541467400'

-------------------------------------------------------------------------------------------------
--3

CREATE PROCEDURE usp_InsertPurchaseDetails
(
	@EmailId VARCHAR(45),
	@ProductId CHAR(4),
	@QuantityPurchased SMALLINT,
	@PurchaseId INT OUT
)
AS BEGIN
	BEGIN TRY
		IF @EmailId IS NULL
			BEGIN
			PRINT 'EmailId is null'
			SET @PurchaseId = 0
			RETURN -1
			END
		IF NOT EXISTS(SELECT EmailId FROM Users WHERE Emailid = @EmailId)
			BEGIN
			PRINT 'Emailid not valid'
			SET @PurchaseId = 0
			RETURN -2
			END
		IF @ProductId IS NULL
			BEGIN
			PRINT 'ProductId is null'
			SET @PurchaseId = 0
			RETURN -3
			END
		IF NOT EXISTS(SELECT ProductId FROM Products Where ProductId = @ProductId)
			BEGIN
			PRINT 'ProductId is not valid'
			SET @PurchaseId = 0
			RETURN -4
			END
		IF @QuantityPurchased <= 0 OR @QuantityPurchased IS NULL 
			BEGIN
			PRINT 'Quantity purchased is invalid or null'
			SET @PurchaseId = 0
			RETURN -5
			END
		BEGIN 
		 BEGIN TRAN
		  INSERT INTO PurchaseDetails values(@EmailId,@ProductId,@QuantityPurchased,CAST(GETDATE() AS smalldatetime))
		  UPDATE Products SET QuantityAvailable -= @QuantityPurchased WHERE ProductId = @ProductId
		  SET @PurchaseId = IDENT_CURRENT('PurchaseDetails')
		 COMMIT TRAN
		 PRINT 'Purchase successful'
		 RETURN 1
		END
	END TRY
	BEGIN CATCH
		PRINT 'Some Error occured'
		SELECT ERROR_MESSAGE() AS MESSAGE
		SET @PurchaseId = 0
		ROLLBACK TRAN
		RETURN -99
	END CATCH
END
GO

DROP PROCEDURE usp_InsertPurchaseDetails

DECLARE @RES INT, @PURCHASEID INT
EXEC @RES = usp_InsertPurchaseDetails 'Ann@gmail.com','P158',10, @PURCHASEID OUT
SELECT @RES AS RESULT, @PURCHASEID AS purchaseId

--SELECT * FROM Products
--SELECT * FROM PurchaseDetails
--SELECT * FROM Users
--EXEC sp_helptext usp_interpurchasedetails

--4

CREATE PROCEDURE usp_UpdatePrice
(
	@productId CHAR(4),
	@Price MONEY,
	@updatedPrice money OUT
)
AS BEGIN
	 BEGIN TRY
		IF NOT EXISTS(SELECT productId from Products WHERE productId = @ProductId)
			BEGIN
				PRINT 'ProductId is invalid'
				SET @updatedPrice = 0
				RETURN -1
			END
		BEGIN
			BEGIN TRAN
				UPDATE Products set Price = @Price WHERE ProductId = @productId
				SELECT @updatedPrice = PRICE FROM Products WHERE ProductId = @productId
			COMMIT TRAN
			PRINT 'Price updated successful'
			RETURN 1
		END
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN
	PRINT 'ERROR OCCURED'
	RETURN -1
	SELECT ERROR_MESSAGE() AS MESSAGE
	SELECT ERROR_LINE() AS LINE
	END CATCH
END

DROP PROCEDURE usp_UpdatePrice

DECLARE @RES INT, @UpdatedPrice MONEY
EXEC @RES = usp_UpdatePrice 'P160',1000,@updatedPrice OUT
SELECT @RES AS RESULT, @updatedPrice AS NEWPRICE

select * from Products