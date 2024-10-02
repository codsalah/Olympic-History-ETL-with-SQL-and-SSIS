# SSIS Task: Export Top 10 Athletes by Medals

## Problem Statement
Create a data flow pipeline to export the top 10 athletes by the number of medals won from each sport into a CSV file.

### Requirements
- Use the `Olympic_Athlete_Event_Results` table.
- Include only athletes who have won medals.
- Rank athletes by the number of medals won.
- Output a CSV report containing the top 10 athletes for each sport.

## Tools Used

### OLE DB Source
- **Function**: Extract data from the `Olympic_Athlete_Event_Results` table.

### Script Component
- **Function**: Rank athletes based on the number of medals won.

### Conditional Split
- **Function**: Filter out athletes who have not won any medals.

### Flat File Destination
- **Function**: Save the report as a CSV file containing the top 10 athletes for each sport.
![alt text](../../imgs/Task3-flow.png)