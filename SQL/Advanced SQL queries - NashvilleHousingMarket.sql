/*
Cleaning Data in SQL Queries 
*/

Select * 
from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDate
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
set SaleDate = CONVERT(date,SaleDate)

ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted = CONVERT(date,SaleDate)

Select SaleDateConverted
from NashvilleHousing


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as a
Join PortfolioProject.dbo.NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL


Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as a
Join PortfolioProject.dbo.NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
