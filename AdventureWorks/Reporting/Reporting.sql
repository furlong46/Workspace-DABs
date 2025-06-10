CREATE OR REPLACE TABLE adventureworks.adventureworksdw.fact_internetsales_productagg
AS
SELECT DP.EnglishProductName, DD.YearMonthInt, SUM(FIS.TotalDue) AS Sales
FROM
adventureworks.adventureworksdw.fact_internetsales FIS
INNER JOIN adventureworks.adventureworksdw.dim_product DP ON FIS.ProductKey = DP.ProductKey
INNER JOIN adventureworks.adventureworksdw.dim_date DD ON FIS.Order_DateKey = DD.DateKey
GROUP BY ALL