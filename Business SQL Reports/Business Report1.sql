-- 1

/*
Description: Create a report that shows the total number of medals won by athletes 
who have participated in at least two editions of the Olympics. For each athlete, display their name, country,
the total medals won, the average position,
and a classification based on the total number of medals as 'Exceptional', 'Outstanding', or 'Remarkable'. Include athletes'
participation and performance details. The total medals should order the results won, and handle cases where some athletes might miss data.
*/

select OAER.athlete, OC.country, 
       count(OAER.medal) as totalMedals, 
       -- Calculate the average position, converting the position substring to a float
       avg(try_cast(substring(OAER.pos, 1, charindex(' ', OAER.pos + ' ') - 1) as float)) as Avrg,
       -- Classify the athlete based on the total number of medals won
       case
           when count(OAER.medal) >= 10 then 'Exceptional'
           when count(OAER.medal) between 5 and 9 then 'Outstanding'
           else 'Remarkable'
       end as classification
from Olympic_Athlete_Event_Results OAER
join Olympics_Country OC on OC.noc = OAER.country_noc
where OAER.medal is not null -- Filter to exclude athletes who have not won any medals
group by OAER.athlete, OC.country
having count(distinct OAER.edition) > 1 -- Ensure only athletes who participated in at least two editions
order by totalMedals desc; -- order results by total medals in descending order


-- declare a variable to specify the type of Olympic Games (Summer or Winter)
declare @olympictype nvarchar(10) = 'Summer'; 
declare @sql nvarchar(max);
