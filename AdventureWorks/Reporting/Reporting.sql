CREATE OR REPLACE TABLE adventureworks.adventureworks_dw.fact_internetsales_productagg
AS
SELECT DP.EnglishProductName, DD.YearMonthInt, SUM(FIS.TotalDue) AS Sales
FROM
adventureworks.adventureworks_dw.fact_internetsales FIS
INNER JOIN adventureworks.adventureworks_dw.dim_product DP ON FIS.ProductKey = DP.ProductKey
INNER JOIN adventureworks.adventureworks_dw.dim_date DD ON FIS.Order_DateKey = DD.DateKey
GROUP BY ALL