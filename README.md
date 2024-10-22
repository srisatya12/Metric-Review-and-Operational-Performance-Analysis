# Metric-Review-and-Operational-Performance-Analysis


## Project Overview
Operational Analytics is a crucial process that involves analyzing a company's end-to-end operations to identify areas for improvement. In this project, I took on the role of a Lead Data Analyst at a company similar to Microsoft, where I worked closely with various teams, such as operations, support, and marketing, to derive valuable insights from the data collected.

## Key Aspects
A significant focus of Operational Analytics is investigating metric spikes, which involves understanding and explaining sudden changes in key metrics, such as dips in daily user engagement or drops in sales. This analysis is vital for addressing daily queries and improving company operations.

## Case Study 1: Job Data Analysis
This case study involved working with a table named `job_data` containing the following columns:

- **job_id**: Unique identifier of jobs
- **actor_id**: Unique identifier of actor
- **event**: Type of event (decision/skip/transfer)
- **language**: Language of the content
- **time_spent**: Time spent reviewing the job in seconds
- **org**: Organization of the actor
- **ds**: Date in the format yyyy/mm/dd (stored as text)

### Tasks:
1. **Jobs Reviewed Over Time**: The number of jobs reviewed per hour for each day in November 2020 was calculated.
2. **Throughput Analysis**: The 7-day rolling average of throughput (number of events per second) was determined, and a preference for using either the daily metric or the 7-day rolling average for throughput was discussed.
3. **Language Share Analysis**: The percentage share of each language over the last 30 days was calculated.
4. **Duplicate Rows Detection**: Duplicate rows in the `job_data` table were identified.

## Case Study 2: Investigating Metric Spike
In this case study, I worked with three tables:

- **users**: Contains one row per user, with descriptive information about that user's account.
- **events**: Contains one row per event, representing actions taken by users (e.g., login, messaging, search).
- **email_events**: Contains events specific to the sending of emails.

### Tasks:
1. **Weekly User Engagement**: The activeness of users on a weekly basis was measured.
2. **User Growth Analysis**: The growth of users over time for a product was analyzed.
3. **Weekly Retention Analysis**: The retention of users on a weekly basis after signing up for a product was calculated based on their sign-up cohort.
4. **Weekly Engagement Per Device**: The activeness of users on a weekly basis per device was measured.
5. **Email Engagement Analysis**: Engagement metrics related to the email service were calculated.

## Insights
For each task, insights and interpretations of the results obtained from the queries were provided to enhance understanding and support data-driven decisions.

