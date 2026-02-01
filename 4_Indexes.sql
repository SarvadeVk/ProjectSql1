

/*
INDEXES
Clusteres index is automatically created for Primary key
and for other constraints non-clustered indexs are created
*/

CREATE CLUSTERED INDEX idx_roleid_roles ON Roles(RoleId)

DROP INDEX pk_RoleId ON Roles

CREATE NONCLUSTERED INDEX idx_rolename_roles ON Roles(RoleName)

select * from sys.indexes WHERE name = 'idx_rolename_roles'


CREATE NONCLUSTERED INDEX idx_productid_products ON Products(ProductId)

CREATE NONCLUSTERED INDEX idx_purchasedetails_emailid_dop ON PurchaseDetails(EmailId,DateofPurchase)

CREATE NONCLUSTERED INDEX idx_cardDetails_cardno ON cardDetails(CardNumber)

CREATE NONCLUSTERED INDEX idx_emailId_RoleId ON Users(EmailId,RoleId)