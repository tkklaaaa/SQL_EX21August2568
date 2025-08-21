
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

-- join มากกว่า 2 ตาราง
select o.OrderID เลขใบสั่งซื้อ, c.CompanyName ลูกค้า, e.FirstName ชื่อพนักงาน, o.ShipAddress ส่งไปที่
from Orders o,Customers c,Employees e
where o.CustomerID = c.CustomerID
and o.EmployeeID = e.EmployeeID

select o.OrderID เลขใบสั่งซื้อ, c.CompanyName ลูกค้า, e.FirstName ชื่อพนักงาน, o.ShipAddress ส่งไปที่
from Orders o join Customers c on o.CustomerID = c.CustomerID
              join Employees e on o.EmployeeID = e.EmployeeID

-- ใช้ร่วมกับ Aggregate Function
-- ต้องการรหัสพนักงาน ชื่อพนักงาน และจำนวนใบสั่งซื้อที่เกี่ยวข้อง ผลรวมของค่าขนส่ง ในปี 1998
select e.EmployeeID, FirstName , count(*) as [จำนวน order], sum(freight) as [Sum of Freight]
from Employees e join Orders o on e.EmployeeID = o.EmployeeID
where year(orderdate) = 1998
group by e.EmployeeID, FirstName

ORDER BY 3 desc -- มาก - น้อย
-- ORDER BY 3 asc -- น้อย - มาก

-- ** DISTINCT ข้อมูลที่แสดงออกมาซ้ำกันจะแสดงเพียง 1 แถว **

-- ต้องการชื่อสินค้าที่ Nancy ขายได้ทั้งหมด เรียงตามลำดับรหัสสินค้า
SELECT DISTINCT p.ProductID, p.ProductName
from Employees e join Orders o on e.EmployeeID = o.EmployeeID
                 join [Order Details] od on o.OrderID = od.OrderID
                 join Products p on od.ProductID = p.ProductID
where FirstName = 'Nancy'
order by p.ProductID

-- ต้องการชื่อบริษัทลูกค้าชื่อ Around the Horn ซื้อสินค้าที่มาจากประเทศอะไรบ้าง
select distinct s.Country 
from Customers c join Orders o on c.CustomerID = o.CustomerID
                 join [Order Details] od on o.OrderID = od.OrderID
                 join Products p on od.ProductID = p.ProductID
                 join Suppliers s on p.SupplierID = s.SupplierID
where c.CompanyName = 'Around the Horn' 

-- ต้องการชื่อบริษัทลูกค้าชื่อ Around the Horn ซื้อสินค้าอะไรบ้าง จำนวนเท่าใด
select p.ProductID,p.ProductName, sum (Quantity) as TotalQuantity
from Customers c join Orders o on c.CustomerID = o.CustomerID
                 join [Order Details] od on o.OrderID = od.OrderID
                 join Products p on od.ProductID = p.ProductID
where c.CompanyName = 'Around the Horn'
group by p.ProductID,p.ProductName
order by 1

-- ต้องการหมายเลขใบสั่งซื้อ ชื่อพนักงาน และยอดขายใบสั่งซื้อนั้น
select o.OrderID, e.FirstName, sum((od.Quantity * od.UnitPrice * (1-od.Discount))) as TotalCast
from Orders o join Employees e on o.EmployeeID = e.EmployeeID
              join [Order Details] od on o.OrderID = od.OrderID
group by o.OrderID, e.FirstName
ORDER BY 1
