/* 
data cleaning in SQLqueries
*/

SELECT * FROM narshville_housing

-- Standardise date format

SELECT saledate, to_date(saledate,'Month dd yy') AS saledateconverted FROM narshville_housing

UPDATE narshville_housing
SET saledate = to_date(saledate,'Month dd yy')

-- if it doesn't update properly

ALTER TABLE narshville_housing ADD saledateconverted date

UPDATE narshville_housing 
SET saledateconverted = to_date(saledate,'Month dd yy')

------------------------------------------------------------------------------------------------

--Populate property address

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress,b.PropertyAddress)
FROM narshville_housing as a
JOIN narshville_housing as b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is Null

UPDATE narshville_housing
SET propertyaddress = COALESCE(a.PropertyAddress,b.PropertyAddress)
                          FROM narshville_housing as a
                          JOIN narshville_housing as b
                              ON a.ParcelID = b.ParcelID
                              AND a.UniqueID <> b.UniqueID
                          WHERE a.PropertyAddress is Null
                          
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT propertyaddress, 
SUBSTRING(propertyaddress, 1 ,POSITION(',' IN propertyaddress)-1) AS address,
SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress)+1 ,LENGTH (propertyaddress)) AS city
FROM narshville_housing

ALTER TABLE narshville_housing ADD address varchar 

UPDATE narshville_housing
SET address = SUBSTRING(propertyaddress, 1 ,POSITION(',' IN propertyaddress)-1)

ALTER TABLE narshville_housing ADD city varchar 

UPDATE narshville_housing
SET city = SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress)+1 ,LENGTH (propertyaddress))



SELECT owneraddress,
SPLIT_PART (OwnerAddress,',',1), 
SPLIT_PART (OwnerAddress,',',2),
SPLIT_PART (OwnerAddress,',',3)
FROM narshville_housing
ORDER BY uniqueID

ALTER TABLE narshville_housing ADD owner_address varchar

UPDATE narshville_housing
SET owner_address = SPLIT_PART (OwnerAddress,',',1)

ALTER TABLE narshville_housing ADD owner_city varchar

UPDATE narshville_housing
SET owner_city = SPLIT_PART (OwnerAddress,',',2)

ALTER TABLE narshville_housing ADD owner_state varchar

UPDATE narshville_housing
SET owner_state = SPLIT_PART (OwnerAddress,',',3)


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT soldasvacant, COUNT(soldasvacant)
FROM narshville_housing
GROUP BY soldasvacant

SELECT soldasvacant,
    CASE soldasvacant
        WHEN 'Y' THEN 'Yes'
        WHEN 'N' THEN 'No'
        ELSE soldasvacant
    END
FROM narshville_housing

UPDATE narshville_housing
SET soldasvacant = CASE soldasvacant
                        WHEN 'Y' THEN 'Yes'
                        WHEN 'N' THEN 'No'
                        ELSE soldasvacant
                   END
                   

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
    SELECT 
        uniqueID 
    FROM (
        SELECT uniqueID,
        ROW_NUMBER() OVER(
             PARTITION BY parcelid,
                          propertyaddress,
                          saledate,
                          saleprice,
                          legalreference
                          ) AS rownum
                FROM narshville_housing
          ) s
        WHERE rownum >1)

DELETE FROM narshville_housing
WHERE uniqueid IN (SELECT * FROM RowNumCTE)

SELECT * FROM narshville_housing


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT * FROM narshville_housing

ALTER TABLE narshville_housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

