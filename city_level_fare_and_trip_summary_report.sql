SELECT 
    ci.city_name, 
    COUNT(ft.city_id) AS total_trips,
    AVG(ft.fare_amount / ft.distance_travelled_km) AS average_fare_per_km, 
    SUM(ft.fare_amount) / COUNT(ft.city_id) AS avg_fare_per_trip,
    (COUNT(ft.city_id) * 100.0) / SUM(COUNT(ft.city_id)) over() AS contribution_percentage
FROM 
    fact_trips ft 
join dim_city ci on ft.city_id = ci.city_id
GROUP BY 
    ci.city_name;