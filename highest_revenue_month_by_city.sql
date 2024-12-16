WITH CityRevenue AS (
    SELECT 
        dc.city_name,
        dd.month_name,
        SUM(ft.fare_amount) AS monthly_revenue,
        SUM(SUM(ft.fare_amount)) OVER (PARTITION BY dc.city_name) AS total_revenue_for_city
    FROM 
        trips_db.fact_trips ft
    JOIN 
        dim_city dc 
        ON ft.city_id = dc.city_id
    LEFT JOIN 
        dim_date dd 
        ON DATE(ft.date) = dd.date
    GROUP BY 
        dc.city_name, dd.month_name
),
RankedCityRevenue AS (
    SELECT 
        city_name,
        month_name,
        monthly_revenue,
        total_revenue_for_city,
        RANK() OVER (PARTITION BY city_name ORDER BY monthly_revenue DESC) AS revenue_rank,
        (monthly_revenue / total_revenue_for_city) * 100 AS percentage_distribution
    FROM 
        CityRevenue
)
SELECT 
    city_name,
    month_name,
    monthly_revenue AS highest_revenue,
    percentage_distribution
FROM 
    RankedCityRevenue
WHERE 
    revenue_rank = 1
ORDER BY 
    city_name;
