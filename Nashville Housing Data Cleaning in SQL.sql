/*
DATA CLEANING IN SQL
Skills Covered: Converting data types
                Joins
				Window functions
				Case statements
				Substrings
				Data Definition
				Data Manipulation
*/

-- 1.Overview of the dataset
select *
  from PortfolioProject..NashvilleHousing 


-- 2.Changing the format of the SaleDate column from timestamp to date

-- step 1: create the new column for the date format record
alter table PortfolioProject..NashvilleHousing 
  add sale_date_formatted date

-- step 2: populate the new column with the date format records
update PortfolioProject..NashvilleHousing 
   set sale_date_formatted = convert(date, SaleDate)

select SaleDate, sale_date_formatted
  from PortfolioProject..NashvilleHousing


-- 3. Populating the null records in the PropertyAddress column

-- testing 
select a.ParcelID, a.PropertyAddress, a.[UniqueID ]
     , b.ParcelID, b.PropertyAddress, b.[UniqueID ]
	 , ISNULL(a.PropertyAddress, b.PropertyAddress) as null_filled
  from PortfolioProject..NashvilleHousing as a
  join PortfolioProject..NashvilleHousing as b
    on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]  -- this double checks that the uniqueID are not the same
 where a.PropertyAddress is null

-- updating the table
update a
   set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
  from PortfolioProject..NashvilleHousing as a
  join PortfolioProject..NashvilleHousing as b
    on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null 


select *
  from PortfolioProject..NashvilleHousing 
 where owneraddress is null


-- 4. Extracting the street name and number, and city from the propertyadress and owneraddress

-- Method 1: Using the Substring function

-- Step 1: Create column for the street name and number, and city columns repectively
alter table PortfolioProject..NashvilleHousing 
  add property_street_name_and_no nvarchar(255)

alter table PortfolioProject..NashvilleHousing 
  add property_city nvarchar(255)


-- Step 2: Populate the new columns
update PortfolioProject..NashvilleHousing 
   set property_street_name_and_no = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

update PortfolioProject..NashvilleHousing 
   set property_city = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


select PropertyAddress
     , property_street_name_and_no
	 , property_city
  from PortfolioProject..NashvilleHousing


-- Method 2: Using the Parsename function
  
-- Step 1: Create column for the street name and number, and city columns repectively
alter table PortfolioProject..NashvilleHousing 
  add owner_street_name_and_no nvarchar(255)

alter table PortfolioProject..NashvilleHousing 
  add owner_city nvarchar(255)

-- Step 2: Populate the new columns
update PortfolioProject..NashvilleHousing 
   set owner_street_name_and_no = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

update PortfolioProject..NashvilleHousing 
   set owner_city = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


select OwnerAddress
     , owner_street_name_and_no
	 , owner_city
  from PortfolioProject..NashvilleHousing


-- 5.Changing Y and N to Yes and No respectively

select distinct(SoldAsVacant)
     , COUNT(SoldAsVacant)
  from PortfolioProject..NashvilleHousing
 group by SoldAsVacant
 order by 2


update PortfolioProject..NashvilleHousing
   set SoldAsVacant = case 
                           when SoldAsVacant = 'Y' then 'Yes'
                           when SoldAsVacant = 'N' then 'No'
	                       else SoldAsVacant
                       end


-- 6.Checking for and removing duplicates

with RowNumCTE as
(
select *
     , ROW_NUMBER() over(partition by ParcelID
	                                , PropertyAddress
									, SalePrice
									, SaleDate
									, LegalReference
                             order by UniqueID
                         ) as row_num 
  from PortfolioProject..NashvilleHousing
)

select *
  --delete
  from RowNumCTE
 where row_num > 1



-- 7.Deleting the columns no longer needed

alter table PortfolioProject..NashvilleHousing
 drop column OwnerAddress, PropertyAddress, SaleDate


select *
  from PortfolioProject..NashvilleHousing


 

