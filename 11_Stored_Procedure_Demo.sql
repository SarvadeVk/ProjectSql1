

--Stored procedure demo

CREATE PROCEDURE usp_InterPurchaseDetails
(
	@EmailId VARCHAR(50),
	@cardnumber NUMERIC(16),
	@productId CHAR(4),
	@QtyPurchased INT,
	@PurchaseID BIGINT OUT
)
AS 
BEGIN
	DECLARE @Price NUMERIC(8), @Amount NUMERIC(8), @Balance NUMERIC(8), 
               @TotalAmount INT

 BEGIN TRY
	  BEGIN
      IF NOT EXISTS (SELECT ProductId FROM Products WHERE ProductId=@ProductId)
         RETURN -1
      END
      IF NOT EXISTS (SELECT EmailId FROM Users WHERE EmailId=@EmailId)
      BEGIN
         RETURN -2
      END
      IF @QtyPurchased <= 0
      BEGIN
         RETURN -3
      END
      IF NOT EXISTS (SELECT CardNumber FROM CardDetails WHERE CardNumber=@CardNumber)
      BEGIN
         RETURN -4
      END
      SELECT @Price = Price FROM Products WHERE ProductId = @ProductId  -- Getting price of the products
      SELECT @Balance=Balance FROM CardDetails WHERE CardNumber = @CardNumber  -- Getting the available balance
      SET @Amount = @QtyPurchased * @Price  -- Calculating the bill amount
      IF @Balance >= @Amount
	  BEGIN
		BEGIN TRAN
			UPDATE CardDetails SET Balance -= @Amount WHERE @cardnumber = CardNumber --updating balance in carddetails table
			INSERT INTO PurchaseDetails(EmailId,ProductId,QuantityPurchased,DateOfPurchase)
                VALUES (@EmailId,@ProductId, @QtyPurchased,CAST(GETDATE() AS DATE))   -- Insert PurchaseDetails
			UPDATE Products SET QuantityAvailable -= @QtyPurchased WHERE ProductId = @productId  --Update products
			SET @PurchaseId = IDENT_CURRENT('PurchaseDetails') -- Fetches the maximum 
                                                              -- value for the Identity 
                                                              -- column in the given table 
        COMMIT         
        RETURN 1
		END
	   ELSE
	    RETURN -5
 END TRY

 BEGIN CATCH
	PRINT 'Some error occured'
	ROLLBACK
	RETURN -99
 END CATCH 
END
GO

DECLARE @ReturnValue INT, @PurchaseID BIGINT
EXEC   @ReturnValue = usp_InterPurchaseDetails 'Margaret@gmail.com',1201253053391160, 'P107', 2, @PurchaseId OUT
SELECT @ReturnValue AS ReturnValue, @PurchaseId AS PurchaseId