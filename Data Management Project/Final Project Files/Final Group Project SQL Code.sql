-- Start this with a brand new database and go chunk by chunk. 
-- When you import your excel Final Datasets file make sure to use 
-- the Amazon_Cleaned_Dataset, Person, Restaurant, and Customer. 
-- Do not rename the tables after import.


CREATE TABLE [City_type]
( 
	[city_type_id]       integer  NOT NULL ,
	[city_type]          nvarchar(255)  NULL 
)
go

CREATE TABLE [Customer]
( 
	[customer_id]        integer  NOT NULL ,
	[person_id]          integer  NOT NULL ,
	[customer_latitude]  float  NULL ,
	[customer_longitude] float  NULL 
)
go

CREATE TABLE [Delivery]
( 
	[delivery_id]        integer  NOT NULL ,
	[delivery_person_id] nvarchar(255)  NOT NULL ,
	[vehicle_id]         integer  NOT NULL ,
	[festival_id]        integer  NULL ,
	[weather_id]         integer  NULL ,
	[order_id]           integer  NOT NULL ,
	[city_type_id]       integer  NULL ,
	[traffic_id]         integer  NULL ,
	[vehicle_condition_id] integer  NULL ,
	[order_time_pickup]  TIME  NULL ,
	[del_person_rating]  float  NULL 
)
go

CREATE TABLE [Delivery_Person]
( 
	[delivery_person_id] nvarchar(255)  NOT NULL ,
	[person_id]          integer  NOT NULL ,
	[delivery_drivers_license] char(18)  NULL 
)
go

CREATE TABLE [Festival]
( 
	[festival_id]        integer  NOT NULL ,
	[festival_flag]      nvarchar(255)  NULL 
)
go

CREATE TABLE [Order_Detail]
( 
	[order_item_id]      integer  NOT NULL ,
	[order_id]           integer  NOT NULL ,
	[order_item_description] nvarchar(255)  NULL ,
	[order_item_qty]     integer  NULL ,
	[order_item_price]   float  NULL ,
	[order_item_tax]     float  NULL 
)
go

CREATE TABLE [Orders]
( 
	[order_id]           integer  NOT NULL ,
	[customer_id]        integer  NOT NULL ,
	[rest_id]            integer  NOT NULL ,
	[order_type]         nvarchar(255)  NULL ,
	[order_date]         datetime  NULL ,
	[order_time]         TIME  NULL 
)
go

CREATE TABLE [Person]
( 
	[person_id]          integer  NOT NULL ,
	[person_fname]       nvarchar(255)  NULL ,
	[person_lname]       nvarchar(255)  NULL ,
	[person_age]         integer  NULL 
)
go

CREATE TABLE [Restaurant]
( 
	[rest_id]            integer  NOT NULL ,
	[person_id]          integer  NOT NULL ,
	[rest_lat]           float  NULL ,
	[rest_long]          float  NULL ,
	[res_name]           nvarchar(255)  NULL 
)
go

CREATE TABLE [Traffic_Types]
( 
	[traffic_id]         integer  NOT NULL ,
	[traffic_density]    nvarchar(255)  NULL 
)
go

CREATE TABLE [Vehicle_Condition]
( 
	[vehicle_condition_id] integer  NOT NULL ,
	[vehicle_condition_desc] nvarchar(255)  NULL 
)
go

CREATE TABLE [Vehicle_Type]
( 
	[vehicle_type_id]    integer  NOT NULL ,
	[vehicle_type_desc]  nvarchar(255)  NULL 
)
go

CREATE TABLE [Vehicles]
( 
	[vehicle_id]         integer  NOT NULL ,
	[vehicle_type_id]    integer  NOT NULL ,
	[vehicle_VIN]        nvarchar(255)  NULL ,
	[vehicle_make]       nvarchar(255)  NULL ,
	[vehicle_model]      nvarchar(255)  NULL 
)
go

CREATE TABLE [Weather]
( 
	[weather_id]         integer  NOT NULL ,
	[weather_type]       nvarchar(255)  NULL 
)
go

--********UPLOAD THE Final_Dataset Excel document. Make sure the datatypes are INT, FLOAT,DATE,TIME, and NVARCHAR(255) in the appropriate columns.********

-- POPULATE TABLES

--Insert Person_Dummy$ into Person table. 
INSERT INTO dbo.Person (person_id, person_fname, person_lname)
SELECT person_id, person_fname, person_lname
FROM dbo.Person_Dummy$;

Select top (100) * From Person;

--Insert Customer_Dummy$ into Customer table. 
INSERT INTO dbo.Customer (customer_id, person_id, customer_latitude, customer_longitude)
SELECT Customer_id, Person_id, Delivery_lat, delivery_long
FROM dbo.Customer_Dummy$;

Select top (100) * From Customer;


-- Insert Restaurant_dummy$ into Restaurant Table
INSERT INTO dbo.Restaurant (rest_id, person_id, rest_lat, rest_long, res_name)
SELECT ROW_NUMBER() OVER (ORDER BY [Restaurant_ID]) AS rest_id, [Person_ID], [Restaurant_latitude], [Restaurant_longitude], [Restaurant Name]
FROM dbo.Restaurant_dummy$;

Select * From dbo.Restaurant;

-- Add empty raw data columns to Delivery Table
ALTER TABLE Delivery
ADD del_person_age INT,
	d_rest_lat FLOAT,
	d_rest_long FLOAT, 
	d_loc_lat FLOAT,
	d_loc_long FLOAT,
	d_order_date DATE,
	d_time_ordered TIME,
	d_order_picked TIME,
	d_weather nvarchar(255),
	d_road_density nvarchar(255),
	d_v_condition INT,
	d_o_type nvarchar(255),
	d_v_type nvarchar(255),
	d_m_del INT,
	d_festival nvarchar(255),
	d_city nvarchar(255)
	;
	Select * From dbo.Delivery;

-- Insert Dataset into Delivery dummy columns
INSERT INTO Delivery (
	delivery_id,
	delivery_person_id,
	vehicle_id,
	order_id,
    del_person_age,
	del_person_rating,
    d_rest_lat,
    d_rest_long,
    d_loc_lat,
    d_loc_long,
    d_order_date,
    d_time_ordered,
    d_order_picked,
    d_weather,
    d_road_density,
    d_v_condition,
    d_o_type,
    d_v_type,
    d_m_del,
    d_festival,
    d_city
)
SELECT
    ID,
    Delivery_person_ID,
	ID,
	ID,
    Delivery_person_Age,
    Delivery_person_Ratings,
    Restaurant_latitude,
    Restaurant_longitude,
    Delivery_location_latitude,
    Delivery_location_longitude,
    Order_Date,
    Time_Orderd,
    Time_Order_Picked,
    Weather,
    Road_traffic_density,
    Vehicle_condition,
    Type_of_order,
    Type_of_vehicle,
    multiple_deliveries,
    Festival,
    City
FROM dbo.Amazon_Cleaned_Dataset$;

Select * From dbo.Delivery Order by delivery_id;


-- Join Order data to dummy_order_table to get ids for fact table
CREATE TABLE order_dummy_data (
    dummy_id INT PRIMARY KEY,
	dummy_cust_id int,
	dummy_cust_lat FLOAT,
	dummy_cust_long FLOAT,
	dummy_rest_id int,
    dummy_rest_lat FLOAT,
	dummy_rest_long FLOAT,
	dummy_o_type_id int,
    dummy_o_type NVARCHAR(255),
	dummy_o_date DATE,
    dummy_time time
);

Select * from order_dummy_Data;

-- Dummy Cleaning Order Insert
INSERT INTO order_dummy_data(
	dummy_id, dummy_cust_lat, dummy_cust_long, dummy_rest_lat, dummy_rest_long, dummy_o_type, dummy_o_date,dummy_time
)
Select delivery_id, d_loc_lat,d_loc_long, d_rest_lat,d_rest_long, d_o_type, d_order_date, d_time_ordered
FROM Delivery
Select* from order_dummy_Data;

-- populate the order_dummy_data table , customer_id column with this query
Select a.customer_id 
FROM Customer a
JOIN order_dummy_data b
	ON a.customer_latitude = b.dummy_cust_lat and a.customer_longitude = b.dummy_cust_long
order by b.dummy_id;

select * from order_dummy_data;
select * from Customer;

-- Dummy Cleaning Order Insert
INSERT INTO order_dummy_data(
	dummy_id, dummy_cust_lat, dummy_cust_long, dummy_rest_lat, dummy_rest_long, dummy_o_type, dummy_o_date,dummy_time)
Select delivery_id, d_loc_lat,d_loc_long, d_rest_lat,d_rest_long, d_o_type, d_order_date, d_time_ordered
FROM Delivery
Select* from order_dummy_Data;

-- populate the order_dummy_data table , customer_id column with this query
Select a.customer_id 
FROM Customer a
JOIN order_dummy_data b
	ON a.customer_latitude = b.dummy_cust_lat and a.customer_longitude = b.dummy_cust_long
order by b.dummy_id;

select * from order_dummy_data;
select * from Customer;

UPDATE order_dummy_data
SET dummy_cust_id = a.customer_id
FROM Customer a
JOIN order_dummy_data b
	ON a.customer_latitude = b.dummy_cust_lat AND a.customer_longitude = b.dummy_cust_long
WHERE b.dummy_id = b.dummy_id;


select * from order_dummy_data;
select * from Customer;

--populate the order dummy table resturant Id
Select a.rest_id, dummy_rest_id, dummy_rest_lat, dummy_rest_long
FROM Restaurant a
JOIN order_dummy_data b
	ON a.rest_lat = b.dummy_rest_lat and a.rest_long = b.dummy_rest_long
order by b.dummy_id;

UPDATE order_dummy_data
SET dummy_rest_id = a.rest_id
FROM Restaurant a
JOIN order_dummy_data b
	ON a.rest_lat = b.dummy_rest_lat AND a.rest_long = b.dummy_rest_long
WHERE b.dummy_id = b.dummy_id;

--test the table coherency
select * from order_dummy_data
where dummy_rest_id = '368';
select * from Restaurant
where rest_id = '368';

--Order Table Populate
INSERT INTO ORDERS (order_id, customer_id, rest_id, order_type, order_date, order_time)
Select dummy_id, dummy_cust_id, dummy_rest_id, dummy_o_type,dummy_o_date,dummy_time
FROM order_dummy_data;

Select * From order_dummy_data;
Select * from ORDERS;
Select * From Delivery;

-- Update Delivery with Order_id
UPDATE Delivery
SET order_id = a.delivery_id
FROM Delivery a
JOIN Orders b
	ON a.delivery_id = b.order_id
	Select * from Restaurant;
	Select * from Person;
	Select * From Delivery;

-- Insert Festival Data
INSERT INTO dbo.Festival (festival_id, festival_flag)
SELECT ROW_NUMBER() OVER (ORDER BY Festival) AS festival_id, Festival
FROM (
    SELECT DISTINCT Festival
    FROM Amazon_Cleaned_Dataset$
) AS a;
Select * From dbo.Festival;
Select * From dbo.Delivery;

-- Update festival_id in Delivery Table
UPDATE Delivery
SET festival_id = b.festival_id
FROM Delivery a
JOIN Festival b
	ON ISNULL(b.festival_flag, '') = ISNULL(a.d_festival, '')
Select * from Festival;
Select * from Delivery;

--Insert Traffic_Types Data into typ
Insert INTO dbo.Traffic_Types(traffic_id, traffic_density)
SELECT ROW_NUMBER() OVER (ORDER BY Road_traffic_density) AS traffic_id, Road_traffic_density
FROM (
Select distinct Road_traffic_density
FROM Amazon_Cleaned_Dataset$
) AS c;
Select * From dbo.Traffic_Types;

-- Update Traffic_Type
UPDATE Delivery
SET traffic_id = b.traffic_id
FROM Delivery a
JOIN Traffic_Types b
	ON ISNULL(b.traffic_density, '') = ISNULL(a.d_road_density, '')
Select * from Delivery;


-- Insert City_Type Condition Data
INSERT INTO dbo.City_type (city_type_id, city_type)
SELECT ROW_NUMBER() OVER (ORDER BY City) AS city_type_id, City
FROM (
	Select distinct City
	FROM Amazon_Cleaned_Dataset$
) AS a;

Select * From dbo.City_type;

-- Update Deliveries with city_id
UPDATE Delivery
SET city_type_id = b.city_type_id
FROM Delivery a
JOIN City_type b
	ON ISNULL(b.city_type, '') = ISNULL(a.d_city, '')

Select * from City_type;
Select * from Delivery;

--Insert Weather 
INSERT INTO dbo.Weather(weather_id, weather_type)
SELECT ROW_NUMBER() OVER (ORDER BY d_weather) AS weather_id, d_weather
FROM (
	Select distinct d_weather
	FROM Delivery
) AS a;

Select * from Weather;
Select * from Delivery;

-- Update Deliveries with weather_id
UPDATE Delivery
SET weather_id = b.weather_id
FROM Delivery a
JOIN Weather b
	ON ISNULL(b.weather_type, '') = ISNULL(a.d_weather, '')

Select * from Weather;
Select * from Delivery;


-- Update Deliveries with city_id
UPDATE Delivery
SET city_type_id = b.city_type_id
FROM Delivery a
JOIN City_type b
	ON ISNULL(b.city_type, '') = ISNULL(a.d_city, '')

Select * from City_type;
Select * from Delivery;



-- Insert Vehicle_condition Data
INSERT INTO dbo.Vehicle_Condition(vehicle_condition_id, vehicle_condition_desc)
SELECT ROW_NUMBER() OVER (ORDER BY Vehicle_condition) AS vehicle_condition_id, Vehicle_condition
FROM (
	Select distinct Vehicle_condition
	FROM Amazon_Cleaned_Dataset$
) AS a;


--Update Vehicle Condition column in Deliveries
UPDATE Delivery
SET vehicle_condition_id = b.vehicle_condition_id
FROM Delivery a
JOIN Vehicle_Condition b
	ON ISNULL(b.vehicle_condition_desc, '') = ISNULL(a.d_v_condition, '')

Select * from Vehicle_Condition;
Select * from Delivery;

-- Insert Vehicle_Type Data
INSERT INTO dbo.Vehicle_Type(vehicle_type_id, vehicle_type_desc)
SELECT ROW_NUMBER() OVER (ORDER BY Type_of_vehicle) AS vehicle_type_id, Type_of_vehicle
FROM (
	Select distinct Type_of_vehicle
	FROM Amazon_Cleaned_Dataset$
) AS a;

Select * From dbo.Vehicle_Type;

--Update Order Time
UPDATE Delivery
SET order_time_pickup = d_order_picked;

Select * from Vehicle_Condition;
Select * from Delivery;


ALTER TABLE Delivery
DROP COLUMN 
	d_rest_lat ,
	d_rest_long , 
	d_loc_lat ,
	d_loc_long,
	d_order_date ,
	d_time_ordered ,
	d_order_picked ,
	d_weather ,
	d_road_density ,
	d_v_condition ,
	d_o_type ,
	d_v_type ,
	d_city,
	d_festival
	;
Select * From dbo.Delivery order by delivery_id;

-- Insert Delivery_Person table Data

Select * FROM Delivery_Person;
Select distinct delivery_person_id FROM Delivery;
Select person_id FROM Person;

WITH RandomPersonIDs AS (
    SELECT person_id,
           ROW_NUMBER() OVER(ORDER BY NEWID()) AS RowNumber
    FROM Person
),
DistinctDeliveryPersonIDs AS (
    SELECT DISTINCT d.delivery_person_id
    FROM Delivery d
    LEFT JOIN Delivery_Person dp ON d.delivery_person_id = dp.delivery_person_id
    WHERE dp.delivery_person_id IS NULL
),
CombinedIDs AS (
    SELECT dd.delivery_person_id, rp.person_id,
           ROW_NUMBER() OVER(PARTITION BY dd.delivery_person_id ORDER BY NEWID()) AS RowNumber
    FROM DistinctDeliveryPersonIDs AS dd
    CROSS JOIN RandomPersonIDs AS rp
)
INSERT INTO Delivery_Person (delivery_person_id, person_id)
SELECT delivery_person_id, person_id
FROM CombinedIDs
WHERE RowNumber = 1;

Select * FROM Delivery_Person;

-- Test Statements
Select top (100) * From Customer;
Select top (100) * From Person;

Select * From dbo.Festival;
Select * From dbo.Restaurant;
Select * From dbo.Traffic_Types;
Select * From dbo.City_type;
Select * From dbo.Vehicle_Condition;
Select * From dbo.Vehicle_Type;
Select * From dbo.Vehicles;
Select * From dbo.Delivery;
Select * From dbo.Delivery_Person;
Select * From dbo.Orders;
Select * From dbo.Order_Detail;

Select  * From dbo.Amazon_Cleaned_Dataset$


-- Vehicle Table

ALTER TABLE Delivery
ADD d_vehicle_id int,
	d_vehicle_type nvarchar(255);
Select * from Delivery


UPDATE Delivery
Set d_vehicle_type = b.Type_of_vehicle
FROM Delivery a
Join Amazon_Cleaned_Dataset$ as b
	ON b.ID = a.delivery_id;
Select * from Delivery;

UPDATE d
SET d.d_vehicle_id = vt.vehicle_type_id
FROM Delivery AS d
JOIN Vehicle_type AS vt ON d.d_vehicle_type = vt.vehicle_type_desc;

INSERT INTO Vehicles (vehicle_id, vehicle_type_id)
SELECT vehicle_id, d_vehicle_id
FROM Delivery;

ALTER TABLE [City_type]
	ADD CONSTRAINT [XPKCity_type] PRIMARY KEY  CLUSTERED ([city_type_id] ASC)
go

ALTER TABLE [Customer]
	ADD CONSTRAINT [XPKCustomer] PRIMARY KEY  CLUSTERED ([customer_id] ASC)
go

ALTER TABLE [Delivery]
	ADD CONSTRAINT [XPKDelivery] PRIMARY KEY  CLUSTERED ([delivery_id] ASC)
go

ALTER TABLE [Delivery_Person]
	ADD CONSTRAINT [XPKDelivery_Person] PRIMARY KEY  CLUSTERED ([delivery_person_id] ASC)
go

ALTER TABLE [Festival]
	ADD CONSTRAINT [XPKFestival] PRIMARY KEY  CLUSTERED ([festival_id] ASC)
go

ALTER TABLE [Order_Detail]
	ADD CONSTRAINT [XPKOrder_Detail] PRIMARY KEY  CLUSTERED ([order_item_id] ASC)
go

ALTER TABLE [Orders]
	ADD CONSTRAINT [XPKOrders] PRIMARY KEY  CLUSTERED ([order_id] ASC)
go

ALTER TABLE [Person]
	ADD CONSTRAINT [XPKPerson] PRIMARY KEY  CLUSTERED ([person_id] ASC)
go

ALTER TABLE [Restaurant]
	ADD CONSTRAINT [XPKRestaurant] PRIMARY KEY  CLUSTERED ([rest_id] ASC)
go

ALTER TABLE [Traffic_Types]
	ADD CONSTRAINT [XPKTraffic_Types] PRIMARY KEY  CLUSTERED ([traffic_id] ASC)
go

ALTER TABLE [Vehicle_Condition]
	ADD CONSTRAINT [XPKVehicle_Condition] PRIMARY KEY  CLUSTERED ([vehicle_condition_id] ASC)
go

ALTER TABLE [Vehicle_Type]
	ADD CONSTRAINT [XPKVehicle_Type] PRIMARY KEY  CLUSTERED ([vehicle_type_id] ASC)
go

ALTER TABLE [Vehicles]
	ADD CONSTRAINT [XPKVehicles] PRIMARY KEY  CLUSTERED ([vehicle_id] ASC)
go

ALTER TABLE [Weather]
	ADD CONSTRAINT [XPKWeather] PRIMARY KEY  CLUSTERED ([weather_id] ASC)
go


ALTER TABLE [Customer]
	ADD CONSTRAINT [R_14] FOREIGN KEY ([person_id]) REFERENCES [Person]([person_id])
go


ALTER TABLE [Delivery]
	ADD CONSTRAINT [R_5] FOREIGN KEY ([delivery_person_id]) REFERENCES [Delivery_Person]([delivery_person_id])
go



ALTER TABLE [Delivery]
	ADD CONSTRAINT [R_9] FOREIGN KEY ([traffic_id]) REFERENCES [Traffic_Types]([traffic_id])
		ON DELETE SET NULL
		ON UPDATE SET NULL
go

ALTER TABLE [Delivery]
	ADD CONSTRAINT [R_10] FOREIGN KEY ([weather_id]) REFERENCES [Weather]([weather_id])
		ON DELETE SET NULL
		ON UPDATE SET NULL
go

ALTER TABLE [Delivery]
	ADD CONSTRAINT [R_11] FOREIGN KEY ([city_type_id]) REFERENCES [City_type]([city_type_id])
		ON DELETE SET NULL
		ON UPDATE SET NULL
go

ALTER TABLE [Delivery]
	ADD CONSTRAINT [R_29] FOREIGN KEY ([order_id]) REFERENCES [Orders]([order_id])
go

ALTER TABLE [Delivery]
	ADD CONSTRAINT [R_32] FOREIGN KEY ([vehicle_id]) REFERENCES [Vehicles]([vehicle_id])
go

ALTER TABLE [Delivery]
	ADD CONSTRAINT [R_34] FOREIGN KEY ([festival_id]) REFERENCES [Festival]([festival_id])
		ON DELETE SET NULL
		ON UPDATE SET NULL
go

ALTER TABLE [Delivery]
	ADD CONSTRAINT [R_36] FOREIGN KEY ([vehicle_condition_id]) REFERENCES [Vehicle_Condition]([vehicle_condition_id])
		ON DELETE SET NULL
		ON UPDATE SET NULL
go


ALTER TABLE [Delivery_Person]
	ADD CONSTRAINT [R_15] FOREIGN KEY ([person_id]) REFERENCES [Person]([person_id])
go


ALTER TABLE [Order_Detail]
	ADD CONSTRAINT [R_35] FOREIGN KEY ([order_id]) REFERENCES [Orders]([order_id])
go


ALTER TABLE [Orders]
	ADD CONSTRAINT [R_17] FOREIGN KEY ([customer_id]) REFERENCES [Customer]([customer_id])
go

ALTER TABLE [Orders]
	ADD CONSTRAINT [R_19] FOREIGN KEY ([rest_id]) REFERENCES [Restaurant]([rest_id])
go


ALTER TABLE [Restaurant]
	ADD CONSTRAINT [R_16] FOREIGN KEY ([person_id]) REFERENCES [Person]([person_id])
go


ALTER TABLE [Vehicles]
	ADD CONSTRAINT [R_22] FOREIGN KEY ([vehicle_type_id]) REFERENCES [Vehicle_Type]([vehicle_type_id])
go

