CREATE DATABASE ev_analysis;
USE ev_analysis;

CREATE TABLE india_ev (
    State VARCHAR(100),
    EV_Sales_FY2023_thousands FLOAT,
    Charging_Stations FLOAT,
    EV_Sales INT,
    EVs_per_Charger FLOAT,
    Gap_vs_Global_Standard FLOAT,
    Gap_Severity VARCHAR(50)
);
INSERT INTO india_ev (State, EV_Sales, Charging_Stations, EVs_per_Charger, Gap_vs_Global_Standard, Gap_Severity)
VALUES 
('Ladakh', 500, 0, 500, 490, 'Extreme Crisis'),
('Mizoram', 1000, 0, 1000, 990, 'Extreme Crisis');

UPDATE india_ev
SET Gap_Severity = 'At Global Standard'
WHERE State = 'Lakshadweep';
select * from india_ev;

USE ev_analysis;
SELECT * FROM india_ev


USE ev_analysis;
-- Which states have the highest gap between the number of chargers needed and the number that actually exist?
SELECT
State,
EV_Sales,
Charging_Stations,
GREATEST(ROUND(EV_Sales / 10) - Charging_Stations, 0) AS Charger_Gap
FROM india_ev
ORDER BY Charger_Gap DESC;

-- Which states have the highest EV adoption in India?
SELECT
State,
EV_Sales
FROM india_ev
ORDER BY EV_Sales DESC;

-- How many total EVs have we accounted for so far?
SELECT
State,
EV_Sales,
SUM(EV_Sales) OVER (ORDER BY EV_Sales DESC) AS Running_Total
FROM india_ev
ORDER BY EV_Sales DESC;

-- Which states together make up 80% of India's entire EV market-and where should a startup invest first?
SELECT
State,
EV_Sales,
SUM(EV_Sales) OVER (ORDER BY EV_Sales DESC) AS Running_Total,
SUM(EV_Sales) OVER () AS Grand_Total,
ROUND(SUM(EV_Sales) OVER (ORDER BY EV_Sales DESC) * 100.0 / SUM(EV_Sales) OVER(), 1) AS Cumulative_Pct
FROM india_ev
ORDER BY EV_Sales DESC;


-- Which state has the second highest number of public charging stations in India, and how does it compare to the leader?"
SELECT
State,
Charging_Stations
FROM india_ev
WHERE Charging_Stations = (
    SELECT MAX(Charging_Stations)
    FROM india_ev
    WHERE Charging_Stations < (
	SELECT MAX(Charging_Stations)
	FROM india_ev))


