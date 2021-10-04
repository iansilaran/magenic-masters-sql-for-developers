USE SQL4DevsDb

-- 1. Write a script that would return the id and name of the store that does NOT have any Order record (1 pt)
select *
from [dbo].[Store] 
where StoreId not in (select StoreId from [dbo].[Order])

--2. Write a script with the following criteria (4 pts):
--	a. Query all Products from Baldwin Bikes store with the model year of 2017 to 2018
--	b. Query should return the following fields: Product Id, Product Name, Brand Name, Category Name and Quantity
--	c. Result set should be sorted from the highest quantity, Product Name, Brand Name and Category Name

select 
	p.ProductId, 
	p.ProductName, 
	b.BrandName, 
	c.CategoryName, 
	stock.Quantity
from [dbo].[Product] p
	inner join [dbo].[Stock] stock on stock.ProductId = p.ProductId
	inner join [dbo].[Store] store on store.StoreId = stock.StoreId
	inner join [dbo].[Brand] b on b.BrandId = p.BrandId
	inner join [dbo].[Category] c on c.CategoryId = p.CategoryId
where 
	store.StoreId = 2 -- Baldwin Bikes
	and p.ModelYear between 2017 and 2018
order by Quantity desc, ProductName, BrandName, CategoryName

--3. Write a script with the following criteria (3 pts):
--	a. Return the total number of orders per year and store name
--	b. Query should return the following fields: Store Name, Order Year and the Number of Orders of that year
--	c. Result set should be sorted by Store Name and most recent order year

select
	store.StoreName,
	YEAR(o.OrderDate) as OrderYear,
	COUNT(*) as OrderCount
from [dbo].[Order] o
	inner join [dbo].[Store] store on store.StoreId = o.StoreId
group by store.StoreName, YEAR(o.OrderDate)
order by store.StoreName, OrderYear desc

--4. Write a script with the following criteria (4 pts):
--	a. Using a CTE and Window function, select the top 5 most expensive products per brand
--	b. Data should be sorted by the most expensive product and product name

with ProductBrandListPrice as (
	select
		p.ProductId,
		p.BrandId,
		ROW_NUMBER() over (partition by p.BrandId order by p.ListPrice) as Ranking
	from [dbo].[Product] p
		inner join [dbo].[Brand] b on b.BrandId = p.BrandId
	group by p.ProductId, p.BrandId, p.ListPrice
)

select p.ProductName, b.BrandName, p.ListPrice, Ranking
from ProductBrandListPrice cte
	inner join [dbo].[Product] p on p.ProductId = cte.ProductId
	inner join [dbo].[Brand] b on b.BrandId = cte.BrandId
where Ranking <= 5
order by p.ProductName, Ranking

--5. Using the script from #3, use a cursor to print the records

DECLARE @store_name NVARCHAR(MAX)
DECLARE @order_year NVARCHAR(MAX)
DECLARE @order_count NVARCHAR(MAX)

DECLARE cursor_print CURSOR
for select
	store.StoreName,
	YEAR(o.OrderDate) as OrderYear,
	COUNT(*) as OrderCount
from [dbo].[Order] o
	inner join [dbo].[Store] store on store.StoreId = o.StoreId
group by store.StoreName, YEAR(o.OrderDate)
order by store.StoreName, OrderYear desc;

OPEN cursor_print;
FETCH NEXT FROM cursor_print INTO
	@store_name,
	@order_year,
	@order_count;

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @store_name + ' ' + @order_year + ' ' + @order_count;
		FETCH NEXT FROM cursor_print INTO
		@store_name,
		@order_year,
		@order_count;
	END
CLOSE cursor_print;
DEALLOCATE cursor_print;

--6. Create a script with one loop is nested within another to output the multiplication tables for the numbers one to ten
DECLARE @X INT = 1, @Y INT = 1
WHILE @X <= 10
BEGIN
	SET @Y = 1
	WHILE @Y <= 10
	BEGIN
		PRINT CONVERT(VARCHAR, @X) + ' * ' + CONVERT(VARCHAR, @Y) + ' = ' + CONVERT(VARCHAR, (@X * @Y))
		SET @Y = @Y + 1
	END
	SET @X = @X + 1
END

--INCOMPLETE
--7. Create a script using a PIVOT operator to get the monthly sales
--	a. Use Order and OrderItems table

select 
	o.OrderId, 
	MONTH(o.OrderDate) as SalesMonth,
	YEAR(o.OrderDate) as SalesYear,
	SUM(oi.ListPrice) as TotalSales
from [dbo].[Order] o
inner join [dbo].[OrderItem] oi on oi.OrderId = o.OrderId
group by o.OrderId, o.OrderDate, oi.ListPrice

DECLARE @columns NVARCHAR(MAX) = '[1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]', 
		@Sql NVARCHAR(MAX) = '';

SET @Sql = '
WITH OrderSales AS (
	select 
	o.OrderId, 
	MONTH(o.OrderDate) as SalesMonth,
	YEAR(o.OrderDate) as SalesYear,
	oi.ListPrice) as TotalSales
	from [dbo].[Order] o
	inner join [dbo].[OrderItem] oi on oi.OrderId = o.OrderId
	group by o.OrderId, o.OrderDate, oi.ListPrice
)

SELECT * FROM OrderSales 
PIVOT(
	COUNT(OrderId) 
	FOR SalesMonth IN ('+ @columns +')
) AS PivotTable'

EXECUTE sp_executesql @sql
