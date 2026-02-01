

--@ declared are local variables
--@@ declared are global variables
--Global variables are system defined variables. They cannot be declared or assigned values by developers. These variables are prefixed with '@@' and are accessible to all the users.
--@@SERVERNAME is a global variable which stores the name of the server to which the SQL Server instance is connected.
--@@ERROR is a global variable which returns the error number for the last T-SQL statement executed. It returns 0 if the previous T-SQL statement encountered no errors.

/*
BEGIN
	DECLARE @Price NUMERIC(8) = 200, @QuantityPurchased TINYINT = 6, @TotalAmount NUMERIC(8) , @DiscountedAmount NUMERIC(10)
	SET @TotalAmount = @QuantityPurchased * @Price
	IF @TotalAmount>0 AND @TotalAmount<1000
		SET @DiscountedAmount = 0.05*@TotalAmount
	ELSE IF @TotalAmount>=1000 AND @TotalAmount<2000
		SET @DiscountedAmount = (10.0/100)*@TotalAmount
	ELSE 
		SET @DiscountedAmount = (20.0/100)*@TotalAmount
	PRINT @DiscountedAmount
	IF @TotalAmount>0 AND @TotalAmount<1000
		SET @TotalAmount = (1-(5.0/100))*@TotalAmount
	ELSE IF @TotalAmount>=1000 AND @TotalAmount<2000
		SET @TotalAmount = (1-10.0/100)*@TotalAmount
	ELSE 
		SET @TotalAmount = (1-20.0/100)*@TotalAmount
	PRINT  @TotalAmount
END
*/
--Case statement

BEGIN
	DECLARE @Price NUMERIC(8) = 400, @QuantityPurchased TINYINT = 6, @TotalAmount NUMERIC(8) , @DiscountedAmount NUMERIC(10)
	SET @TotalAmount = @QuantityPurchased * @Price
	SET @TotalAmount =
	CASE 
		WHEN @TotalAmount>0 AND @TotalAmount<1000
			THEN 0.95*@TotalAmount
		WHEN @TotalAmount>=1000 AND @TotalAmount<2000
			THEN 0.9*@TotalAmount
		ELSE 0.8*@TotalAmount
	END
	PRINT @TotalAmount
END