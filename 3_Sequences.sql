
USE Quickcart;
/*
Sequence is similar to Identity
but not specific to a table it's independent of tables
default data type of sequence is BIGINT
default cycle is 0 and cache is null

SELECT NEXT VALUE FOR Purchase_Sequence 
           AS Next_Value -- NEXT VALUE FOR is used to fetch the next value 
                         -- for the given sequence

*/

CREATE SEQUENCE purchase_sequence

SELECT * FROM sys.sequences WHERE name = 'purchase_sequence'

SELECT NEXT VALUE FOR PURCHASE_SEQUENCE AS NEXT_VALUE

SELECT NAME, START_VALUE, INCREMENT, MINIMUM_VALUE, MAXIMUM_VALUE, CURRENT_VALUE FROM sys.sequences WHERE name = 'purchase_sequence'

DROP SEQUENCE purchase_sequence

CREATE SEQUENCE purchase_sequence
AS INT 
START WITH 10
INCREMENT BY 1 

ALTER SEQUENCE purchase_sequence
MINVALUE 1
MAXVALUE 5000

ALTER SEQUENCE purchase_sequence CYCLE

SELECT NAME, START_VALUE, INCREMENT, MINIMUM_VALUE, MAXIMUM_VALUE, CURRENT_VALUE,is_cycling FROM sys.sequences WHERE name = 'purchase_sequence'

ALTER SEQUENCE purchase_sequence CACHE 50

SELECT NAME, START_VALUE, INCREMENT, MINIMUM_VALUE, MAXIMUM_VALUE, CURRENT_VALUE,is_cycling, is_cached,cache_size FROM sys.sequences WHERE name = 'purchase_sequence'

-----tables-------

CREATE TABLE PurchaseDetailsIndia 
(
	[PurchaseId] INT,
	[EmailID] VARCHAR(50) CONSTRAINT fk_emailid_ind REFERENCES users(EmailID),
	[ProductID] CHAR(4) CONSTRAINT fk_productid_ind REFERENCES Products(ProductId),
	[QuantityPruchased] SMALLINT CONSTRAINT ck_qp_ind CHECK (QuantityPruchased>0) NOT NULL,
	[DateOfPurchase] SMALLDATETIME CONSTRAINT ck_dop_ind CHECK (DateOfPurchase<= GETDATE()) DEFAULT GETDATE() NOT NULL
)
GO

CREATE TABLE PurchaseDetailsUK
(
	[PurchaseId] INT,
	[EmailID] VARCHAR(50) CONSTRAINT fk_emailid_uk REFERENCES users(EmailID),
	[ProductID] CHAR(4) CONSTRAINT fk_productid_uk REFERENCES Products(ProductId),
	[QuantityPruchased] SMALLINT CONSTRAINT ck_qp_uk CHECK (QuantityPruchased>0) NOT NULL,
	[DateOfPurchase] SMALLDATETIME CONSTRAINT ck_dop_uk CHECK (DateOfPurchase<= GETDATE()) DEFAULT GETDATE() NOT NULL
)
GO

INSERT INTO PurchaseDetailsIndia VALUES
(NEXT VALUE FOR Purchase_Sequence,'Franken@gmail.com','P101',2,'Jan 12 2014 12:00PM')
INSERT INTO PurchaseDetailsUK VALUES
(NEXT VALUE FOR Purchase_Sequence,'Albert@gmail.com','P143',1,'Jan 13 2014 12:01PM')
INSERT INTO PurchaseDetailsIndia VALUES
(NEXT VALUE FOR Purchase_Sequence,'Franken@gmail.com','P112',3,'Jan 14 2014 12:02PM')


select * from PurchaseDetailsIndia
select * from PurchaseDetailsUK

DELETE PurchaseDetailsIndia
DELETE  PurchaseDetailsUK