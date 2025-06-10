
-- Please edit the sample below

CREATE VIEW source_dates 
AS
SELECT DISTINCT OrderDate AS source_date
FROM
adventureworks.adventureworks.salesorderheader
UNION
SELECT DISTINCT ShipDate AS source_date
FROM
adventureworks.adventureworks.salesorderheader
UNION
SELECT DISTINCT DueDate AS source_date
FROM
adventureworks.adventureworks.salesorderheader;

CREATE VIEW source_dates_explode
AS
select explode(sequence(
  (SELECT MIN(source_date) FROM source_dates), 
  (SELECT MAX(source_date) FROM source_dates), 
  interval 1 day)) as calendarDate;

CREATE MATERIALIZED VIEW dim_date
AS 
SELECT 
  year(calendarDate) * 10000 + month(calendarDate) * 100 + day(calendarDate) as DateKey,
  calendarDate AS `Date`,
  day(calendarDate) AS DayofMonth,
  month(calendarDate) as MonthNumber,
  date_format(calendarDate, 'MMMM') as Month,
  year(calendarDate) * 100 + month(calendarDate) as YearMonthInt,
  year(calendarDate) AS Year,
  dayofweek(calendarDate) AS DayOfWeekNumber,
  date_format(calendarDate, 'EEEE') as DayofWeek
FROM source_dates_explode