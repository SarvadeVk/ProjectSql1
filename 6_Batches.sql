
--Batches
--Insert, update like multiple T-SQL commands can be run at a time by using Batch

BEGIN
	DECLARE @Price NUMERIC(8), @Amount NUMERIC(8),@Balance NUMERIC(8),@CardNumber NUMERIC(16,0) = '2122490035590690',
	@ProductId CHAR(4) = 'P131', @QtyPurchased INT =1, @QtyAvailable INT, @EmailId VARCHAR(50) = 'Margaret@gmail.com'

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
			UPDATE CardDetails SET Balance = Balance - @Amount WHERE CardNumber = @CardNumber
			INSERT INTO PurchaseDetails(Emailid,Productid,QuantityPurchased,DateOfPurchase) VALUES(@EmailId,@ProductId,@QtyPurchased,DEFAULT)
			UPDATE Products SET QuantityAvailable -= @QtyPurchased WHERE ProductId = @ProductId
			PRINT 'Batch Executed Successfully'
			PRINT 1
			RETURN
		END
	ELSE
		BEGIN 
			PRINT 'Insuffient Balance'
		END
END


select * from PurchaseDetails
select * from Products where ProductId = 'P131'
select * from carddetails where cardnumber = '2122490035590690';