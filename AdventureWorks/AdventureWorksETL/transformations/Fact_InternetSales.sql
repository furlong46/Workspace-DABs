-- Please edit the sample below

CREATE MATERIALIZED VIEW fact_internetsales AS
SELECT 
  DP.ProductKey, 
  SOH.*, 
  SOD.ProductID, SOD.SalesOrderDetailID, SOD.OrderQty, SOD.UnitPrice, SOD.UnitPriceDiscount, SOD.LineTotal 
FROM
adventureworks.adventureworks_bronze.salesorderheader SOH
INNER JOIN adventureworks.adventureworks_bronze.salesorderdetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT OUTER JOIN adventureworks.adventureworksdw.dim_product DP ON SOD.ProductID = DP.ProductID