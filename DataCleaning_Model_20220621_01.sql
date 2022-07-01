/*

Cleaning Data in SQL Queries

*/


Select *
From [Data Cleaning]..NashvileHousing

-- Standardize Date Format

Select SaleDate, CAST(SaleDate as date)
From NashvileHousing


-- NO use
Update NashvileHousing
Set SaleDate = CAST(SaleDate as date)

ALTER TABLE NashvileHousing
ADD SaleDateConverted Date

Update NashvileHousing
SET	SaleDateConverted = CONVERT(date, SaleDate)

Select SaleDateConverted
From NashvileHousing

--Populate Property Address date

Select PropertyAddress
From NashvileHousing
--Where PropertyAddress is NULL
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvileHousing as a
Join NashvileHousing as b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvileHousing as a
Join NashvileHousing as b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into Individual Column (Address, City, State)

Select PropertyAddress
From NashvileHousing
--Where PropertyAddress is NULL
--Order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress) ) as City
--,CHARINDEX(',', PropertyAddress)
From NashvileHousing


ALTER TABLE NashvileHousing
ADD PropertySplitAddress nvarchar(255)

Update NashvileHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)
From NashvileHousing

ALTER TABLE NashvileHousing
ADD PropertySplitCity nvarchar(255)

Update NashvileHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress) )
From NashvileHousing



Select *
From NashvileHousing


Select OwnerAddress
From NashvileHousing

Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From NashvileHousing

ALTER TABLE NashvileHousing
ADD OwnerSplitAddress nvarchar(255)

Update NashvileHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
From NashvileHousing

ALTER TABLE NashvileHousing
ADD OwnerSplitCity nvarchar(255)

Update NashvileHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
From NashvileHousing

ALTER TABLE NashvileHousing
ADD OwnerSplitState nvarchar(255)

Update NashvileHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From NashvileHousing

Select *
From NashvileHousing

--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct SoldAsVacant, Count(SoldAsVacant)
From NashvileHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
,Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant	
	End
From NashvileHousing

Update NashvileHousing
Set	SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant	
	End

--Remove Duplicates

Select *,
ROW_NUMBER() Over(
Partition by ParcelID, 
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order by
				UniqueID
				) row_num

From NashvileHousing
Order by ParcelID


--CTE

With RowNumCTE as(
Select *,
ROW_NUMBER() Over(
Partition by ParcelID, 
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order by
				UniqueID
				) row_num

From NashvileHousing
--Order by ParcelID
)
Select *
From RowNumCTE
--Where row_num >1




--Delete Unused Colunms

Select *
From NashvileHousing

Alter Table NashvileHousing
Drop Column Address