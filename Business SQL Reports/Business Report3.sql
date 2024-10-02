-- 3

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