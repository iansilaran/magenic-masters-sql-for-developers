
--SELECT * INTO Brand_20211018
--FROM Brand

--SELECT * INTO Product_20211018
--FROM Product

CREATE PROCEDURE CreateNewBrandAndMoveProducts 
	@OldBrandId int, 
	@NewBrandName varchar(max)
AS
BEGIN
	DECLARE @NewBrandId int;

BEGIN TRANSACTION;
BEGIN TRY
	INSERT INTO [dbo].[Brand] (BrandName) VALUES (@NewBrandName)
	SET @NewBrandId = SCOPE_IDENTITY()

	UPDATE [dbo].[Product] 
	SET BrandId = @NewBrandId
	WHERE BrandId = @OldBrandId

	DELETE [dbo].[Brand] WHERE BrandId = @OldBrandId

	SELECT * FROM [dbo].[Brand]
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
END CATCH;

IF @@TRANCOUNT > 0
	COMMIT TRANSACTION;

END
GO
