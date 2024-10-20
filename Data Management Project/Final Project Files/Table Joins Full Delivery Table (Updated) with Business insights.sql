-- SQL QUERY FOR ALL ITEMS TOGETHER

Select * FROM City_type;
Select * FROM Customer;
Select * FROM Delivery;
Select * FROM Delivery_Person;
Select * FROM Festival;
Select * FROM Order_Detail;
Select * FROM Orders;
Select * FROM Person;
Select * FROM Restaurant;
Select * FROM Traffic_Types;
Select * FROM Vehicle_Condition;
Select * FROM Vehicle_Type;
Select * FROM Vehicles;
Select * FROM Weather;
Select * FROM Amazon_Cleaned_Dataset$;



Select a.delivery_id,
	   b.order_type,
	   b.order_time,  
	   d.person_fname as Deliver_person_fname, 
	   d.person_lname as Deliver_person_lname,
	   e.vehicle_VIN,
	   f.vehicle_type_desc,
	   g.vehicle_condition_desc,
	   i.person_fname as Customer_fname,
	   i.person_lname as Customer_lname,
	   h.customer_latitude,
	   h.customer_longitude,
	   j.res_name,
	   j.rest_lat,
	   j.rest_long,
	   k.person_fname as Restaurant_Contact_fname,
	   k.person_lname as Restaurant_Contact_lname,
	   l.weather_type,
	   m.traffic_density,
	   n.city_type,
	   b.order_id,
	   c.delivery_person_id,
	   d.person_id as d_person__id,
	   i.person_id as c_person_id,
	   k.person_id as r_person_id,
	   h.customer_id,
	   j.rest_id,
	   e.vehicle_id,
	   f.vehicle_type_id,
	   g.vehicle_condition_id,
	   l.weather_id,
	   m.traffic_id,
	   n.city_type_id,
	   a.order_time_pickup,
	   o.festival_flag,
	   DATEDIFF(minute,b.order_time,a.order_time_pickup) as Time_diff
FROM Delivery a
JOIN Orders b ON b.order_id = a.order_id
JOIN Delivery_Person c ON c.delivery_person_id = a.delivery_person_id
JOIN Person d ON d.person_id = c.person_id
JOIN Vehicles e ON e.vehicle_id = a.vehicle_id
JOIN Vehicle_Type f ON f.vehicle_type_id = e.vehicle_type_id
JOIN Vehicle_Condition g ON g.vehicle_condition_id = a.vehicle_condition_id
JOIN Customer h ON h.customer_id = b.customer_id
JOIN Person i ON i.person_id=h.person_id
JOIN Restaurant j ON j.rest_id = b.rest_id
JOIN Person k ON k.person_id = j.person_id
JOIN Weather l ON l.weather_id = a.weather_id
JOIN Traffic_Types m ON m.traffic_id = a.traffic_id
JOIN City_type n ON n.city_type_id = a.city_type_id
JOIN Festival o ON o.festival_id = a.festival_id;

SELECT a.delivery_id,
       b.order_type,
       b.order_time,
       d.person_fname as Deliver_person_fname, 
       d.person_lname as Deliver_person_lname,
       e.vehicle_VIN,
       f.vehicle_type_desc,
       g.vehicle_condition_desc,
       i.person_fname as Customer_fname,
       i.person_lname as Customer_lname,
       h.customer_latitude,
       h.customer_longitude,
       j.res_name,
       j.rest_lat,
       j.rest_long,
       k.person_fname as Restaurant_Contact_fname,
       k.person_lname as Restaurant_Contact_lname,
       l.weather_type,
       m.traffic_density,
       n.city_type,
       b.order_id,
       c.delivery_person_id,
       d.person_id as d_person__id,
       i.person_id as c_person_id,
       k.person_id as r_person_id,
       h.customer_id,
       j.rest_id,
       e.vehicle_id,
       f.vehicle_type_id,
       g.vehicle_condition_id,
       l.weather_id,
       m.traffic_id,
       n.city_type_id,
       a.order_time_pickup,
       (Case 
	   When  (b.order_time is null or a.order_time_pickup is null) Then 0
	   Else DATEDIFF(minute,b.order_time,a.order_time_pickup)
	   End) as Time_diff,
	   a.del_person_rating,
	   a.del_person_age,
	   o.festival_flag
INTO #TempTable
FROM Delivery a
JOIN Orders b ON b.order_id = a.order_id
JOIN Delivery_Person c ON c.delivery_person_id = a.delivery_person_id
JOIN Person d ON d.person_id = c.person_id
JOIN Vehicles e ON e.vehicle_id = a.vehicle_id
JOIN Vehicle_Type f ON f.vehicle_type_id = e.vehicle_type_id
JOIN Vehicle_Condition g ON g.vehicle_condition_id = a.vehicle_condition_id
JOIN Customer h ON h.customer_id = b.customer_id
JOIN Person i ON i.person_id=h.person_id
JOIN Restaurant j ON j.rest_id = b.rest_id
JOIN Person k ON k.person_id = j.person_id
JOIN Weather l ON l.weather_id = a.weather_id
JOIN Traffic_Types m ON m.traffic_id = a.traffic_id
JOIN City_type n ON n.city_type_id = a.city_type_id
JOIN Festival o ON o.festival_id = a.festival_id;

-- you can now use the #TempTable in subsequent queries

Select * From #TempTable;

--Delivery Average time from order to pickup
Select distinct delivery_person_id
, Deliver_person_fname
, Deliver_person_lname
, avg(Time_diff) as avg_time
, count(Time_diff) as num_deliveries
, avg(del_person_rating)
, max(del_person_age)
From #TempTable
group by delivery_person_id,Deliver_person_fname,Deliver_person_lname
having  avg(Time_diff) > 0 and count(Time_diff) > 5
Order by avg_time;


-- Average time by vehicle and weather
Select  n.vehicle_type_desc,n.Weather, avg(n.Time_diff) as avg_time, count(n.Time_diff) as "Number of del", SUM(n.Time_diff) as SUM_Time
FROM (Select b.weather_type as Weather, b.vehicle_type_desc, b.Time_diff FROM #TempTable b where Time_diff > 0) n
Group by  vehicle_type_desc,Weather
Order by Weather;


-- Average # of deliveries by festival and traffic density
Select  n.traffic_density,
festival_flag, 
avg(n.Time_diff) as avg_time, 
count(n.Time_diff) as "Number of del", 
SUM(n.Time_diff) as SUM_Time, 
(Case 
When  traffic_density = 'Low' then '1'
When  traffic_density = 'Medium' then '2'
When  traffic_density = 'High' then '3'
When  traffic_density = 'Jam' then '4'
Else '5'
End
) as sort_order
FROM (
		Select b.festival_flag,b.traffic_density, b.Time_diff 
		FROM #TempTable b 
			where Time_diff > 0 and festival_flag is not null
	) n
Group by  traffic_density,festival_flag
order by festival_flag,sort_order;

