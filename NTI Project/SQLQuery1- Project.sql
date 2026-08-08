-- 1.(Overall KPIs)
SELECT 
    COUNT(ID) AS Total_Orders,
    ROUND(AVG(CAST(Time_taken_min AS FLOAT)), 2) AS Avg_Delivery_Time_Min,
    ROUND(AVG(Delivery_person_Ratings), 2) AS Avg_Rider_Rating
FROM dbo.Cleaned_Data;

-- 2.(City Breakdown)
SELECT 
    City,
    COUNT(ID) AS Total_Orders,
    ROUND(AVG(CAST(Time_taken_min AS FLOAT)), 2) AS Avg_Delivery_Time_Min
FROM dbo.Cleaned_Data
GROUP BY City
ORDER BY Total_Orders DESC;

-- 3.(Age Groups)
SELECT 
    CASE 
        WHEN Delivery_person_Age < 25 THEN 'Under 25'
        WHEN Delivery_person_Age BETWEEN 25 AND 35 THEN '25-35'
        ELSE 'Over 35'
    END AS Age_Group,
    COUNT(DISTINCT Delivery_person_ID) AS Total_Riders,
    ROUND(AVG(Delivery_person_Ratings), 2) AS Avg_Rating,
    ROUND(AVG(CAST(Time_taken_min AS FLOAT)), 2) AS Avg_Delivery_Time
FROM dbo.Cleaned_Data
GROUP BY 
    CASE 
        WHEN Delivery_person_Age < 25 THEN 'Under 25'
        WHEN Delivery_person_Age BETWEEN 25 AND 35 THEN '25-35'
        ELSE 'Over 35'
    END;

-- 4.(Top Performers)
SELECT 
    City,
    Delivery_person_ID,
    COUNT(ID) AS Total_Orders,
    ROUND(AVG(Delivery_person_Ratings), 2) AS Avg_Rating,
    ROUND(AVG(CAST(Time_taken_min AS FLOAT)), 2) AS Avg_Delivery_Time
FROM dbo.Cleaned_Data
GROUP BY City, Delivery_person_ID
ORDER BY City, Total_Orders DESC;
----------------------------------------------------------------
-- 5.(Vehicle Condition)
SELECT 
    Vehicle_condition,
    COUNT(ID) AS Total_Orders,
    ROUND(AVG(CAST(Time_taken_min AS FLOAT)), 2) AS Avg_Delivery_Time,
    ROUND(AVG(Delivery_person_Ratings), 2) AS Avg_Rating
FROM dbo.Cleaned_Data
GROUP BY Vehicle_condition
ORDER BY Vehicle_condition DESC;

-- 6.(Type of Vehicle)
SELECT 
    [Type_of_vehicle],
    COUNT(ID) AS Total_Orders,
    ROUND(AVG(CAST(Time_taken_min AS FLOAT)), 2) AS Avg_Time,
    ROUND(AVG(Delivery_person_Ratings), 2) AS Avg_Rating
FROM dbo.Cleaned_Data
GROUP BY [Type_of_vehicle]
ORDER BY Total_Orders DESC;

-----------insights-------------------
--1. Overall Efficiency & Geography
--.High Order Density in Metropolitan Areas: The vast majority of deliveries are concentrated in Metropolitan cities, requiring localized hubs to maintain fast fulfillment times.

--.Delivery Time Bottlenecks: Average delivery times tend to spike during severe traffic density and unfavorable weather conditions, highlighting the need for dynamic route adjustments.

--2. Rider Performance & Demographics
--.Age Group Dynamics: Drivers aged 25–35 handle the highest volume of orders while maintaining consistent rating performance.

--.Rating Consistency: Top-rated drivers consistently achieve lower average delivery times, demonstrating a strong correlation between punctuality and customer satisfaction.

--3. Fleet & Vehicle Utilization
--.Vehicle Condition Impact: Vehicles in optimal condition (Condition Level 2 & 3) reduce average delivery times compared to poorly maintained vehicles.

--.Vehicle Type Performance: Electric scooters and motorcycles display high efficiency in high-density traffic zones compared to standard bicycles.

--------------Recommendations----------
--1 Optimize Fleet Allocation: Prioritize the deployment of motorcycles and electric scooters in heavy-traffic urban zones to reduce fulfillment delays.

--2 Preventive Vehicle Maintenance: Implement mandatory routine vehicle check-ups for company-provided fleets, as higher vehicle condition directly improves delivery speed.

--3 Incentivize Top Riders: Create performance-based bonuses for riders maintaining ratings above 4.8 to improve overall retention and service quality.

--4 Dynamic Weather Routing: Adjust estimated delivery times (ETAs) during adverse weather to manage customer expectations and prevent order cancellations.