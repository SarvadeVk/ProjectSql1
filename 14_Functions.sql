use Quickcart;
--Functions

--Scalar Function

CREATE FUNCTION ufn_GenerateNewProductId()  -- function to show new productid based on productid present in table
RETURNS CHAR(4)
AS
BEGIN
	DECLARE @ProductId CHAR(4) 
	IF NOT EXISTS (SELECT PRODUCTID FROM PRODUCTS)
		SET @ProductId = 'P101'
	ELSE
		SELECT @ProductId = 'P' + CAST(CAST(SUBSTRING(MAX(PRODUCTID),2,3) AS INT) +1 AS CHAR)
		FROM Products
	RETURN @ProductId
END
GO

DECLARE @result CHAR(4)
EXEC @result = dbo.ufn_GenerateNewProductId --calling function
SELECT @result as res

SELECT dbo.ufn_GenerateNewProductId() as res  --calling function

--1

CREATE FUNCTION ufn_CheckEmailId(@EmailId VARCHAR(50))  --function to check the EmailId is available to use or already used
RETURNS BIT
AS 
BEGIN 
	DECLARE @return BIT
	IF EXISTS (SELECT Emailid FROM users WHERE @EmailId = Emailid)
		SET @return  = 1
	ELSE 
		SET @return = 0
	RETURN @return
END
GO

DROP FUNCTION dbo.ufn_CheckEmailId

SELECT dbo.ufn_CheckEmailId ('Anabela@gmail.com') as res
	
--SELECT * FROM users

--2
--This function is used to validate the user credentials and return appropriate values

CREATE FUNCTION ufn_ValidateUserCredentials
(@Emailid VARCHAR(50),@password VARCHAR(20))
RETURNS INT
AS 
BEGIN
DECLARE @roleid INT
IF NOT EXISTS(SELECT EmailId,UserPassword FROM users WHERE Emailid = @Emailid AND UserPassword = @password)
BEGIN
	SET @roleid = -1
END
ELSE
BEGIN
	SET @roleid = (SELECT ROLEID FROM Users WHERE Emailid = @Emailid AND UserPassword = @password)
END
RETURN @roleid 
END
GO

SELECT dbo.ufn_ValidateUserCredentials('Albert@gmail.com','ILAS@1234') as roleid
SELECT dbo.ufn_ValidateUserCredentials('Anzio_Don@infosys.com','don@123') as roleid

--SELECT * FROM users



