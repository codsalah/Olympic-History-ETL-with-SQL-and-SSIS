# SSIS Task: Migrate Olympic_Athlete_Event_Results

## Problem Statement
Create a data flow pipeline to migrate the `Olympic_Athlete_Event_Results` data to a new SQL Server schema with transformations.

### Requirements
- Use the `Olympic_Athlete_Event_Results` table.
- Ensure all records have valid medal information (no null values in the medal column).
- Change medal type values: 
  - "Gold" to 1 
  - "Silver" to 2 
  - "Bronze" to 3.
- Output the migrated data to a new SQL Server schema.

## Tools Used

### OLE DB Source
- **Function**: Extract data from the `Olympic_Athlete_Event_Results` table.

### Conditional Split
- **Function**: Filter out records with null values in the medal column.

### Derived Column Transformation
- **Function**: Convert medal type values to their integer representations.

### OLE DB Destination
- **Function**: Load the transformed data into the new SQL Server schema.
![alt text](../../imgs/Task2-flow.png)