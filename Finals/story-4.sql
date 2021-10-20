
CREATE TABLE Ranking (
	[Id] int IDENTITY(1,1) NOT NULL,
	[Description] varchar(255) NOT NULL,
	PRIMARY KEY CLUSTERED (Id Asc))

INSERT INTO Ranking ([Description]) VALUES ('Inactive')
INSERT INTO Ranking ([Description]) VALUES ('Bronze')
INSERT INTO Ranking ([Description]) VALUES ('Silver')
INSERT INTO Ranking ([Description]) VALUES ('Gold')
INSERT INTO Ranking ([Description]) VALUES ('Platinum')

ALTER TABLE [dbo].[Customer] ADD [RankingId] int NOT NULL;

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT FK_RankingId FOREIGN KEY (RankingId) REFERENCES [Ranking]([RankingId]);

--CREATE PROCEDURE uspRankCustomers
--AS
--BEGIN
	SELECT 
		c.CustomerId,
		o.OrderId,
		i.Quantity,
		i.ListPrice,
		(i.Quantity * i.ListPrice) as TotalOrderAmount
	FROM [dbo].[Customer] c
		INNER JOIN [dbo].[Order] o on c.CustomerId = o.CustomerId
		INNER JOIN [dbo].[OrderItem] i on i.OrderId = o.OrderId
	GROUP BY c.CustomerId, o.OrderId, i.Quantity, i.ListPrice
--END

CREATE VIEW vwCustomerOrders
AS
	SELECT 
		CustomerId,
		FirstName,
		LastName,
		TotalOrderAmount,
		CustomerRanking
	FROM 
		[dbo].[Customer] c
	INNER JOIN 
		