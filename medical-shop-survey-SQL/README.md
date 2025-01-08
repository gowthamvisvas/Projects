# Medical Shop Sales and Profit Analysis

This project provides a database schema for managing products, sales, and profits in a medical shop. It includes queries for analyzing total sales, profits, inventory management, and other insightful reports for better decision-making.

## Database Schema

The following tables are created for managing data:
- **Products**: Stores details about medical products.
- **Sales**: Records sales transactions.
- **Profit**: Tracks profit details for each sale.

### Schema

```sql
-- Products Table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    Stock INT
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    QuantitySold INT,
    SaleDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Profit Table
CREATE TABLE Profit (
    ProfitID INT AUTO_INCREMENT PRIMARY KEY,
    SaleID INT,
    CostPrice DECIMAL(10, 2),
    SellingPrice DECIMAL(10, 2),
    ProfitAmount DECIMAL(10, 2),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID)
);
