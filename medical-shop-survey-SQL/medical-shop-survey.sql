-- Medical Shop Sales and Profit Analysis Project

-- 1. Database Schema Design

-- Create table for Products
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    Stock INT
);

-- Create table for Sales
CREATE TABLE Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    QuantitySold INT,
    SaleDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create table for Profit
CREATE TABLE Profit (
    ProfitID INT AUTO_INCREMENT PRIMARY KEY,
    SaleID INT,
    CostPrice DECIMAL(10, 2),
    SellingPrice DECIMAL(10, 2),
    ProfitAmount DECIMAL(10, 2),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID)
);

-- 2. Preloaded Data

-- Insert initial product data
INSERT INTO Products (ProductName, Category, Price, Stock) 
VALUES 
('Paracetamol', 'Tablet', 2.50, 100),
('Cough Syrup', 'Syrup', 50.00, 50),
('Antibiotic Cream', 'Ointment', 30.00, 20),
('Vitamin C Tablets', 'Supplement', 15.00, 200),
('Pain Relief Spray', 'Spray', 100.00, 80),
('Hand Sanitizer', 'Hygiene', 25.00, 150),
('Face Mask', 'Hygiene', 5.00, 300);

-- Insert sales transactions
INSERT INTO Sales (ProductID, QuantitySold, SaleDate, TotalAmount)
VALUES 
(1, 10, '2025-01-07', 25.00),
(2, 5, '2025-01-07', 250.00),
(3, 2, '2025-01-08', 60.00),
(4, 20, '2025-01-09', 300.00),
(5, 10, '2025-01-10', 1000.00),
(6, 15, '2025-01-11', 375.00),
(7, 50, '2025-01-12', 250.00),
(1, 5, '2025-01-13', 12.50),
(4, 10, '2025-01-14', 150.00),
(6, 30, '2025-01-15', 750.00),
(7, 100, '2025-01-16', 500.00);

-- Insert profit data
INSERT INTO Profit (SaleID, CostPrice, SellingPrice, ProfitAmount)
VALUES 
(1, 20.00, 25.00, 5.00),
(2, 200.00, 250.00, 50.00),
(3, 50.00, 60.00, 10.00),
(4, 250.00, 300.00, 50.00),
(5, 800.00, 1000.00, 200.00),
(6, 300.00, 375.00, 75.00),
(7, 200.00, 250.00, 50.00),
(8, 10.00, 12.50, 2.50),
(9, 120.00, 150.00, 30.00),
(10, 600.00, 750.00, 150.00),
(11, 400.00, 500.00, 100.00);

-- 3. Analysis Queries

-- Total Sales Analysis
SELECT SUM(TotalAmount) AS TotalSales FROM Sales;

-- Total Profit Analysis
SELECT SUM(ProfitAmount) AS TotalProfit FROM Profit;

-- Inventory Management
SELECT ProductName, Stock FROM Products WHERE Stock < 10;

-- Sales by Product
SELECT P.ProductName, SUM(S.QuantitySold) AS TotalSold
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.ProductName;

-- Monthly Sales Report
SELECT DATE_FORMAT(SaleDate, '%Y-%m') AS SaleMonth, SUM(TotalAmount) AS MonthlySales
FROM Sales
GROUP BY SaleMonth;

-- Month with Highest Sales
SELECT DATE_FORMAT(SaleDate, '%Y-%m') AS SaleMonth, SUM(TotalAmount) AS MonthlySales
FROM Sales
GROUP BY SaleMonth
ORDER BY MonthlySales DESC
LIMIT 1;

-- Best-selling Product
SELECT P.ProductName, SUM(S.QuantitySold) AS TotalSold
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalSold DESC
LIMIT 1;

-- Product with Highest Sales
SELECT P.ProductName, TotalSold AS HighestSales
FROM (
    SELECT ProductID, SUM(QuantitySold) AS TotalSold
    FROM Sales
    GROUP BY ProductID
) AS ProductSales
JOIN Products P ON ProductSales.ProductID = P.ProductID
ORDER BY TotalSold DESC
LIMIT 1;

-- Category-wise Profit
SELECT P.Category, SUM(Pr.ProfitAmount) AS TotalProfit
FROM Profit Pr
JOIN Sales S ON Pr.SaleID = S.SaleID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.Category;

-- Cost vs Selling Price Analysis
SELECT P.ProductName, Pr.CostPrice, Pr.SellingPrice, Pr.ProfitAmount
FROM Profit Pr
JOIN Sales S ON Pr.SaleID = S.SaleID
JOIN Products P ON S.ProductID = P.ProductID;

-- Update Stock After a New Sale Example
UPDATE Products
SET Stock = Stock - 5
WHERE ProductID = 2;

-- Insert New Sale and Automatically Update Stock
-- Add sale
INSERT INTO Sales (ProductID, QuantitySold, SaleDate, TotalAmount)
VALUES (2, 3, '2025-01-08', 150.00);

-- Update stock
UPDATE Products
SET Stock = Stock - 3
WHERE ProductID = 2;

-- Add profit
INSERT INTO Profit (SaleID, CostPrice, SellingPrice, ProfitAmount)
VALUES (4, 120.00, 150.00, 30.00);

-- 4. Reports and Insights

-- Sales Trend Over Time
SELECT SaleDate, SUM(TotalAmount) AS DailySales
FROM Sales
GROUP BY SaleDate
ORDER BY SaleDate;

-- Low Stock Alert
SELECT ProductName, Stock
FROM Products
WHERE Stock < 5;

-- Overall Summary Report
SELECT 
    (SELECT SUM(TotalAmount) FROM Sales) AS TotalSales,
    (SELECT SUM(ProfitAmount) FROM Profit) AS TotalProfit,
    (SELECT COUNT(*) FROM Products WHERE Stock < 5) AS LowStockCount;

-- End of SQL Script
