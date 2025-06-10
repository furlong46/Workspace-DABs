-- Please edit the sample below

CREATE MATERIALIZED VIEW dim_customer AS
SELECT 
row_number() OVER(ORDER BY CA.CustomerID, CA.AddressID) AS CustomerKey,
CA.AddressType, CA.CustomerID, CA.AddressID,
C.* EXCEPT(C.CustomerID, C.rowguid, C.ModifiedDate),
A.* EXCEPT(A.AddressID, A.rowguid, A.ModifiedDate)
FROM
adventureworks.adventureworks.customeraddress CA
LEFT OUTER JOIN adventureworks.adventureworks.customer C ON CA.CustomerID = C.CustomerID
LEFT OUTER JOIN adventureworks.adventureworks.address A ON CA.AddressID = A.AddressID