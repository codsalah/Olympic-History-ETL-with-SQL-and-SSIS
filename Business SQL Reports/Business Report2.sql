-- 2

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