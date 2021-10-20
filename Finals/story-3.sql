

SELECT * INTO Product_20211019
FROM [dbo].[Product]

DECLARE @CategoryId INT = 1
DECLARE @CategoryName VARCHAR(255) = 'Children Bicycles'

UPDATE p
SET ListPrice = 
	CASE WHEN 
		@CategoryName = 'Children Bicycles' 
        OR @CategoryName = 'Cyclocross Bicycles' 
        OR @CategoryName = 'Road Bikes'
	THEN 
		ListPrice * 1.2
	WHEN 
		@CategoryName = 'Comfort Bicycles' 
        OR @CategoryName = 'Cruisers Bicycles' 
        OR @CategoryName = 'Electric Bikes'
	THEN 
		ListPrice * 1.7
	WHEN 
		@CategoryName = 'Mountain Bikes'
	THEN 
		ListPrice * 1.4
	END
FROM Product_20211019 p
INNER JOIN [dbo].[Category] c on c.CategoryId = p.CategoryId
WHERE p.CategoryId = @CategoryId
