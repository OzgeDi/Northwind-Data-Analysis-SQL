--Shows ages of each employee:
SELECT 
  FirstName AS [Name], 
  LastName AS [Surname], 
  DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
FROM Employees;


--Shows managers of each employee:
SELECT 
    e1.FirstName AS Employee,
    e2.FirstName AS Manager
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ReportsTo = e2.EmployeeID;


--Shows order details (OrderID, CompanyName, ProductName, Quantity, UnitPrice) where the Order ID is 10248:
SELECT 
    Orders.OrderID,
    Customers.CompanyName AS Customer,
    Products.ProductName,
    [Order Details].Quantity AS [Order Quantity],
    [Order Details].UnitPrice AS [Unit Price]
FROM Orders
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.OrderID = 10248;


--Shows Products and their Category Names where the Category ID is 3
SELECT 
    Categories.CategoryID,
    Categories.CategoryName,
    Products.ProductName
FROM Categories
INNER JOIN Products ON Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryID = 3
ORDER BY Categories.CategoryName;


--Shows Categories with no products
SELECT CategoryName From Products RIGHT JOIN Categories 
ON Products.CategoryID=Categories.CategoryID
WHERE Products.CategoryID IS NULL
ORDER BY CategoryName


--Customers who haven't got any Order
SELECT CompanyName
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);


--Shows the total freight paid by each customer and orders by descending
SELECT 
    Customers.CustomerID,
    Customers.ContactName AS [Customer Name],
    Customers.CompanyName AS [Company],
    SUM(Orders.Freight) AS [Total Freight]
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY 
    Customers.CustomerID,
    Customers.ContactName,
    Customers.CompanyName
ORDER BY [Total Freight] DESC;


--Shows unique customers who have orders
SELECT DISTINCT
    Customers.CustomerID,
    Customers.CompanyName,
    Customers.ContactName AS CustomerName,
    Orders.ShipCountry
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;


--Total Sales Amount by Country in 1997 (UnitPrice * Quantity):
SELECT ShipCountry, 
       SUM(UnitPrice*Quantity) AS [Toplam Ürün Tutarý], 
       SUM([Order Details].Quantity) AS [Toplam Ürün Adedi],
       AVG(UnitPrice) AS [Ortalama Birim Fiyat]
FROM Orders
INNER JOIN [Order Details] 
        ON Orders.OrderID = [Order Details].OrderID
WHERE YEAR(Orders.OrderDate) = 1997
GROUP BY ShipCountry;


--Top 5 countries that order the most products in 1997
SELECT TOP 5 ShipCountry, 
       SUM([Order Details].Quantity) AS [Toplam Ürün Adedi]
FROM Orders 
INNER JOIN [Order Details] 
        ON Orders.OrderID = [Order Details].OrderID
WHERE YEAR(Orders.OrderDate) = 1997
GROUP BY ShipCountry
ORDER BY SUM([Order Details].Quantity) DESC;


--Average unit selling price of each country in 1997
SELECT ShipCountry, 
       SUM(UnitPrice*Quantity) / SUM(Quantity) AS [Ortalama Birim Satýþ Fiyatý]
FROM Orders 
INNER JOIN [Order Details] 
        ON Orders.OrderID = [Order Details].OrderID
WHERE YEAR(Orders.OrderDate) = 1997
GROUP BY ShipCountry;


--Show the names of product categories whose average product price is greater than 30
SELECT CategoryName, AVG(UnitPrice) AS [Average Unit Price] FROM Categories
LEFT JOIN Products ON Products.CategoryID = Categories.CategoryID
GROUP BY CategoryName HAVING AVG(UnitPrice) >30


--Lists countries that received orders in 1997 where the total quantity of products shipped exceeded 200
SELECT ShipCountry, 
       SUM(Quantity) AS [Toplam Ürün Adedi]
FROM Orders 
INNER JOIN [Order Details] 
        ON Orders.OrderID = [Order Details].OrderID
WHERE YEAR(Orders.OrderDate) = 1997
GROUP BY ShipCountry HAVING SUM(Quantity) > 200


--Displays customers whose total order amount (UnitPrice × Quantity) is greater than 10,000
 SELECT CompanyName, SUM(UnitPrice*Quantity) AS[Toplam Sipariþ Tutarý] FROM Customers
INNER JOIN Orders 
        ON Orders.CustomerID = Customers.CustomerID
INNER JOIN [Order Details]
        ON Orders.OrderID = [Order Details].OrderID
GROUP BY CompanyName HAVING SUM(UnitPrice*Quantity) > 10000


--Shows countries with an average product unit price higher than 25 for orders placed in 1997.
SELECT ShipCountry, 
       AVG(UnitPrice) AS [Ortalama Ürün Fiyatý]
FROM Orders 
INNER JOIN [Order Details] 
        ON Orders.OrderID = [Order Details].OrderID
WHERE YEAR(Orders.OrderDate) = 1997
GROUP BY ShipCountry HAVING AVG(UnitPrice) > 25