SELECT 
    dc.city_name,
    dd.month_name,
    COUNT(ft.city_id) AS actual_trips,
    mt.total_target_trips AS target_trips ,
    case 
    when COUNT(ft.city_id) > mt.total_target_trips Then "Above Target" else "Below Target" end as performance_status,
	 CASE 
        WHEN mt.total_target_trips > 0 THEN 
            ROUND(((COUNT(ft.city_id) - mt.total_target_trips) * 100.0) / mt.total_target_trips, 2)
        ELSE 
            NULL
    END AS percentage_difference
FROM 
    fact_trips ft
JOIN 
    dim_city dc
    ON ft.city_id = dc.city_id
JOIN 
    dim_date dd
    ON ft.date = dd.date
LEFT JOIN 
    targets_db.monthly_target_trips mt
    ON ft.city_id = mt.city_id
    AND dd.start_of_month = mt.month
GROUP BY 
    dc.city_name, dd.month_name, mt.total_target_trips
ORDER BY 
    dc.city_name, dd.month_name;
