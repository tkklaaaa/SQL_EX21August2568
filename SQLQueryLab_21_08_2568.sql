
--แสดงชื่อประเภทสินค้า ชื่อสินค้า และราคาสินค้า
SELECT CategoryName, ProductName, UnitPrice
FROM Products,Categories
WHERE Products.CategoryID = Categories.CategoryID
ORDER BY CategoryName

SELECT CategoryName, ProductName, UnitPrice
FROM Products JOIN Categories
ON Products.CategoryID = Categories.CategoryID
ORDER BY CategoryName

SELECT CategoryName, ProductName, UnitPrice
FROM Products as p JOIN Categories as c
ON p.CategoryID = c.CategoryID

SELECT CategoryName, ProductName, UnitPrice
FROM Products as p,Categories as c
WHERE p.CategoryID = c.CategoryID

select CompanyName,OrderID 
from orders,Shippers
where Shippers.ShipperID = Orders.ShipVia

select CompanyName,OrderID 
from orders join Shippers
on Shippers.ShipperID = Orders.ShipVia

--ต้องการรหัสสินค้า ชื่อสินค้า บริษัทผู้จำหน่าย ประเทศ
select ProductID, ProductName, CompanyName, Country
from Products as p join Suppliers as s
on p.SupplierID = s.SupplierID

select p.ProductID, p.ProductName, s.CompanyName, s.Country
from Products as p join Suppliers as s
on p.SupplierID = s.SupplierID

select p.ProductID, p.ProductName, s.CompanyName, s.Country
from Products as p , Suppliers as s
where p.SupplierID = s.SupplierID

SELECT * from Products
SELECT * from Categories
SELECT * from Products,Categories -- ผิด

-- จงแสดงข้อมูลหมายเลขใบสั่งซื้อและชื่อบริษัทขนส่วสิค้าของใบสั่งซื้อหมายเลข 10275

-- Cartesian Product
select CompanyName, OrderID
from Orders, Shippers
where Shippers.ShipperID = Orders.ShipVia
and orderID = 10275

-- Join Operator
select CompanyName, OrderID
from Orders join Shippers
on shippers.shipperID = orders.shipvia
where OrderID = 10275

-- ต้องการรหัสพนักงาน ชื่อพนักงาน รหัสใบสั่งซื้อที่เกี่ยวข้อง เรียงตามลำดับพนักงาน
SELECT e.EmployeeID, FirstName, OrderID
FROM Employees as e JOIN Orders as o
ON e.EmployeeID = o.EmployeeID
ORDER BY EmployeeID

-- ต้องการรหัสสินค้า เมือง และประเทศของบริษัทผู้จำหน่าย
SELECT p.ProductID, p.ProductName, s.City, s.Country
FROM Products as p JOIN Suppliers as s
ON p.SupplierID = s.SupplierID

-- ต้องการชื่อบริษํทขนส่งและจำนวนใบสั่งซื้อที่เกี่ยวข้อง
SELECT s.CompanyName, COUNT(*) as NumberOfOrders
FROM Shippers as s JOIN Orders as o
ON s.ShipperID = o.ShipVia
GROUP BY CompanyName

-- ต้องการรหัสสินค้า ชื่อสินค้าและจำนวนทั้งหมดที่ขายได้
SELECT p.ProductID, p.ProductName, SUM(Quantity) as TotalSold
FROM Products as p JOIN [Order Details] as od
ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY 1
