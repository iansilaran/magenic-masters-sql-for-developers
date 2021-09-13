SELECT * INTO Product_20210913 FROM Product
WHERE ModelYear != 2016

UPDATE p
SET p.ListPrice = p.ListPrice * CASE WHEN BrandName IN ('Heller', 'Sun Bicycles') THEN 1.2 ELSE 1.1 END
FROM Product_20210913 p
JOIN Brand b ON b.BrandId = p.BrandId