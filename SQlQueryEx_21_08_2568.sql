--การ Query ข้อมูลจากหลายตาราง (Join)
-- 1. รหัสใบสั่งซื้อ ชื่อบริษัทลูกค้า ชื่อและนามสกุลพนักงาน วันที่สั่งซื้อ ชื่อบริษัทขนส่ง เมือง ประเทศ ยอดเงินที่ต้องรับ
SELECT o.OrderID, c.CompanyName, CONCAT(e.FirstName, ' ', e.LastName) AS FullName, o.OrderDate, s.CompanyName AS ShipperCompany, c.City, c.Country, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
JOIN Shippers s ON o.ShipVia = s.ShipperID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, c.CompanyName, e.FirstName, e.LastName, o.OrderDate, s.CompanyName, c.City, c.Country

-- 2. ชื่อบริษัทลูกค้า ชื่อผู้ติดต่อ เมือง ประเทศ จำนวนใบสั่งซื้อและยอดการสั่งซื้อทั้งหมด เฉพาะ ม.ค.-มี.ค. 1997
SELECT c.CompanyName, c.ContactName, c.City, c.Country, COUNT(o.OrderID) AS OrderCount, SUM(o.Freight) AS TotalFreight
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-03-31'
GROUP BY c.CompanyName, c.ContactName, c.City, c.Country

-- 3. ชื่อเต็มพนักงาน ตำแหน่ง เบอร์โทร จำนวนใบสั่งซื้อ ยอดการสั่งซื้อใน พ.ย.-ธ.ค. 2539 (1996) เฉพาะ USA, Canada, Mexico
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS FullName, e.Title, e.HomePhone, COUNT(o.OrderID) AS OrderCount, SUM(o.Freight) AS TotalFreight
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate BETWEEN '1996-11-01' AND '1996-12-31'
AND c.Country IN ('USA', 'Canada', 'Mexico')
GROUP BY e.FirstName, e.LastName, e.Title, e.HomePhone

-- 4. รหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย จำนวนที่ขายได้ใน มิ.ย. 2540 (1997)
SELECT p.ProductID, p.ProductName, p.UnitPrice, SUM(od.Quantity) AS TotalSold
FROM [Order Details] od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate BETWEEN '1997-06-01' AND '1997-06-30'
GROUP BY p.ProductID, p.ProductName, p.UnitPrice

-- 5. รหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย ยอดเงินที่ขายได้ใน ม.ค. 2540 (1997) ทศนิยม 2 ตำแหน่ง
SELECT p.ProductID, p.ProductName, p.UnitPrice,
       ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) AS TotalSales
FROM [Order Details] od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-01-31'
GROUP BY p.ProductID, p.ProductName, p.UnitPrice

-- 6. ชื่อบริษัทตัวแทนจำหน่าย ชื่อผู้ติดต่อ เบอร์โทร เบอร์ Fax รหัสสินค้า ชื่อสินค้า ราคา จำนวนรวมที่จำหน่ายได้ในปี 1996
SELECT s.CompanyName, s.ContactName, s.Phone, s.Fax, p.ProductID, p.ProductName, p.UnitPrice, SUM(od.Quantity) AS TotalSold
FROM [Order Details] od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY s.CompanyName, s.ContactName, s.Phone, s.Fax, p.ProductID, p.ProductName, p.UnitPrice

-- 7. รหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย จำนวนที่ขายได้ เฉพาะ Seafood ส่งไป USA ปี 1997
SELECT p.ProductID, p.ProductName, p.UnitPrice, SUM(od.Quantity) AS TotalSold
FROM [Order Details] od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Customers cu ON o.CustomerID = cu.CustomerID
WHERE c.CategoryName = 'Seafood'
AND cu.Country = 'USA'
AND YEAR(o.OrderDate) = 1997
GROUP BY p.ProductID, p.ProductName, p.UnitPrice

-- 8. ชื่อเต็ม Sale Representative อายุงานเป็นปี จำนวนใบสั่งซื้อในปี 1998
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS FullName, e.Title,
       DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
       COUNT(o.OrderID) AS OrderCount
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE e.Title = 'Sales Representative'
AND YEAR(o.OrderDate) = 1998
GROUP BY e.FirstName, e.LastName, e.Title, e.HireDate

-- 9. ชื่อเต็มพนักงาน ตำแหน่งงาน ที่ขายสินค้าให้ Frankenversand ปี 1996
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS FullName, e.Title
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.CompanyName = 'Frankenversand'
AND YEAR(o.OrderDate) = 1996

-- 10. ชื่อสกุลพนักงาน ยอดขาย Beverage ปี 1996
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
       SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
AND YEAR(o.OrderDate) = 1996
GROUP BY e.FirstName, e.LastName

-- 11. ชื่อประเภทสินค้า รหัสสินค้า ชื่อสินค้า ยอดเงินที่ขายได้ (หักส่วนลด) ม.ค.-มี.ค. 2540 โดย Nancy
SELECT c.CategoryName, p.ProductID, p.ProductName,
       SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE e.FirstName = 'Nancy'
AND o.OrderDate BETWEEN '1997-01-01' AND '1997-03-31'
GROUP BY c.CategoryName, p.ProductID, p.ProductName

-- 12. ชื่อบริษัทลูกค้าที่ซื้อ Seafood ปี 1997
SELECT DISTINCT cu.CompanyName
FROM Orders o
JOIN Customers cu ON o.CustomerID = cu.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Seafood'
AND YEAR(o.OrderDate) = 1997

-- 13. ชื่อบริษัทขนส่ง ที่ส่งสินค้าให้ลูกคาที่อยู่ Johnstown Road พร้อมวันที่ส่ง (รูปแบบ 106)
SELECT DISTINCT s.CompanyName, o.ShippedDate
FROM Orders o
JOIN Shippers s ON o.ShipVia = s.ShipperID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Address LIKE '%Johnstown Road%'

-- 14. รหัสประเภทสินค้า ชื่อประเภทสินค้า จำนวนสินค้าในประเภทนั้น ยอดรวมที่ขายได้ทั้งหมด (ทศนิยม 4 ตำแหน่ง หักส่วนลด)
SELECT c.CategoryID, c.CategoryName, COUNT(p.ProductID) AS ProductCount,
       ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 4) AS TotalSales
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY c.CategoryID, c.CategoryName

-- 15. ชื่อบริษัทลูกค้าใน London, Cowes ที่สั่ง Seafood จากตัวแทนญี่ปุ่น รวมมูลค่าเป็นเงิน
SELECT cu.CompanyName, SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalSales
FROM Orders o
JOIN Customers cu ON o.CustomerID = cu.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE cu.City IN ('London', 'Cowes')
AND c.CategoryName = 'Seafood'
AND s.Country = 'Japan'
GROUP BY cu.CompanyName

-- 16. รหัสบริษัทขนส่ง ชื่อบริษัทขนส่ง จำนวนorders ค่าขนส่ง เฉพาะที่ส่งไป USA
SELECT s.ShipperID, s.CompanyName, COUNT(o.OrderID) AS OrderCount, SUM(o.Freight) AS TotalFreight
FROM Shippers s
JOIN Orders o ON s.ShipperID = o.ShipVia
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'
GROUP BY s.ShipperID, s.CompanyName

-- 17. ชื่อเต็มพนักงานอายุมากกว่า 60 ปี ชื่อบริษัทลูกค้า,ชื่อผู้ติดต่อ,เบอร์โทร,Fax,ยอดรวม Condiment ที่ลูกค้าแต่ละรายซื้อ (ทศนิยม4ตำแหน่ง,เฉพาะลูกค้าที่มีเบอร์แฟกซ์)
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS FullName, c.CompanyName, c.ContactName, c.Phone, c.Fax,
       ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 4) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE DATEDIFF(YEAR, e.BirthDate, GETDATE()) > 60
AND cat.CategoryName = 'Condiments'
AND c.Fax IS NOT NULL
GROUP BY e.FirstName, e.LastName, c.CompanyName, c.ContactName, c.Phone, c.Fax

-- 18. วันที่ 3 มิ.ย. 2541 พนักงานแต่ละคนขายได้เท่าใด พร้อมชื่อคนที่ไม่ได้ขายของด้วย
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
       ISNULL(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 0) AS TotalSales
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID AND o.OrderDate = '1998-06-03'
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.FirstName, e.LastName

-- 19. รหัสรายการสั่งซื้อ ชื่อพนักงาน ชื่อบริษัทลูกค้า เบอร์โทร วันที่ต้องการสินค้า เฉพาะพนักงานชื่อ Margaret พร้อมยอดเงินรวม (ทศนิยม 2 ตำแหน่ง)
SELECT o.OrderID, CONCAT(e.FirstName, ' ', e.LastName) AS FullName, c.CompanyName, c.Phone, o.RequiredDate,
       ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) AS TotalSales
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE e.FirstName = 'Margaret'
GROUP BY o.OrderID, e.FirstName, e.LastName, c.CompanyName, c.Phone, o.RequiredDate

-- 20. ชื่อเต็มพนักงาน อายุงานเป็นปีและเดือน ยอดขายรวม เลือกเฉพาะลูกค้า USA, Canada, Mexico และไตรมาสแรกปี 2541
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
       DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
       DATEDIFF(MONTH, e.HireDate, GETDATE()) % 12 AS MonthsOfService,
       SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE c.Country IN ('USA', 'Canada', 'Mexico')
AND o.OrderDate BETWEEN '1998-01-01' AND '1998-03-31'
GROUP BY e.FirstName, e.LastName, e.HireDate
