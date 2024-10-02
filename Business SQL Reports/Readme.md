### SQL Script 1: Medal Report for Athletes

**Description:**
This script generates a report that details the total number of medals won by athletes who have participated in at least two editions of the Olympics.

 It displays the athlete's name, country, total medals, average position, and a classification based on the total number of medals won, categorized as 'Exceptional', 'Outstanding', or 'Remarkable.'
 
It ensures that only athletes with at least two participations are included and handles cases where some athletes might have missing data.

**Key Features:**
- Counts the total medals for each athlete.
- Calculates the average position, converting position data into a float.
- Classifies athletes based on their total medals.
- Orders results by the total number of medals in descending order.

---

### SQL Script 2: Consistency of Medal Performance by Country

**Description:**
This script produces a report on countries that have won medals in every edition they participated in. For each country, it lists the number of editions participated, total medals won, and average medal count per edition.

It classifies countries' performance consistency as 'Highly Consistent', 'Moderately Consistent', or 'Inconsistent' based on the ratio of total medals to editions.

The script utilizes dynamic SQL to allow filtering by either Summer or Winter Olympics.

**Key Features:**
- Uses Common Table Expressions (CTEs) to organize data.
- Filters and groups data by the Olympic season (Summer or Winter).
- Classifies country performance based on average medals per edition.
- Uses dynamic SQL for flexible querying based on user input.

---

### SQL Script 3: Athlete's Peak Performance Ages

**Description:**
This script evaluates each athlete's age at the time of their medal wins and identifies the age ranges in which athletes are most likely to win medals.

Athletes are categorized into age brackets (under 20, 20-24, 25-29, 30-34, 35+) to count total medals won in each bracket.

The script also identifies the top sport for each age bracket based on the number of medals won.

**Key Features:**
- Calculates the age of athletes at the time of medal wins.
- Categorizes athletes into defined age brackets.
- Counts the total medals won in each age bracket.
- Identifies the sport with the highest medal count for each age bracket.
