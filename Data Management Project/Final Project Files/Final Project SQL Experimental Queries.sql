Select *
FROM Amazon_Cleaned_Dataset;

--Number of Unique Drivers
Select distinct count(distinct Delivery_person_ID) as "Number_of_Drivers"
FROM Amazon_Cleaned_Dataset;

-- Unique Drivers
Select distinct Delivery_person_ID
FROM Amazon_Cleaned_Dataset;

--Delivery ID with Current Age
SELECT DISTINCT Delivery_person_ID, MAX(Delivery_person_Age) AS current_age
FROM Amazon_Cleaned_Dataset
GROUP BY Delivery_person_ID
ORDER BY Delivery_person_ID, current_age DESC;

--Historical Table for Delivery Person Ratings
select DISTINCT Delivery_person_ID, MAX(Delivery_person_Ratings) AS rating, Order_Date, Time_Orderd
FROM Amazon_Cleaned_Dataset
Where (Delivery_person_Ratings is not null) AND (Time_Orderd is not null) AND (Order_Date is not null)
GROUP BY Delivery_person_ID,Order_date, Time_Orderd
ORDER BY Delivery_person_ID, rating,Order_Date, Time_Orderd DESC;

--Number of Customers
Select distinct count(*) as "Number_of_Customers"
FROM (
	Select distinct Delivery_location_latitude, Delivery_location_longitude 
	FROM Amazon_Cleaned_Dataset
	) t;

--Unique Customer Location details
Select distinct Delivery_location_latitude, Delivery_location_longitude 
FROM Amazon_Cleaned_Dataset

--Number of Restaurants
Select distinct count(*) as "Number_of_Restaurants"
FROM (
	Select distinct Restaurant_latitude, Restaurant_longitude 
	FROM Amazon_Cleaned_Dataset
	) t;
-- Unique Restaurant Location details
Select distinct Restaurant_latitude, Restaurant_longitude 
FROM Amazon_Cleaned_Dataset;

--Delivery Person Table
Select distinct Delivery_person_ID 
FROM Amazon_Cleaned_Dataset;

--Restaurant Table
Select distinct Restaurant_latitude, Restaurant_longitude 
FROM Amazon_Cleaned_Dataset;

--Customer Table
Select distinct Delivery_location_latitude, Delivery_location_longitude
FROM Amazon_Cleaned_Dataset;

--Weather Type Table
Select distinct Weather
FROM Amazon_Cleaned_Dataset;

--Road Traffic Density Type Table
Select distinct Road_traffic_density
FROM Amazon_Cleaned_Dataset;

--Order Type Table
Select distinct Type_of_order
FROM Amazon_Cleaned_Dataset;

--Vehicle Type Table
Select distinct Type_of_vehicle
FROM Amazon_Cleaned_Dataset;

--City Type Table
Select distinct City
FROM Amazon_Cleaned_Dataset;

Select distinct Festival
From Amazon_Cleaned_Dataset

--Orders

--Delivery
-- Columns: Delivery_ID,Delivery_person_ID,Weather_type_id, Order_id, City_type_id, vehicle_type_id, traffic_id 


--Person - Populate with dummy names and ID's
Select person_id, person_fname, person_lname
FROM dbo.Person_Dummy;

--Historical Vehicle-Person

