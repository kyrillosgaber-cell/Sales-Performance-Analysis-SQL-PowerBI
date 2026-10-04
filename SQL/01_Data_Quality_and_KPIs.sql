SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows
FROM Sales.Customers

UNION ALL

SELECT 'Invoices', COUNT(*)
FROM Sales.Invoices

UNION ALL

SELECT 'InvoiceLines', COUNT(*)
FROM Sales.InvoiceLines

UNION ALL

SELECT 'StockItems', COUNT(*)
FROM Warehouse.StockItems;
SELECT 
    MIN(InvoiceDate) AS FirstInvoiceDate,
    MAX(InvoiceDate) AS LastInvoiceDate
FROM Sales.Invoices;
SELECT
    SUM(CASE WHEN InvoiceID IS NULL THEN 1 ELSE 0 END) AS NullInvoiceID,
    SUM(CASE WHEN StockItemID IS NULL THEN 1 ELSE 0 END) AS NullStockItemID,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS NullQuantity,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS NullUnitPrice,
    SUM(CASE WHEN LineProfit IS NULL THEN 1 ELSE 0 END) AS NullLineProfit,
    SUM(CASE WHEN ExtendedPrice IS NULL THEN 1 ELSE 0 END) AS NullExtendedPrice
FROM Sales.InvoiceLines;
SELECT
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS InvalidQuantity,
    SUM(CASE WHEN UnitPrice < 0 THEN 1 ELSE 0 END) AS InvalidUnitPrice,
    SUM(CASE WHEN ExtendedPrice < 0 THEN 1 ELSE 0 END) AS NegativeExtendedPrice,
    SUM(CASE WHEN LineProfit < 0 THEN 1 ELSE 0 END) AS NegativeProfit
FROM Sales.InvoiceLines;
SELECT
    StockItemID,
    StockItemName,
    Brand,
    UnitPrice,
    RecommendedRetailPrice,
    TaxRate
FROM Warehouse.StockItems
WHERE StockItemID IN (8, 15);ٍ
SELECT
    StockItemID,
    Description,
    COUNT(*) AS LossTransactions,
    SUM(LineProfit) AS TotalLoss
FROM Sales.InvoiceLines
WHERE LineProfit < 0
GROUP BY StockItemID, Description
ORDER BY TotalLoss ASC;
SELECT
    SUM(LineProfit) AS TotalProfit,
    SUM(CASE 
        WHEN LineProfit < 0 THEN LineProfit 
        ELSE 0 
    END) AS TotalLoss,
    SUM(CASE 
        WHEN LineProfit > 0 THEN LineProfit 
        ELSE 0 
    END) AS TotalPositiveProfit
FROM Sales.InvoiceLines;
SELECT 
    InvoiceLineID,
    COUNT(*) AS DuplicateCount
FROM Sales.InvoiceLines
GROUP BY InvoiceLineID
HAVING COUNT(*) > 1;
SELECT
    SUM(CASE WHEN CustomerName IS NULL THEN 1 ELSE 0 END) AS NullCustomerName,
    SUM(CASE WHEN DeliveryCityID IS NULL THEN 1 ELSE 0 END) AS NullDeliveryCity,
    SUM(CASE WHEN CustomerCategoryID IS NULL THEN 1 ELSE 0 END) AS NullCategory,
    SUM(CASE WHEN AccountOpenedDate IS NULL THEN 1 ELSE 0 END) AS NullAccountOpenedDate
FROM Sales.Customers;
SELECT
    SUM(CASE WHEN StockItemName IS NULL THEN 1 ELSE 0 END) AS NullStockItemName,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS NullUnitPrice,
    SUM(CASE WHEN RecommendedRetailPrice IS NULL THEN 1 ELSE 0 END) AS NullRetailPrice,
    SUM(CASE WHEN TaxRate IS NULL THEN 1 ELSE 0 END) AS NullTaxRate
FROM Warehouse.StockItems;
SELECT
    SUM(CASE WHEN UnitPrice <= 0 THEN 1 ELSE 0 END) AS InvalidUnitPrice,
    SUM(CASE WHEN RecommendedRetailPrice <= 0 THEN 1 ELSE 0 END) AS InvalidRetailPrice,
    SUM(CASE WHEN TaxRate < 0 THEN 1 ELSE 0 END) AS InvalidTaxRate
FROM Warehouse.StockItems;
SELECT COUNT(*) AS InvoicesWithoutCustomer
FROM Sales.Invoices AS i
LEFT JOIN Sales.Customers AS c
    ON i.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;
SELECT COUNT(*) AS InvoiceLinesWithoutProduct
FROM Sales.InvoiceLines AS il
LEFT JOIN Warehouse.StockItems AS si
    ON il.StockItemID = si.StockItemID
WHERE si.StockItemID IS NULL;
SELECT COUNT(*) AS InvoicesBeforeAccountOpened
FROM Sales.Invoices AS i
INNER JOIN Sales.Customers AS c
    ON i.CustomerID = c.CustomerID
where i.InvoiceDate < c.AccountOpenedDate;
SELECT 
    SUM(ExtendedPrice) AS TotalRevenue, 
    SUM(LineProfit) AS TotalProfit, 
    SUM(Quantity) AS TotalQuantity, 
    COUNT(DISTINCT InvoiceID) AS TotalInvoices  
FROM Sales.InvoiceLines;
SELECT 
    SUM(ExtendedPrice) AS TotalRevenue, 
    SUM(LineProfit) AS TotalProfit, 
    SUM(Quantity) AS TotalQuantity, 
    COUNT(DISTINCT InvoiceID) AS TotalInvoices,
    (SUM(LineProfit) / SUM(ExtendedPrice)) * 100 AS ProfitMargin
FROM Sales.InvoiceLines;
SELECT
    YEAR(i.InvoiceDate) AS SalesYear,
    SUM(il.ExtendedPrice) AS TotalRevenue
FROM Sales.Invoices AS i
INNER JOIN Sales.InvoiceLines AS il
    ON i.InvoiceID = il.InvoiceID
GROUP BY YEAR(i.InvoiceDate)
ORDER BY SalesYear;
WITH YearlySales AS
(
    SELECT
        YEAR(i.InvoiceDate) AS SalesYear,
        SUM(il.ExtendedPrice) AS TotalRevenue
    FROM Sales.Invoices AS i
    INNER JOIN Sales.InvoiceLines AS il
        ON i.InvoiceID = il.InvoiceID
    GROUP BY YEAR(i.InvoiceDate)
)
SELECT 
   SalesYear,
    TotalRevenue,
    LAG(TotalRevenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue
FROM YearlySales;
WITH YearlySales AS
(
    SELECT
        YEAR(i.InvoiceDate) AS SalesYear,
        SUM(il.ExtendedPrice) AS TotalRevenue
    FROM Sales.Invoices AS i
    INNER JOIN Sales.InvoiceLines AS il
        ON i.InvoiceID = il.InvoiceID
    GROUP BY YEAR(i.InvoiceDate)
),
SalesGrowth AS
(
    SELECT
        SalesYear,
        TotalRevenue,
        LAG(TotalRevenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue
    FROM YearlySales
)
SELECT
    SalesYear,
    TotalRevenue,
    PreviousYearRevenue,
    ((TotalRevenue - PreviousYearRevenue) / PreviousYearRevenue) * 100 AS YoYGrowthPercent
FROM SalesGrowth;
SELECT 
    YEAR(i.InvoiceDate) AS SalesYear,
    MONTH(i.InvoiceDate) AS SalesMonth,
    SUM(il.ExtendedPrice) AS TotalRevenue
FROM Sales.Invoices AS i  
JOIN Sales.InvoiceLines AS il  
    ON i.InvoiceID = il.InvoiceID
GROUP BY
    YEAR(i.InvoiceDate),
    MONTH(i.InvoiceDate)
ORDER BY
    YEAR(i.InvoiceDate),
    MONTH(i.InvoiceDate);
    SELECT 
    YEAR(i.InvoiceDate) AS SalesYear,
    SUM(il.ExtendedPrice) AS YTDRevenue
FROM Sales.Invoices AS i
JOIN Sales.InvoiceLines AS il
    ON i.InvoiceID = il.InvoiceID
WHERE YEAR(i.InvoiceDate) IN (2015, 2016)
  AND MONTH(i.InvoiceDate) <= 5
GROUP BY YEAR(i.InvoiceDate)
ORDER BY SalesYear;
SELECT TOP 10
    si.StockItemName,
    SUM(il.ExtendedPrice) AS TotalRevenue
FROM Sales.InvoiceLines AS il
JOIN Warehouse.StockItems AS si
    ON il.StockItemID = si.StockItemID
GROUP BY si.StockItemName
ORDER BY TotalRevenue DESC;
SELECT TOP 10
si.StockItemName, 
SUM(il.Quantity) AS TotalQuantity
FROM Sales.InvoiceLines AS il
JOIN Warehouse.StockItems AS si
ON il.StockItemID = si.StockItemID 
GROUP BY si.StockItemName 
ORDER BY TotalQuantity DESC;
SELECT TOP 10
    si.StockItemName, 
    SUM(il.LineProfit) AS TotalProfit
FROM Sales.InvoiceLines AS il
JOIN Warehouse.StockItems AS si
    ON il.StockItemID = si.StockItemID 
GROUP BY si.StockItemName 
ORDER BY TotalProfit DESC;
SELECT TOP 10 
    c.CustomerName,
    SUM(il.ExtendedPrice) AS TotalRevenue
FROM Sales.Customers AS c
JOIN Sales.Invoices AS i
    ON c.CustomerID = i.CustomerID
JOIN Sales.InvoiceLines AS il
    ON i.InvoiceID = il.InvoiceID
GROUP BY c.CustomerName
ORDER BY TotalRevenue DESC;
SELECT TOP 10 
    city.CityName,
    SUM(il.ExtendedPrice) AS TotalRevenue  
FROM Application.Cities AS city  
JOIN Sales.Customers AS c  
    ON city.CityID = c.DeliveryCityID  
JOIN Sales.Invoices AS i  
    ON c.CustomerID = i.CustomerID  
JOIN Sales.InvoiceLines AS il  
    ON i.InvoiceID = il.InvoiceID  
GROUP BY city.CityName  
ORDER BY TotalRevenue DESC;
SELECT 
    cc.CustomerCategoryName,
    SUM(il.ExtendedPrice) AS TotalRevenue  
FROM Sales.CustomerCategories AS cc  
JOIN Sales.Customers AS c  
    ON cc.CustomerCategoryID = c.CustomerCategoryID  
JOIN Sales.Invoices AS i  
    ON c.CustomerID = i.CustomerID  
JOIN Sales.InvoiceLines AS il  
    ON i.InvoiceID = il.InvoiceID  
GROUP BY cc.CustomerCategoryName
ORDER BY TotalRevenue DESC;
SELECT 
    cc.CustomerCategoryName,
    SUM(il.ExtendedPrice) AS TotalRevenue,
    (SUM(il.ExtendedPrice) /
     SUM(SUM(il.ExtendedPrice)) OVER ()) * 100 AS RevenueSharePercent
FROM Sales.CustomerCategories AS cc  
JOIN Sales.Customers AS c  
    ON cc.CustomerCategoryID = c.CustomerCategoryID  
JOIN Sales.Invoices AS i  
    ON c.CustomerID = i.CustomerID  
JOIN Sales.InvoiceLines AS il  
    ON i.InvoiceID = il.InvoiceID  
GROUP BY cc.CustomerCategoryName
ORDER BY TotalRevenue DESC;
SELECT TOP 10 
    c.CustomerName,
    COUNT(DISTINCT i.InvoiceID) AS InvoiceCount  
FROM Sales.Customers AS c  
JOIN Sales.Invoices AS i  
    ON c.CustomerID = i.CustomerID  
GROUP BY c.CustomerName  
ORDER BY InvoiceCount DESC;
SELECT 
    c.CustomerName,
    COUNT(DISTINCT i.InvoiceID) AS InvoiceCount  
FROM Sales.Customers AS c  
JOIN Sales.Invoices AS i  
    ON c.CustomerID = i.CustomerID  
GROUP BY c.CustomerName, c.CustomerID
HAVING COUNT(DISTINCT i.InvoiceID) > 1
ORDER BY InvoiceCount DESC;
WITH CustomerOrders AS
(
    SELECT 
        c.CustomerName,
        COUNT(DISTINCT i.InvoiceID) AS InvoiceCount
    FROM Sales.Customers AS c
    JOIN Sales.Invoices AS i
        ON c.CustomerID = i.CustomerID
    GROUP BY c.CustomerName, c.CustomerID
    HAVING COUNT(DISTINCT i.InvoiceID) > 1
)
SELECT
    COUNT(*) AS RepeatCustomers
FROM CustomerOrders;
WITH CustomerOrders AS
(
    SELECT 
        c.CustomerName,
        COUNT(DISTINCT i.InvoiceID) AS InvoiceCount
    FROM Sales.Customers AS c
    JOIN Sales.Invoices AS i
        ON c.CustomerID = i.CustomerID
    GROUP BY c.CustomerName, c.CustomerID
    HAVING COUNT(DISTINCT i.InvoiceID) > 1
)
SELECT
    COUNT(*) AS RepeatCustomers,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Sales.Customers)) 
        AS RepeatCustomerRate
FROM CustomerOrders;
SELECT 
    SUM(ExtendedPrice) / COUNT(DISTINCT InvoiceID) AS AverageOrderValue
FROM Sales.InvoiceLines;
SELECT 
    si.StockItemName,
    SUM(il.ExtendedPrice) AS TotalRevenue,
    SUM(il.LineProfit) AS TotalProfit,
    SUM(il.LineProfit) / SUM(il.ExtendedPrice) * 100 AS ProfitMarginPercent
FROM Sales.InvoiceLines AS il  
JOIN Warehouse.StockItems AS si  
    ON il.StockItemID = si.StockItemID
GROUP BY si.StockItemName
ORDER BY ProfitMarginPercent DESC;
SELECT TOP 10
    si.StockItemName,   
    SUM(il.ExtendedPrice) AS TotalRevenue
FROM Sales.InvoiceLines AS il 
JOIN Warehouse.StockItems AS si 
    ON il.StockItemID = si.StockItemID 
GROUP BY si.StockItemName 
ORDER BY TotalRevenue ASC;
SELECT TOP 10
    si.StockItemName,   
    SUM(il.LineProfit) AS TotalProfit  
FROM Sales.InvoiceLines AS il 
JOIN Warehouse.StockItems AS si 
    ON il.StockItemID = si.StockItemID 
GROUP BY si.StockItemName 
ORDER BY TotalProfit ASC;
SELECT 
si.StockItemName,
SUM(il.LineProfit) AS TotalProfit
FROM Sales.InvoiceLines AS il
JOIN Warehouse.StockItems AS si
ON il.StockItemID = si.StockItemID
GROUP BY si.StockItemName 
HAVING SUM(il.LineProfit) < 0 
ORDER BY TotalProfit ASC;
SELECT 
si.StockItemName, 
SUM(il.LineProfit) AS TotalProfit, 
SUM(il.ExtendedPrice) AS TotalRevenue, 
SUM(il.Quantity) AS TotalQuantity, 
SUM(il.LineProfit) / SUM(il.ExtendedPrice) * 100 AS ProfitMarginPercent
FROM Sales.InvoiceLines AS il 
JOIN Warehouse.StockItems AS si
ON il.StockItemID = si.StockItemID
GROUP BY si.StockItemName
HAVING SUM(il.LineProfit) < 0 
ORDER BY TotalProfit ASC;
CREATE VIEW dbo.vw_SalesDetail
AS
SELECT 
    i.InvoiceID, 
    i.InvoiceDate, 
    c.CustomerName, 
    city.CityName, 
    si.StockItemName, 
    il.Quantity, 
    il.UnitPrice, 
    il.ExtendedPrice, 
    il.LineProfit
FROM Sales.InvoiceLines AS il  
JOIN Sales.Invoices AS i  
    ON il.InvoiceID = i.InvoiceID  
JOIN Sales.Customers AS c  
    ON i.CustomerID = c.CustomerID  
JOIN Application.Cities AS city  
    ON c.DeliveryCityID = city.CityID  
JOIN Warehouse.StockItems AS si  
    ON il.StockItemID = si.StockItemID;
ALTER VIEW dbo.vw_SalesDetail
AS

SELECT
    i.InvoiceID,
    i.InvoiceDate,

    c.CustomerID,
    c.CustomerName,

    cc.CustomerCategoryID,
    cc.CustomerCategoryName,

    city.CityID,
    city.CityName,

    si.StockItemID,
    si.StockItemName,

    il.Quantity,
    il.UnitPrice,
    il.ExtendedPrice,
    il.LineProfit

FROM Sales.InvoiceLines AS il

JOIN Sales.Invoices AS i
    ON il.InvoiceID = i.InvoiceID

JOIN Sales.Customers AS c
    ON i.CustomerID = c.CustomerID

JOIN Sales.CustomerCategories AS cc
    ON c.CustomerCategoryID = cc.CustomerCategoryID

JOIN Application.Cities AS city
    ON c.DeliveryCityID = city.CityID

JOIN Warehouse.StockItems AS si
    ON il.StockItemID = si.StockItemID;
SELECT 
    YEAR(i.InvoiceDate) AS SalesYear,
    MONTH(i.InvoiceDate) AS SalesMonth,
    SUM(il.ExtendedPrice) AS TotalRevenue,
    SUM(il.LineProfit) AS TotalProfit,
    SUM(il.Quantity) AS TotalQuantity,
    COUNT(DISTINCT i.InvoiceID) AS TotalInvoices
FROM Sales.Invoices AS i
JOIN Sales.InvoiceLines AS il
    ON i.InvoiceID = il.InvoiceID
GROUP BY
    YEAR(i.InvoiceDate),
    MONTH(i.InvoiceDate)
ORDER BY
    SalesYear,
    SalesMonth;
CREATE VIEW dbo.vw_MonthlySales
AS

SELECT 
    YEAR(i.InvoiceDate) AS SalesYear,
    MONTH(i.InvoiceDate) AS SalesMonth,
    SUM(il.ExtendedPrice) AS TotalRevenue,
    SUM(il.LineProfit) AS TotalProfit,
    SUM(il.Quantity) AS TotalQuantity,
    COUNT(DISTINCT i.InvoiceID) AS TotalInvoices
FROM Sales.Invoices AS i
JOIN Sales.InvoiceLines AS il
    ON i.InvoiceID = il.InvoiceID
GROUP BY
    YEAR(i.InvoiceDate),
    MONTH(i.InvoiceDate);
CREATE VIEW dbo.vw_ProductPerformance
AS
SELECT 
    si.StockItemID,    
    si.StockItemName,
    SUM(il.ExtendedPrice) AS TotalRevenue,
    SUM(il.LineProfit) AS TotalProfit,
    SUM(il.Quantity) AS TotalQuantity,
    SUM(il.LineProfit) / SUM(il.ExtendedPrice) * 100 AS ProfitMarginPercent
FROM Sales.InvoiceLines AS il  
JOIN Warehouse.StockItems AS si  
    ON il.StockItemID = si.StockItemID  
GROUP BY
    si.StockItemID,
    si.StockItemName;
CREATE VIEW dbo.vw_CustomerPerformance
AS
SELECT 
    c.CustomerID,
    c.CustomerName,
    cc.CustomerCategoryName,
    city.CityName,
    SUM(il.ExtendedPrice) AS TotalRevenue,
    SUM(il.LineProfit) AS TotalProfit,
    COUNT(DISTINCT i.InvoiceID) AS TotalInvoices,
    SUM(il.ExtendedPrice) / COUNT(DISTINCT i.InvoiceID) AS AverageOrderValue
FROM Sales.Customers AS c
JOIN Sales.CustomerCategories AS cc
    ON c.CustomerCategoryID = cc.CustomerCategoryID
JOIN Sales.Invoices AS i
    ON c.CustomerID = i.CustomerID
JOIN Sales.InvoiceLines AS il
    ON i.InvoiceID = il.InvoiceID
JOIN Application.Cities AS city
    ON c.DeliveryCityID = city.CityID
GROUP BY
    c.CustomerID,
    c.CustomerName,
    cc.CustomerCategoryName,
    city.CityName;