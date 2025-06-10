-- Please edit the sample below

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
-- Please edit the sample below 