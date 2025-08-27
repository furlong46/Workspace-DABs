CREATE MATERIALIZED VIEW fact_internetsales (
ProductKey	int,
Order_DateKey	int,
Ship_DateKey	int,
Due_DateKey	int,
Ship_CustomerKey	int,
Bill_CustomerKey	int,
SalesOrderID	int,
RevisionNumber	int,
OrderDate	timestamp,
DueDate	timestamp,
ShipDate	timestamp,
Status	int,
OnlineOrderFlag	boolean,
SalesOrderNumber	string,
PurchaseOrderNumber	string,
AccountNumber	string,
CustomerID	int,
ShipToAddressID	int,
BillToAddressID	int,
ShipMethod	string,
CreditCardApprovalCode	string,
SubTotal	decimal(19,4),
TaxAmt	decimal(19,4),
Freight	decimal(19,4),
TotalDue	decimal(19,4),
Comment	string,
rowguid	string,
ModifiedDate	timestamp,
ProductID	int,
SalesOrderDetailID	int,
OrderQty	smallint,
UnitPrice	decimal(19,4),
UnitPriceDiscount	decimal(19,4),
LineTotal	decimal(38,6),
CONSTRAINT productkey_not_null EXPECT (ProductKey IS NOT NULL) ON VIOLATION FAIL UPDATE,
CONSTRAINT ship_datekey_not_null EXPECT (Ship_DateKey IS NOT NULL) ON VIOLATION FAIL UPDATE,
CONSTRAINT ship_customerkey_not_null EXPECT (ProductKey IS NOT NULL) ON VIOLATION FAIL UPDATE,
CONSTRAINT dim_product_fk
    FOREIGN KEY(ProductKey) REFERENCES dim_product
    NOT ENFORCED RELY,
CONSTRAINT ship_dim_customer_fk
    FOREIGN KEY(Ship_CustomerKey) REFERENCES dim_customer
    NOT ENFORCED RELY,
CONSTRAINT dim_date_fk
    FOREIGN KEY(Ship_DateKey) REFERENCES dim_date
    NOT ENFORCED RELY
)
 AS
SELECT 
  DP.ProductKey, 
  date_format(SOH.OrderDate, 'yyyyMMdd')::int AS Order_DateKey,
  date_format(SOH.ShipDate, 'yyyyMMdd')::int AS Ship_DateKey,
  date_format(SOH.DueDate, 'yyyyMMdd')::int AS Due_DateKey,
  DC_Ship.CustomerKey AS Ship_CustomerKey,
  DC_Bill.CustomerKey AS Bill_CustomerKey,
  SOH.*, 
  SOD.ProductID, SOD.SalesOrderDetailID, SOD.OrderQty, SOD.UnitPrice, SOD.UnitPriceDiscount, SOD.LineTotal 
FROM
adventureworks.adventureworks.salesorderheader SOH
INNER JOIN adventureworks.adventureworks.salesorderdetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT OUTER JOIN dim_product DP ON SOD.ProductID = DP.ProductID
LEFT OUTER JOIN dim_customer DC_Ship ON SOH.CustomerID = DC_Ship.CustomerID AND SOH.ShipToAddressID = DC_Ship.AddressID
LEFT OUTER JOIN dim_customer DC_Bill ON SOH.CustomerID = DC_Bill.CustomerID AND SOH.BillToAddressID = DC_Bill.AddressID
CLUSTER BY (ProductKey, Order_DateKey, Ship_CustomerKey)