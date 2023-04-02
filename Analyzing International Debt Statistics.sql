use wb_data;
create table IDS_AllCountries_Data(
	Country_Name varchar(100),
    Country_code varchar(3),
    Indicator_name varchar(300),
    Indicator_code varchar(30),
    debt decimal(40,2)
);

load data infile 'C:/Users/Manav Jaisinghani/OneDrive/Desktop/Ongoing Projects/Debt Analysis/IDS_CSV/IDS_AllCountries_Data.csv'
     into table IDS_AllCountries_Data
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
     ignore 1 rows;
     
     
-- 1. The World Bank's international debt data

select *
from ids_allcountries_data
limit 10;

-- 2. Finding the number of distinct countries

select count(distinct Country_Name) as total_distinct_countries
from ids_allcountries_data;

-- 3. Finding out the distinct debt indicators

select distinct Indicator_name as distinct_debt_indicators
from ids_allcountries_data;

-- 4. Totaling the amount of debt owed by the countries

select format(SUM(debt), 2) as total_debt
from ids_allcountries_data;

-- 5. Country with the highest debt

select Country_Name, SUM(debt) as total_debt
from ids_allcountries_data
group by Country_Name 
order by total_debt desc
limit 1;


-- 6. Average amount of debt across indicators

select Indicator_code as debt_indicator, Indicator_name, avg(debt) as average_debt
from ids_allcountries_data
group by debt_indicator, Indicator_name
order by average_debt desc;


-- 7. The highest amount of principal repayments


select Country_Name, Indicator_name, Indicator_code, sum(debt) as total_debt
from ids_allcountries_data
group by Country_Name, Indicator_code
having Indicator_code = 'DT.AMT.DLXF.CD'
order by total_debt desc;


-- 8. The most common debt indicator


select Indicator_Name, Indicator_code, count(Indicator_code) as count
from ids_allcountries_data
group by Indicator_Name,Indicator_code
order by count desc;

-- 9. Other viable debt issues and conclusion:
-- Countries with highest and lowest amount od debt.

with cte1 as (select Country_name , sum(debt) as total_debt
				from ids_allcountries_data
				group by country_name)
select country_name, total_debt
from cte1
where total_debt in (
		(select max(total_debt) from cte1),
        (select min(total_debt) from cte1));

