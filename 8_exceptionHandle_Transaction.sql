
use Quickcart;

/*
BEGIN TRY
	DECLARE @Var1 INT = 100, @Var2 INT = 0
	SELECT @Var1/@Var2 AS RESULT
END TRY
BEGIN CATCH
	SELECT ERROR_LINE() AS LINENUMBER,
		ERROR_MESSAGE() AS ERRORMESSAGE,
		ERROR_NUMBER() AS ERRORNUMBER,
		ERROR_SEVERITY() AS SEVERITY,
		ERROR_STATE() AS ERRORSTATE
END CATCH

*/

BEGIN TRY
    DECLARE @Var1 INT = 100, @Var2 INT = 0
    IF @Var2 = 0
         THROW 62000,'The Divisor cannot be zero.',1
    ELSE
         SELECT @Var1/@Var2 AS RESULT
END TRY
BEGIN CATCH
	SELECT ERROR_LINE() AS LINENUMBER,
		ERROR_MESSAGE() AS ERRORMESSAGE,
		ERROR_NUMBER() AS ERRORNUMBER,
		ERROR_SEVERITY() AS SEVERITY,
		ERROR_STATE() AS ERRORSTATE
END CATCH


--Exception Handling and Transactions (Succesfully run)
/*
BEGIN
	DECLARE @Price NUMERIC(8), @Amount NUMERIC(8),@Balance NUMERIC(8),@CardNumber NUMERIC(16,0) = '1201253053391160',
	@ProductId CHAR(4) = 'P157', @QtyPurchased INT =10, @QtyAvailable INT, @EmailId VARCHAR(50) = 'Margaret@gmail.com'

 BEGIN TRY
	IF NOT EXISTS(SELECT ProductId FROM products WHERE ProductId = @ProductId)
	BEGIN 
		PRINT 'Product Id does not exist'
		RETURN
	END
	IF NOT EXISTS(SELECT EmailId FROM Users WHERE Emailid = @EmailId)
	BEGIN 
		PRINT 'Email Id does not exist'
		RETURN
	END
	IF @QtyPurchased<=0
	BEGIN
		PRINT 'Quantity purchased Should be greater than 0'
		RETURN
	END
	IF NOT EXISTS(SELECT CardNumber FROM CardDetails WHERE CardNumber = @CardNumber)
	BEGIN 
		PRINT 'Card Number does not exist'
		RETURN
	END
	SELECT @Price = PRICE FROM Products WHERE ProductId = @ProductId
	SELECT @Balance = Balance FROM CardDetails WHERE CardNumber = @CardNumber
	SET @Amount = @QtyPurchased * @Price
	IF @Balance >= @Amount
		BEGIN
		 BEGIN TRAN
			UPDATE CardDetails SET Balance = Balance - @Amount WHERE CardNumber = @CardNumber
			INSERT INTO PurchaseDetails(Emailid,Productid,QuantityPurchased) VALUES(@EmailId,@ProductId,@QtyPurchased)
			UPDATE Products SET QuantityAvailable -= @QtyPurchased WHERE ProductId = @ProductId
		 COMMIT TRAN
			PRINT 'Batch Executed Successfully'
			PRINT 1
			RETURN
		END
	ELSE
			PRINT 'Insuffient Balance'
 END TRY

 BEGIN CATCH
 ROLLBACK TRAN 
 PRINT 'Rollback Excecuted successfully'
   PRINT 'We are unable to process your request now.'   
   SELECT ERROR_NUMBER() AS ErrorNumber,         
          ERROR_LINE() AS LineNumber,    
          ERROR_MESSAGE() AS ErrorMessage
 END CATCH 
END
*/

select * from Products where ProductId = 'P157'
select * from CardDetails where cardnumber = '1201253053391160'
select * from PurchaseDetails 

--Throwing error

BEGIN
	DECLARE @Price NUMERIC(8), @Amount NUMERIC(8),@Balance NUMERIC(8),@CardNumber NUMERIC(16,0) = '1201253053391160',
	@ProductId CHAR(4) = 'P157', @QtyPurchased INT =50, @QtyAvailable INT, @EmailId VARCHAR(50) = 'Margaret@gmail.com'

 BEGIN TRY
	IF NOT EXISTS(SELECT ProductId FROM products WHERE ProductId = @ProductId)
	BEGIN 
		PRINT 'Product Id does not exist'
		RETURN
	END
	IF NOT EXISTS(SELECT EmailId FROM Users WHERE Emailid = @EmailId)
	BEGIN 
		PRINT 'Email Id does not exist'
		RETURN
	END
	IF @QtyPurchased<=0
	BEGIN
		PRINT 'Quantity purchased Should be greater than 0'
		RETURN
	END
	IF NOT EXISTS(SELECT CardNumber FROM CardDetails WHERE CardNumber = @CardNumber)
	BEGIN 
		PRINT 'Card Number does not exist'
		RETURN
	END
	SELECT @Price = PRICE FROM Products WHERE ProductId = @ProductId
	SELECT @Balance = Balance FROM CardDetails WHERE CardNumber = @CardNumber
	SET @Amount = @QtyPurchased * @Price
	IF @Balance >= @Amount
		BEGIN
		 BEGIN TRAN
			UPDATE CardDetails SET Balance = Balance - @Amount WHERE CardNumber = @CardNumber
			INSERT INTO PurchaseDetails(Emailid,Productid,QuantityPurchased) VALUES(@EmailId,@ProductId,@QtyPurchased)
			UPDATE Products SET QuantityAvailable -= @QtyPurchased WHERE ProductId = @ProductId
		 COMMIT TRAN
			PRINT 'Batch Executed Successfully'
			PRINT 1
			RETURN
		END
	ELSE
			PRINT 'Insuffient Balance'
 END TRY

 BEGIN CATCH
 ROLLBACK TRAN 
 PRINT 'Rollback Excecuted successfully'
   PRINT 'We are unable to process your request now.'   
   SELECT ERROR_NUMBER() AS ErrorNumber,         
          ERROR_LINE() AS LineNumber,    
          ERROR_MESSAGE() AS ErrorMessage
 END CATCH 
END
