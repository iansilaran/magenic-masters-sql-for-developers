-- #1 - Display the total number of items sold per PRODUCT from orders in the database with the following requirements:
-- a) Only count orders from TX state
-- b) Total items sold per product should be greater than 10
-- c) Sort by total units sold from highest to lowest
-- d) Return columns should include: ProductName, TotalQuantity

with Orders as (
	select
	oi.ProductId, count(*) as TotalQuantity
	from [dbo].[Order] o
		inner join [dbo].[OrderItem] oi on oi.OrderId = o.OrderId
	group by oi.ProductId
), SoldPerProduct as (
	select p.ProductName, TotalQuantity from Orders o
	inner join [dbo].[Product] p on p.ProductId = o.ProductId
)

--select * from SoldPerProduct;

-- #2 - Display the total number of items sold per CATEGORY from orders in the database with the following requirements:​
-- a) For categories with "Bikes" on the name, make it Bicycle instead (ex. "Road Bikes" will be "Road Bicycles" instead)​
-- b) Sort by total units sold from highest to lowest​
-- c) Return columns should include: CategoryName, TotalQuantity

, Orders2 as (
	select
		c.CategoryId, count(*) as TotalQuantity
	from [dbo].[Order] o
		join [dbo].[OrderItem] oi on oi.OrderId = o.OrderId
		join [dbo].[Product] p on p.ProductId = oi.ProductId
		join [dbo].[Category] c on c.CategoryId = p.CategoryId
	group by c.CategoryId
), SoldPerCategory as (
	select REPLACE(c.CategoryName, 'Bikes', 'Bicycles') as CategoryName, TotalQuantity
	from Orders2 o
		join [dbo].[Category] c on c.CategoryId = o.CategoryId
)

-- #3 - Merge the results of items #1 and @2:
-- a) Sort by total units sold from highest to lowest

select * from SoldPerProduct
union all
select * from SoldPerCategory
order by TotalQuantity desc

-- #4 - For all orders in the database, retrieve the top selling product per month year with the following requirements:
-- a) Return columns should include: OrderYear, OrderMonth, ProductName, TotalQuantity
-- b) Sort the result by Year and Month in ascending order
-- c) In cases where there are more than 1 top-selling product in a month, we should display ALL products in TOP 1 position

with AllOrders as (
	select
		MONTH(o.OrderDate) as OrderMonth,
		YEAR(o.OrderDate) as OrderYear,
		p.ProductId,
		SUM(oi.ListPrice) as TotalQuantity
	from [dbo].[Order] o
		inner join [dbo].[OrderItem] oi on oi.OrderId = o.OrderId
		inner join [dbo].[Product] p on p.ProductId = oi.ProductId
	group by MONTH(o.OrderDate), YEAR(o.OrderDate), p.ProductId
)
select
	OrderMonth, OrderYear, p.ProductName, TotalQuantity, RANK() OVER (partition by OrderMonth, OrderYear Order by TotalQuantity desc)
from AllOrders o
	inner join [dbo].[Product] p on p.ProductId = o.ProductId
group by OrderMonth, OrderYear, ProductName, TotalQuantity
order by OrderYear asc