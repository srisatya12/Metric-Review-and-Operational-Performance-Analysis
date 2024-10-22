-- use project3;
-- CREATE TABLE job_data
--  (
--      ds DATE,
--      job_id INT NOT NULL,
-- 	actor_id INT NOT NULL,
--    event VARCHAR(15) NOT NULL,
--      language VARCHAR(15) NOT NULL,
--      time_spent INT NOT NULL,
--      org CHAR(2)
--  );
--  INSERT INTO job_data (ds, job_id, actor_id, event, language, time_spent, org)
--  VALUES ('2020-11-30', 21, 1001, 'skip', 'English', 15, 'A'),
--      ('2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
--      ('2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
--      ('2020-11-28', 23, 1005,'transfer', 'Persian', 22, 'D'),
--      ('2020-11-28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
--      ('2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
--      ('2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
--      ('2020-11-25', 20, 1003, 'transfer', 'Italian', 45, 'C');


#1. Jobs Reviewed Over Time:

SELECT 
    ds, 
    sum(time_spent)/3600 AS hour_of_day, 
    COUNT(job_id) AS jobs_reviewed
FROM 
    job_data
WHERE 
    ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY ds;

#2.Throughput Analysis

WITH daily_throughput AS (
    SELECT 
        ds, 
        COUNT(job_id) AS daily_events,
        SUM(time_spent) AS total_time_spent
    FROM 
        job_data
	WHERE event IN('transfer','decision')
    AND ds BETWEEN '2020-11-01' AND '2020-11-30'
    GROUP BY 
        ds
)
SELECT 
    ds,
    ROUND(1.0*SUM(daily_events) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) / SUM(total_time_spent) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS rolling_throughput
FROM 
    daily_throughput;


#3. Language Share Analysis

WITH last_30_days_data AS (
    SELECT 
        language, 
        COUNT(job_id) AS job_count
    FROM 
        job_data
    WHERE 
        event IN ('transfer', 'decision')
        AND ds BETWEEN '2020-11-01' AND '2020-11-30'
    GROUP BY 
        language
),
total_jobs AS (
    SELECT 
        COUNT(job_id) AS total_job_count
    FROM 
       job_data
	WHERE 
        event IN ('transfer', 'decision')
        AND ds BETWEEN '2020-11-01' AND '2020-11-30'
    GROUP BY 
        language
)
SELECT 
    language, 
    ROUND(100.0 * job_count / total_job_count, 2) AS language_share_percentage
FROM 
    last_30_days_data
    CROSS JOIN total_jobs
    ORDER BY language_share_percentage desc;

#4. Duplicate Rows Detection

SELECT ds
FROM job_data
GROUP BY ds
HAVING COUNT(ds) > 1;


