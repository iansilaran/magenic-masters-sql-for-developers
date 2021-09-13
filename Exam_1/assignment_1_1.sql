
SELECT CustomerId, COUNT(CustomerId) as Count
FROM [dbo].[Order] o
GROUP BY CustomerId, ShippedDate
HAVING COUNT(CustomerId) > 1 AND ShippedDate IS NOT NULL
ORDER BY CustomerId
