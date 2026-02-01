use Quickcart

-------------------------------------------------------READ COMMITED-------------------------------------------------------- 

SELECT * INTO TempProducts FROM Products

SELECT * FROM TempProducts

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRAN
    UPDATE TempProducts SET QuantityAvailable = QuantityAvailable-10 WHERE ProductId = 'P101'
	ROLLBACK

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

/*
Now try to execute the same SELECT query again as Customer2.

SELECT * FROM TempProducts WHERE ProductId = 'P101'
Output:

Now the first update is rolled back using ROLLBACK by Customer1.

BEGIN TRAN
     UPDATE TempProducts SET QuantityAvailable = QuantityAvailable - 10 
     WHERE ProductId='P101'
ROLLBACK
The Customer2 tries to execute the same SELECT query again. and gets diffrent output.

SELECT * FROM TempProducts WHERE ProductId = 'P101'
Output:

Now, for Customer2, the same query returns different data when executed twice.

The isolation level READ UNCOMMITTED allows user to read uncommitted data which maybe changed anytime. This is called as Dirty Read problem.

This problem of Dirty Read can be solved using the isolation level READ COMMITTED.
*/

--------------------------------------------------REPEATABLE READ---------------------------------------------------

--server1
BEGIN TRAN
	SELECT productid,quantityAvailable from TempProducts where ProductId = 'P101'

--server2
UPDATE TempProducts SET QuantityAvailable = QuantityAvailable - 10 WHERE ProductId = 'P101'

--Now if the Customer1 tries to view the details again by executing the same SELECT query, the output is different.

BEGIN TRAN
    SELECT ProductId, QuantityAvailable FROM TempProducts WHERE ProductId = 'P101'

--Such a problem is called as Non-repeatable read. It can be solved by using the isolation level REPEATABLE READ.

--Now, the Customer1 rolls back the active transaction and updates the QuantityAvailable to 10 again. Also, the isolation level is set to REPEATABLE READ.

BEGIN TRAN
    SELECT ProductId, QuantityAvailable FROM TempProducts WHERE ProductId = 'P101'
ROLLBACK
UPDATE TempProducts SET QuantityAvailable = 10 WHERE ProductId = 'P101' 
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ


--Now, Customer1 starts a transaction again and executes the same SELECT query as before.

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ 
BEGIN TRAN
    SELECT ProductId, QuantityAvailable FROM TempProducts WHERE ProductId = 'P101'

--Next, the Customer2 again updates the QuantityAvailable as shown below:

UPDATE TempProducts SET QuantityAvailable = QuantityAvailable - 10 WHERE ProductId = 'P101'

--But as it can be seen, that this update query is in executing status. 
--This query execution will be complete only when Customer1 completes the active transaction.

--Thus the problem of non-repeatable read is solved by the isolation level REPEATABLE READ.

------------------------------------------------------SERIALIZABLE--------------------------------------------------------------

--Before and after execution of the INSERT statement, if the Customer1 executes the below SELECT query, different results are fetched.
--Such a problem is called as Phantom Read.

--This concurrency problem of Phantom Read can be solved by the isolation level SERIALIZABLE,
--which does not allow any INSERT OR DELETE when data is being read by a transaction.


--The isolation level can be set to SERIALIZABLE by a Customer and 
--the following SELECT query is executed to view the products whose name starts with B.

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN
    SELECT ProductId, ProductName FROM TempProducts WHERE ProductName LIKE 'B%'

--Now Admin adds a new product to the TempProducts table as follows:

INSERT INTO TempProducts VALUES('P158','Barbie set',7,1280,32)

--But this query does not complete its execution because the isolation level is SERIALIZABLE. 
--Hence it goes into WAIT state till Customer completes the Read transaction.

--Once the Customer completes the transaction, the INSERT query fired by Admin is completed automatically as shown below.

BEGIN TRAN
    SELECT ProductId, ProductName FROM TempProducts WHERE ProductName LIKE 'B%' 
COMMIT


/*
--customer 2 queries

SELECT * FROM TempProducts WHERE ProductId = 'P101'

UPDATE TempProducts SET QuantityAvailable = QuantityAvailable +10 WHERE ProductId = 'P101'

INSERT INTO TempProducts VALUES('P159','barbie set',7,1280,32)

DELETE TempProducts WHERE ProductId in ('P158','P159')

*/

