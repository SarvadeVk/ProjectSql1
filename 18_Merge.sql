

CREATE TABLE ProductsOrdered(
[ProductId] CHAR(4),
[ProductName] VARCHAR(50),
[CategoryId] TINYINT,
[Price] NUMERIC(8),
[QuantityOrdered] INT)

INSERT INTO ProductsOrdered VALUES('P156','Clever sticks',7,400.00,10)
INSERT INTO ProductsOrdered VALUES('P158','Swim suit',6,700.00,100)


--In order to use MERGE statement, we need a target table and a source table.
--Target table is the one where the data needs to be modified and source table is the data source that is matched with the rows in the target table.

MERGE Products as TARGET
USING ProductsOrdered as SOURCE
ON TARGET.PRODUCTID = SOURCE.PRODUCTID
WHEN MATCHED THEN
UPDATE SET QuantityAvailable = QuantityAvailable + source.QuantityOrdered
WHEN NOT MATCHED THEN
INSERT VALUES (SOURCE.ProductID,SOURCE.ProductName,SOURCE.CategoryId,SOURCE.Price,SOURCE.QuantityOrdered);

SELECT * FROM Products