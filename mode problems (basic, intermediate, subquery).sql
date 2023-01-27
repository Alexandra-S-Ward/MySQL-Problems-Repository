/* 
	Mode Basics Problems
    
*/

-- Select
SELECT year,
       month,
       month_name,
       west,
       midwest,
       south,
       northeast
  FROM tutorial.us_housing_units;

SELECT year as "Year",
       month as "Month",
       month_name as "Month Name",
       west as "West",
       midwest as "Midwest",
       south as "South",
       northeast as "North East"
  FROM tutorial.us_housing_units;

-- Limit
SELECT year, month from tutorial.us_housing_units limit 15;

-- Where -> Comparative
select * from tutorial.us_housing_events where west > 50;
select * from tutorial.us_housing_events where south <= 20;
SELECT *  FROM tutorial.us_housing_units WHERE month_name = 'February'; or SELECT *  FROM tutorial.us_housing_units WHERE month_name like 'February';
select * from tutorial.us_housing_units where west > (midwest + northeast);

-- Where -> Logical
select * from tutorial.billboard_top_100_year_end where "group" like '%Ludacris%'; -- like
select * from tutorial.billboard_top_100_year_end where year IN(1990, 1993, 1995, 1996); -- IN
select * from tutorial.billboard_top_100_year_end where year_rank between 1 and 5; -- Between, inclusive 

-- Is Null
select * from tutorial.billboard_top_100_year_end where (artist is null or year is null) and year > 1995;  -- Is null, or and and

-- NOT 
select year, year_rank, song_name from tutorial.billboard_top_100_year_end where artist like 'Drake' and year_rank not between 1 and 5; -- Check Drake's worst performing songs?

-- ORDER BY
select song_name from tutorial.billboard_top_100_year_end where year = 2012 order by song_name desc; -- order by reverse alphabetical order


/* 
	
    Intermediate Mode Problems 
    
    
*/
-- Count
select count(low) from tutorial.aapl_historical_stock_price;
select COUNT(year) as "Year",
       COUNT(month) as "Month",
       COUNT(open) as "Open",
       COUNT(high) as "High",
       COUNT(low) as "Low",
       COUNT(close) as "Close",
       COUNT(volume) as "Volume"
from tutorial.aapl_historical_stock_price;

-- Sum
select sum(open)/count(open) from tutorial.aapl_historical_stock_price;

-- min/max
select min(low) from tutorial.aapl_historical_stock_price;
select max(close-open) from tutorial.aapl_historical_stock_price;
select avg(volume) from tutorial.aapl_historical_stock_price;

-- group by
select month, sum(volume) from tutorial.aapl_historical_stock_price group by month order by month;
select year, avg(close-open) from tutorial.aapl_historical_stock_price group by year order by year;
select year, month, min(low), max(high) from tutorial.aapl_historical_stock_price group by year, month order by year, month;

-- Case
select player_name,
      case 
        when state = 'CA' then 'Yes' else 'No'
      end as california_player
      from benn.college_football_players
      order by california_player desc;

-- distinct
select distinct year from tutorial.aapl_historical_stock_price order by year;
select year, count(distinct month) from tutorial.aapl_historical_stock_price group by year order by year;

-- aliases
select school_name, player_name, position, weight from benn.college_football_players pl where pl.state = 'GA' order by pl.weight desc; 

-- inner join

select pl.player_name as "Player",
    pl.school_name as "School",
    tm.conference as "Conference" 
    from benn.college_football_players pl inner join benn.college_football_teams tm 
    on tm.school_name = pl.school_name where tm.division = 'FBS (Division I-A Teams)';

-- left join

-- before
select count(c.permalink) as "Company Rows",
      count(a.company_permalink) as "Acquisition Rows"
from tutorial.crunchbase_companies c join tutorial.crunchbase_acquisitions a on c.permalink = a.company_permalink;

-- after 
select count(c.permalink) as "Company Rows",
      count(a.company_permalink) as "Acquisition Rows"
from tutorial.crunchbase_companies c left join tutorial.crunchbase_acquisitions a on c.permalink = a.company_permalink;

-- Unique companies and acquisitions (left join problem)
select c.state_code, 
  COUNT(distinct c.permalink) as "Distinct Companies",
  COUNT(distinct a.company_permalink) as "Unique Acquisitions"
from tutorial.crunchbase_companies c left join tutorial.crunchbase_acquisitions a 
on c.permalink = a.company_permalink where c.state_code is not null 
group by c.state_code order by 3 desc; -- 3 is used for ease

-- and right join!
select c.state_code, 
  COUNT(distinct c.permalink) as "Distinct Companies",
  COUNT(distinct a.company_permalink) as "Unique Acquisitions"
from tutorial.crunchbase_companies c right join tutorial.crunchbase_acquisitions a 
on c.permalink = a.company_permalink where c.state_code is not null 
group by c.state_code order by 3 desc; -- 3 is used for ease

-- unique investors, join with where/and clauses
select c.name as "Company",
  c.status as "Status",
  COUNT(distinct i.investor_name) as "Distinct investors"
from tutorial.crunchbase_companies c 
left join tutorial.crunchbase_investments i 
on c.permalink = i.company_permalink 
where c.state_code = 'NY'
group by c.name, c.status order by 3 desc;

-- invested in amount
select case 
    when i.investor_name is null then 'None'
    else i.investor_name 
    end as investors,
    COUNT(distinct c.permalink) as "Amount invested in"
from tutorial.crunchbase_companies c 
left join tutorial.crunchbase_investments i 
on c.permalink = i.company_permalink 
group by 1 order by 2 desc; -- Column number over name feels better to use overall

-- full join
select 
  COUNT(case 
    when c.permalink is not null and i.company_permalink is null 
    then c.permalink else null end) as companies,
  COUNT(case 
  when c.permalink is not null and i.company_permalink is not null 
  then c.permalink else null end) as investments_companies,
  COUNT(case 
  when c.permalink is null and i.company_permalink is not null 
  then i.company_permalink else null end) as investments
from tutorial.crunchbase_companies c full join tutorial.crunchbase_investments_part1 i
on c.permalink = i.company_permalink; 

-- Union
select 
  company_permalink,
  company_name,
  investor_name
from tutorial.crunchbase_investments_part1
where company_name ilike 'T%' union
select
  company_permalink,
  company_name,
  investor_name
from tutorial.crunchbase_investments_part2
where company_name ilike 'N%';

/* 

	Advanced Mode. Subqueries and Window functions. Minimal done so far.
    
*/

-- Arrest warrant
SELECT sub.*
  FROM (
        SELECT *
          FROM tutorial.sf_crime_incidents_2014_01
         WHERE descript = 'WARRANT ARREST' 
       ) sub
 WHERE sub.resolution = 'NONE';


-- Further study on window functions and subquiries required. 
-- partition 
-- row_number()
-- rank() -> If the first three rows are the same rank, it will go 1, 1, 1, 2, 3
-- dense_rank() -> If the first three rows are the hsame rank, it will go 1,1,1,4,5

