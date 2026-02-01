USE Quickcart;

--STORED PROCEDURES

CREATE PROCEDURE usp_firstProcedure
AS 
BEGIN 
PRINT 'Stored Procodure started'
END

--EXEC usp_firstProcedure

ALTER PROCEDURE usp_firstProcedure(
@InParam VARCHAR(15),
@OutParam VARCHAR(15) OUT
)WITH RECOMPILE
AS 
BEGIN 
	SET @OutParam = 'Message is ' + @InParam
END

DECLARE @OUTParamValue VARCHAR(15), @InParamValue VARCHAR(15)= 'Hi' 
EXEC usp_firstProcedure @inparamvalue, @outparamvalue OUT
SELECT @OUTParamValue AS RESULT

SP_Helptext 'usp_firstProcedure' 

--WITH ENCRYPTED can be used to encript not to show in text

DROP PROCEDURE usp_firstProcedure

CREATE PROCEDURE usp_FetchProductDetails
(@ProductId CHAR(4))
AS 
BEGIN 
SELECT * FROM Products WHERE ProductID = @ProductId
END

--DROP PROCEDURE usp_FetchProductDetails

EXEC usp_FetchProductDetails 'P101'

SELECT * FROM Products

CREATE PROCEDURE usp_defaultValues
(
@P1 INT, @P2 INT = 10, @P3 INT =20
)
AS 
BEGIN 
	SELECT @P1, @P2, @P3
END

EXEC usp_defaultValues 1,2,3

EXEC usp_defaultValues 100

--DROP PROCEDURE usp_defaultValues

CREATE PROCEDURE usp_Purchase(
@EmailID VARCHAR(50), @ProductId CHAR(4), @QuantityPurchased SMALLINT)
AS 
BEGIN 
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO PurchaseDetails VALUES (@EmailID,@ProductId,@QuantityPurchased, CAST(GETDATE() AS DATE))
			UPDATE Products SET QuantityAvailable = QuantityAvailable - @QuantityPurchased WHERE @ProductId = ProductId
		RETURN 1
		COMMIT
	END TRY
	BEGIN CATCH 
		RETURN -99
	ROLLBACK
	END CATCH 
END 
GO

DECLARE @Ret INT
EXEC @Ret = usp_Purchase 'Albert@gmail.com', 'P101' ,2 
SELECT @Ret 
ROLLBACK
	BEGIN
	PRINT 'rollback executed'
	END

drop procedure usp_Purchase
