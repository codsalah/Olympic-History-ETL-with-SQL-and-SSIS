# SSIS Task: Generate Medal Summary Report by Country

## Problem Statement
Create a data flow pipeline to generate a report summarizing the total number of medals won by each country in a specified year and save it as a flat file.

### Requirements
- Use the `Olympic_Games_Medal_Tally` table.
- Filter data by the year provided by the user running the pipeline.
- Calculate the total number of medals won by each country for that year.
- Output the results as a CSV file.

## Tools Used

### OLE DB Source
- **Function**: Extract data from the `Olympic_Games_Medal_Tally` table.

### Conditional Split
- **Function**: Filter records based on the specified year.

### Aggregate Transformation
- **Function**: Calculate the total number of medals won by each country for the specified year.

### Flat File Destination
- **Function**: Save the summarized report as a CSV file.
![alt text](../../imgs/Task4-flow.png)