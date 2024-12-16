WITH MonthlyTrends AS (
    SELECT 
        dc.city_name,
        dd.month_name,
        SUM(fps.total_passengers) AS total_passengers,
        SUM(fps.repeat_passengers) AS repeat_passengers,
        (SUM(fps.repeat_passengers) / SUM(fps.total_passengers)) * 100 AS monthly_repeat_passenger_rate
    FROM 
        fact_passenger_summary fps
    JOIN 
        dim_city dc 
        ON fps.city_id = dc.city_id
	join dim_date dd on fps.month=dd.start_of_month
    GROUP BY 
        dc.city_name, dd.month_name
),
CityTrends AS (
    SELECT 
        city_name,
        SUM(repeat_passengers) AS total_repeat_passengers,
        SUM(total_passengers) AS total_city_passengers,
        (SUM(repeat_passengers) / SUM(total_passengers)) * 100 AS city_repeat_passenger_rate
    FROM 
        MonthlyTrends
    GROUP BY 
        city_name
)
SELECT 
    mt.city_name,
    mt.month_name,
    mt.total_passengers,
    mt.repeat_passengers,
    mt.monthly_repeat_passenger_rate,
    ct.city_repeat_passenger_rate
FROM 
    MonthlyTrends mt
JOIN 
    CityTrends ct
ON 
    mt.city_name = ct.city_name
ORDER BY 
    mt.city_name, mt.month_name;
