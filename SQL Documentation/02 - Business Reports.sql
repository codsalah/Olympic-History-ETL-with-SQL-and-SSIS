/*
-1-
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



---------------------------------------------------------------------------------------------

/**
Description: Create a report with the countries that have won medals 
in every edition they participated in. For each country, list the number of editions they participated in,
the total number of medals won, and their average medal count per edition. 
Classify the consistency of performance as 'Highly Consistent', 'Moderately Consistent',
 or 'Inconsistent' based on the ratio of total medals to editions. Use a dynamic 
SQL query to display results for either Summer or Winter Olympics based on the input
**/

-- declare a variable to specify the type of Olympic Games (Summer or Winter)
declare @olympicseason nvarchar(10) = 'Summer'; 
declare @dynamicSQL nvarchar(max);

set @dynamicSQL = N'
with cleaned_data as (
    select
        OAER.athlete,
        OAER.country_noc,
        OAER.edition,
        OAER.medal,
        case 
            when OAER.edition like ''%Summer%'' then ''Summer''
            when OAER.edition like ''%Winter%'' then ''Winter''
            else ''Unknown''
        end as olympic_type,
        try_cast(substring(OAER.edition, 1, 4) as int) as olympic_year
    from Olympic_Athlete_Event_Results OAER
),

country_medal_summary as (
    select 
        OC.country,
        DC.country_noc,
        count(distinct DC.edition) as editions_participated,
        count(distinct case when DC.medal in (''Gold'', ''Silver'', ''Bronze'') then DC.edition else null end) as editions_with_medals,
        count(DC.medal) as total_medals,
        cast(count(DC.medal) as float) / nullif(count(distinct DC.edition), 0) as avg_medals_per_edition
    from cleaned_data DC
    join Olympics_Country OC on DC.country_noc = OC.noc
    where DC.olympic_type = @olympicseason
    group by OC.country, DC.country_noc
    having count(distinct DC.edition) = count(distinct case when DC.medal in (''Gold'', ''Silver'', ''Bronze'') then DC.edition else null end)
),

classified_countries as (
    select 
        country,
        editions_participated,
        total_medals,
        avg_medals_per_edition,
        case 
            when avg_medals_per_edition >= 5 then ''highly consistent''
            when avg_medals_per_edition between 2 and 4.99 then ''moderately consistent''
            else ''inconsistent''
        end as performance_classification
    from country_medal_summary
)

select 
    country,
    editions_participated,
    total_medals,
    avg_medals_per_edition,
    performance_classification
from classified_countries
order by total_medals desc, avg_medals_per_edition desc;
';

exec sp_executesql @dynamicSQL, N'@olympicseason nvarchar(10)', @olympicseason;


/**
Evaluate Athlete's Peak Performance Ages and Their Influence on Medal Wins
Description: Create a report that finds each athlete's age at the time of their medal wins and determines
 the age range during which athletes are most likely to win medals.
  Categorize the athletes into different age brackets (under 20, 20-24, 25-29, 30-34, 35+)
   and count the total medals won in each bracket. Also,
    identify the top sport for each age bracket where athletes have won the most medals.
**/

with athlete_age_medals as (
    select a.athlete_id, a.sport, g.year, a.medal, ath.born, 
           (g.year - year(ath.born)) as age_at_medal
    from olympic_athlete_event_results a
    join olympic_athlete_bio ath on a.athlete_id = ath.athlete_id
    join olympics_games g on g.edition = a.edition
    where a.medal is not null
),
age_brackets as (
    select athlete_id, sport, medal, age_at_medal,
           case 
               when age_at_medal < 20 then 'under 20'
               when age_at_medal between 20 and 24 then '20-24'
               when age_at_medal between 25 and 29 then '25-29'
               when age_at_medal between 30 and 34 then '30-34'
               else '35+' 
           end as age_bracket
    from athlete_age_medals
),
medal_counts_by_age_bracket as (
    select age_bracket, count(medal) as total_medals
    from age_brackets
    group by age_bracket
),
top_sport_by_age_bracket as (
    select age_bracket, sport, count(medal) as total_medals_in_sport,
           row_number() over (partition by age_bracket order by count(medal) desc) as rank
    from age_brackets
    group by age_bracket, sport
)
select mc.age_bracket, mc.total_medals, ts.sport as top_sport, ts.total_medals_in_sport
from medal_counts_by_age_bracket mc
join top_sport_by_age_bracket ts on mc.age_bracket = ts.age_bracket
where ts.rank = 1
order by mc.age_bracket;
