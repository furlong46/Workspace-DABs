CREATE MATERIALIZED VIEW dim_customer (
  CustomerKey	int,
  AddressType	string,
  CustomerID	int,
  AddressID	int,
  NameStyle	boolean,
  Title	string,
  FirstName	string,
  MiddleName	string,
  LastName	string,
  Suffix	string,
  CompanyName	string,
  SalesPerson	string,
  EmailAddress	string,
  Phone	string,
  PasswordHash	string,
  PasswordSalt	string,
  AddressLine1	string,
  AddressLine2	string,
  City	string,
  StateProvince	string,
  CountryRegion	string,
  PostalCode	string,
  CONSTRAINT dim_customer_pk PRIMARY KEY(CustomerKey)
)
AS
SELECT 
row_number() OVER(ORDER BY CA.CustomerID, CA.AddressID) AS CustomerKey,
CA.AddressType, CA.CustomerID, CA.AddressID,
C.* EXCEPT(C.CustomerID, C.rowguid, C.ModifiedDate),
A.* EXCEPT(A.AddressID, A.rowguid, A.ModifiedDate)
FROM
adventureworks.adventureworks.customeraddress CA
LEFT OUTER JOIN adventureworks.adventureworks.customer C ON CA.CustomerID = C.CustomerID
LEFT OUTER JOIN adventureworks.adventureworks.address A ON CA.AddressID = A.AddressID
CLUSTER BY (CustomerKey)