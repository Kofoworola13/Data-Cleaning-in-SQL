
# Data Cleaning in SQL




## 1. Overview of the data set

```
select *
  from PortfolioProject..NashvilleHousing 
```
<img src="images/Screenshot%20(30).png" width="100">

## 2. Changing the format of the SaleDate column from timestamp to SaleDate
<img src="images/Screenshot%20(32).png" width="100">

## 3. Populating the null records in the PropertyAddress column
After inspecting the dataset closely, I've observed that there are instances where the "propertyaddress" and "parcelID" fields contain identical data, even though the unique IDs are different. This implies that I can replace missing "propertyaddress" values in one record with data from a non-null record, given that their "parcelID" matches, taking into account the differing unique IDs. 
I then performed a self-join and used the `isnull` function to populate the null records.

```
select a.ParcelID, a.PropertyAddress, a.[UniqueID ]
     , b.ParcelID, b.PropertyAddress, b.[UniqueID ]
     , ISNULL(a.PropertyAddress, b.PropertyAddress) as null_filled
  from PortfolioProject..NashvilleHousing as a
  join PortfolioProject..NashvilleHousing as b
    on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ] 
 where a.PropertyAddress is null
```
Before:
<img src="images/Screenshot%20(33).png" width="100">

After:
<img src="images/Screenshot%20(35).png" width="100">

## 4. Extracting the street name and number, and city from the propertyadress and owneraddress columns

Using the `substring` and `parsename` functions, I was able to break down the PropertyAddress and OwnerAddress into street address and city.

<img src="images/Screenshot%20(39).png" width="100">

<img src="images/Screenshot%20(41).png" width="100">

## 5.Changing Y and N to Yes and No respectively
Using a `case` statement I standardized the 'Y and N' into 'Yes and No'.

Before:
<img src="images/Screenshot%20(42).png" width="100">

After:
<img src="images/Screenshot%20(44).png" width="100">

## 6.Checking for and removing duplicates
Combining a set of window functions and then transforming the query into a CTE, I located some duplicate records. And they were deleted.


## 7.Deleting the columns no longer needed
The final step was to delete the columns that won't be needed in further analysis.

## Acknowledgements
This analysis project was based on [Alex the Analyst Data Cleaning tutorial](https://www.youtube.com/watch?v=8rO7ztF4NtU)
 

