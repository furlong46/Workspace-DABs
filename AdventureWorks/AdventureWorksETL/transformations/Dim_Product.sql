-- Please edit the sample below

CREATE MATERIALIZED VIEW dim_product AS
WITH DESCLookup AS (
SELECT 
PMPD.ProductModelID,
PMPD.Culture,
PD.Description
FROM 
adventureworks.adventureworks.productmodelproductdescription PMPD
LEFT OUTER JOIN adventureworks.adventureworks.productdescription PD ON PMPD.ProductDescriptionID = PD.ProductDescriptionID
)
,
Source AS (
SELECT 
       P.ProductID
      ,P.ProductNumber AS ProductAlternateKey
      ,P.ProductCategoryID AS ProductSubcategoryKey
      ,'' AS WeightUnitMeasureCode
      ,'' AS SizeUnitMeasureCode
      ,P.Name AS EnglishProductName
      ,P.StandardCost AS StandardCost
      ,1 AS FinishedGoodsFlag
      ,P.Color AS Color
      ,'' AS SafetyStockLevel
      ,'' AS ReorderPoint
      ,P.ListPrice AS ListPrice
      ,P.Size AS Size
      ,'' AS SizeRange
      ,P.Weight AS Weight
      ,'' AS DaysToManufacture
      ,'' AS ProductLine
      ,'' AS DealerPrice
      ,'' AS Class
      ,'' AS Style
      ,PM.Name AS ModelName
      ,PDEN.Description AS EnglishDescription
      ,PDFR.Description AS FrenchDescription
      ,PDCH.Description AS ChineseDescription
      ,PDAR.Description AS ArabicDescription
      ,PDHE.Description AS HebrewDescription
      ,PDTH.Description AS ThaiDescription
      ,'' AS GermanDescription
      ,'' AS JapaneseDescription
      ,'' AS TurkishDescription
      ,P.SellStartDate AS StartDate
      ,P.SellEndDate AS EndDate
      ,CASE WHEN P.SellEndDate IS NULL THEN 'Current' ELSE '' END AS Status
FROM 
adventureworks.adventureworks.product P
LEFT OUTER JOIN adventureworks.adventureworks.productcategory PC ON P.ProductCategoryID = PC.ProductCategoryID
LEFT OUTER JOIN adventureworks.adventureworks.productmodel PM ON P.ProductModelID = PM.ProductModelID
LEFT OUTER JOIN (SELECT ProductModelID, Description FROM DESCLookup WHERE TRIM(Culture) = 'en') PDEN ON P.ProductModelID = PDEN.ProductModelID
LEFT OUTER JOIN (SELECT ProductModelID, Description FROM DESCLookup WHERE TRIM(Culture) = 'ar') PDAR ON P.ProductModelID = PDAR.ProductModelID
LEFT OUTER JOIN (SELECT ProductModelID, Description FROM DESCLookup WHERE TRIM(Culture) = 'fr') PDFR ON P.ProductModelID = PDFR.ProductModelID
LEFT OUTER JOIN (SELECT ProductModelID, Description FROM DESCLookup WHERE TRIM(Culture) = 'he') PDHE ON P.ProductModelID = PDHE.ProductModelID
LEFT OUTER JOIN (SELECT ProductModelID, Description FROM DESCLookup WHERE TRIM(Culture) = 'zh-cht') PDCH ON P.ProductModelID = PDCH.ProductModelID
LEFT OUTER JOIN (SELECT ProductModelID, Description FROM DESCLookup WHERE TRIM(Culture) = 'th') PDTH ON P.ProductModelID = PDTH.ProductModelID
)

SELECT row_number() OVER (ORDER BY ProductID) AS ProductKey, *
FROM Source
CLUSTER BY (ProductKey)