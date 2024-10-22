

 SHOW VARIABLES LIKE 'secure_file_prive';

CREATE TABLE events (
    user_id INT NOT NULL,
    occurred_at DATETIME,  -- Changed to DATETIME to store both date and time
    event_type VARCHAR(50) NOT NULL,
    event_name VARCHAR(50),
    location VARCHAR(50) NOT NULL,
    device VARCHAR(100) NOT NULL,
    user_type INT NOT NULL
);

 CREATE TABLE users 
(
    user_id	INT,
    created_at	DATETIME,
   company_id	INT,
     language	VARCHAR(40),
     activated_at DATETIME,
    state	VARCHAR(60)
);

CREATE TABLE email_events
 (
    user_id	INT,
    occurred_at	DATETIME,
    action	VARCHAR(200),
    user_type int
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv' 
INTO TABLE events 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(user_id, @occurred_at, event_type, event_name, location, device, user_type)
SET occurred_at = STR_TO_DATE(@occurred_at, '%d-%m-%Y %H:%i:%s');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv' 
INTO TABLE users 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(user_id, @created_at, company_id, language, @activated_at, state)
SET created_at = STR_TO_DATE(@created_at, '%d-%m-%Y %H:%i:%s'),
    activated_at = STR_TO_DATE(@activated_at, '%d-%m-%Y %H:%i:%s');


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv' 
INTO TABLE email_events 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(user_id, @occurred_at, action, user_type)
SET occurred_at = STR_TO_DATE(@occurred_at, '%d-%m-%Y %H:%i:%s');


-- 1. Weekly User Engagement
select week(occurred_at) as week,count(distinct user_id) as weekly_user_engagement
from events
where event_type='engagement'
group by week(occurred_at)
order by week(occurred_at);

-- 2.User Growth Analysis

select year, num_week, num_active_users,
sum(num_active_users) over(order by year, num_week rows between unbounded preceding and current row) 
as cumm_active_users
from
(select 
    extract(year from a.activated_at) as year,
    extract(week from a.activated_at)as num_week,
    count(distinct user_id) as num_active_users
from users a 
where state LIKE'%active%' 
group by year, num_week 
order by year, num_week
)a;


-- 3.Weekly Retention Analysis:
select t1.week_num,(t2.old_users - t1.new_users)as Retained_users
from(select week(occurred_at) as week_num,
count(distinct user_id) as new_users
from events
where event_type = "signup_flow"
group by week_num) as t1
Join
(select week(occurred_at) as week_num,
count(distinct user_id) as old_users
from events
where event_type = "engagement"
group by week_num) as t2
on t1.week_num = t2.week_num;

-- 4.Weekly Engagement Per Device
select week(occurred_at) as weeks,device,count(distinct user_id) as device_engagement
from events
group by device, week(occurred_at)
order by week(occurred_at);


-- 5.Email Engagement Analysis
select distinct week(occurred_at) as week_num,
count(distinct case when action = 'sent_weekly_digest' then user_id end) as email_digest,
count(distinct case when action ='email_open' then user_id end) as email_open,
count(distinct case when action = 'email_clickthrough' THEN user_id end) as click_throgh,
count(distinct case when action='sent_reengagement_email' then user_id end) as reengagement_emails
from email_events
group by week(occurred_at);