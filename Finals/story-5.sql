
WITH CTE AS (
	
	SELECT e.StaffId
		, e.FirstName + ' ' + e.LastName AS FullName
		, CAST(e.FirstName + ' ' + e.LastName + ', ' 
			AS VARCHAR(500)) AS Managers
	FROM dbo.Staff e
	WHERE ManagerId IS NULL

	UNION ALL

	SELECT e.StaffId
		, e.FirstName + ' ' + e.LastName AS FullName
		, CAST(r.Managers 
				+ e.FirstName 
				+ ' ' + e.LastName 
				+ ', ' AS VARCHAR(500))
	FROM dbo.Staff e
	INNER JOIN CTE AS r
		ON (e.ManagerId = r.StaffId)
)

SELECT r.StaffId
	, r.FullName
	, CASE WHEN SUBSTRING(REVERSE(TRIM(r.Managers)), 1, 1) = ',' THEN REVERSE(STUFF(REVERSE(TRIM(r.Managers)),1,1,'')) ELSE r.Managers END
FROM CTE r
ORDER BY r.StaffId