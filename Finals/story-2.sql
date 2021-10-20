

CREATE PROCEDURE GetProducts
	@Page int = 1, 
	@PageSize int = 10,
	@ProductName varchar(255) = '',
	@BrandId int = NULL,
	@CategoryId int = NULL,
	@ModelYear int = NULL
AS 
BEGIN
	SELECT 
		p.ProductId,
		p.ProductName,
		b.BrandId,
		b.BrandName,
		c.CategoryId,
		c.CategoryName,
		p.ModelYear,
		p.ListPrice
	FROM [dbo].[Product] p
		INNER JOIN [dbo].[Brand] b on b.BrandId = p.BrandId
		INNER JOIN [dbo].[Category] c on c.CategoryId = p.CategoryId
	WHERE 
		p.ProductName LIKE '%' + @ProductName + '%' AND
		p.BrandId = CASE WHEN @BrandId IS NOT NULL THEN @BrandId ELSE p.BrandId END AND
		p.CategoryId = CASE WHEN @CategoryId IS NOT NULL THEN @CategoryId ELSE p.CategoryId END AND
		p.ModelYear = CASE WHEN @ModelYear IS NOT NULL THEN @ModelYear ELSE p.ModelYear END

	ORDER BY ModelYear desc, ListPrice desc, ProductName
	OFFSET @PageSize * (@Page - 1) ROWS
	FETCH NEXT @PageSize ROWS ONLY
END
GO