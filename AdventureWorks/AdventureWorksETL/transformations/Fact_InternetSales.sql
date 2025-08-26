-- ProductKey	int
-- Order_DateKey	string
-- Ship_DateKey	string
-- Due_DateKey	string
-- Ship_CustomerKey	int
-- Bill_CustomerKey	int
-- SalesOrderID	int
-- RevisionNumber	int
-- OrderDate	timestamp
-- DueDate	timestamp
-- ShipDate	timestamp
-- Status	int
-- OnlineOrderFlag	boolean
-- SalesOrderNumber	string
-- PurchaseOrderNumber	string
-- AccountNumber	string
-- CustomerID	int
-- ShipToAddressID	int
-- BillToAddressID	int
-- ShipMethod	string
-- CreditCardApprovalCode	varchar(15)
-- SubTotal	decimal(19,4)
-- TaxAmt	decimal(19,4)
-- Freight	decimal(19,4)
-- TotalDue	decimal(19,4)
-- Comment	string
-- rowguid	varchar(36)
-- ModifiedDate	timestamp
-- ProductID	int
-- SalesOrderDetailID	int
-- OrderQty	smallint
-- UnitPrice	decimal(19,4)
-- UnitPriceDiscount	decimal(19,4)
-- LineTotal	decimal(38,6)
CREATE MATERIALIZED VIEW fact_internetsales AS
SELECT 
  DP.ProductKey, 
  date_format(SOH.OrderDate, 'yyyyMMdd') AS Order_DateKey,
  date_format(SOH.ShipDate, 'yyyyMMdd') AS Ship_DateKey,
  date_format(SOH.DueDate, 'yyyyMMdd') AS Due_DateKey,
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