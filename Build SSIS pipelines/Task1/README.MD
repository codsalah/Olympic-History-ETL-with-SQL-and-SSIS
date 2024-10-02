# SSIS Task1: Medal Summary Report

## Problem Statement
Create a data flow pipeline to generate a medal summary report for each country by edition and output it as a CSV file.

### Requirements
- Use the `Olympic_Games_Medal_Tally` table.
- Calculate total gold, silver, and bronze medals for each country and edition.
- Add a column to classify countries as "High Performance" (more than 50 medals) or "Low Performance."
- Output a CSV report with the medal summary.

## Tools Used

### OLE DB Source
- **Function**: Extract data from the `Olympic_Games_Medal_Tally` table.

### Aggregate Transformation
- **Function**: Group data by country and edition to sum the medals.

### Derived Column Transformation
- **Function**: Create a new column to classify country performance based on total medals.

### Flat File Destination
- **Function**: Save the report in CSV format.

![alt text](../../imgs/Task1-flow.png)