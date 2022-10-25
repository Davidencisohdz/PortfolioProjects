select *
FROM Portfolio_project..DataHousing


-- Standarize Date Format
-- Converting the Saledate into a Date format

select SaleDate, CONVERT(Date, SaleDate)
FROM Portfolio_project..DataHousing


-- Updating the SaleDate in the DataHousing

update DataHousing
SET SaleDate = CONVERT(Date, SaleDate)


-- Populate property Address Data, Since we know that the Parcel ID has the address whenever parcel ID 
--repeats we will have the same address, threfore, we can add the same address to the same parcel IDs that have just NULL values in the ADDRESS COLUMN

Select *
FROM Portfolio_project..DataHousing
where PropertyAddress is NULL

-- Populating the PropertyAddress column


Select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) -- ISNULL will create a new column with all the information of the b.propertyaddress
FROM Portfolio_project..DataHousing a
JOIN Portfolio_project..DataHousing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ] -- Makes the differences between the two ParcelID rows
Where a.PropertyAddress is NULL

update a
SET propertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) -- This update will implement all the address values from b
FROM Portfolio_project..DataHousing a
JOIN Portfolio_project..DataHousing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ] 
Where a.PropertyAddress is NULL

-- separating the address column ( Adress, City, State)

Select PropertyAddress
From Portfolio_Project.dbo.DataHousing -- With this query we can visualize the PropertyAdress column thta we want to separate


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address -- Here we separate the address string untl the comma
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address -- Here we separate propertyaddress after the comma.

From Portfolio_Project.dbo.DataHousing

ALTER TABLE DataHousing -- Here we will alter the datatable by adding the name and type of the new columns
Add PropertySplitAddress Nvarchar(255);

Update DataHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) -- and specifying what they will have 


ALTER TABLE DataHousing -- Same as above but with the name of the city
Add PropertySplitCity Nvarchar(255);

Update DataHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select*
FROM Portfolio_project..DataHousing

-- Splitting the ownerAddress without substrings but with parsename and changing the commas for periods


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Portfolio_Project.dbo.DataHousing


-- After seeing that it worked we can add the columns updating them with the SET and the previous queries
ALTER TABLE DataHousing
Add OwnerSplitAddress Nvarchar(255);

Update DataHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE DataHousing
Add OwnerSplitCity Nvarchar(255);

Update DataHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE DataHousing
Add OwnerSplitState Nvarchar(255);

Update DataHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Portfolio_Project.dbo.DataHousing


-- changing y and n for yes and no with a case statement

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Portfolio_Project.dbo.DataHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Portfolio_Project.dbo.DataHousing


Update DataHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

select *
From Portfolio_Project.dbo.DataHousing


-- Remove Duplicates with rownumber


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Portfolio_project.dbo.DataHousing
--order by ParcelID
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Portfolio_project.dbo.DataHousing



-- Delete Unused Columns



Select *
From Portfolio_Project.dbo.DataHousing


ALTER TABLE Portfolio_Project.dbo.DataHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate