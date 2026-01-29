

/*

Temporary Tables

# - local temporary object
## - global temporary object
*/

CREATE TABLE #Cart -- Local temporary table
(
    ProductId CHAR(4)
)

INSERT INTO #Cart VALUES('P101')
INSERT INTO #Cart VALUES('P102')
INSERT INTO #Cart VALUES('P103')

SELECT * FROM #Cart
--Now User2 logs in. But he won’t be able to view the products that are added in the cart by User1


CREATE TABLE ##CartNew  --global temporary table
(
    ProductId CHAR(4)
)
GO

INSERT INTO ##CartNew VALUES('P104')
INSERT INTO ##CartNew VALUES('P105')
INSERT INTO ##CartNew VALUES('P106')

SELECT * FROM ##CartNew

--when a global temporary table is created, it can be accessed by any SQL Server connection.
-- globals are visible to all servers
