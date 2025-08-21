
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
