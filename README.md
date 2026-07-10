# Automobile_Analysis

## Project Overview
This project cleans and analyzes an automobile dataset, standardizing column names and categorical values, then exploring how vehicle specifications (engine, fuel type, drive wheels, body style) relate to pricing, fuel efficiency, and performance. The goal is to surface pricing and efficiency patterns across different vehicle configurations.

## Dataset Description
**automobile_data** — a vehicle specifications dataset including:
- Identity/classification: make, body style, fuel type, aspiration, engine location, drive wheels
- Physical specs: wheelbase, curb weight, engine size, number of cylinders/doors, fuel system, compression ratio
- Performance: horsepower, peak RPM, city/highway MPG
- Outcome: price

## Cleaning & Transformation Steps

**1. Column Renaming**
Standardized hyphenated column names (e.g. `normalized-losses`, `fuel-type`, `num-of-doors`, `wheel-base`) into clean, SQL-friendly snake_case names (e.g. `normalized_losses`, `fuel_type`, `num_of_doors`, `wheel_base`) and set appropriate data types.

**2. Feature Engineering**
- Converted abbreviated drive wheel codes (`rwd`, `fwd`) into readable labels ("rear wheel drive", "front wheel drive"), with all other values mapped to "4 wheel drive"
- Converted the text-based `num_of_doors` field ("two") into a numeric value (2), defaulting all other values to 4

**3. Column Cleanup**
Dropped columns not used in the analysis: `symboling`, `normalized_losses`, `bore`, `stroke`

## Key Findings
- **Fuel type distribution** was quantified across the dataset (gas vs. diesel counts).
- **Curb weight varies by body style**, giving a sense of which body styles tend to be heavier/lighter.
- **Aspiration type frequency** was ranked to identify the most common aspiration method among the cars.
- **Engine size shows a relationship with horsepower**, examined via average horsepower grouped by engine size.
- **Price varies notably by fuel system**, with average price and count calculated per fuel system type.
- **Fuel efficiency leaders identified**: top 5 cars by city MPG and highway MPG, and separately, top 5 by combined MPG (city + highway).
- **Engine location relates to horsepower**: average horsepower was compared between engine location types (e.g. front vs. rear).
- **Price range varies by drive wheel type**: min, max, and average price were calculated per drive wheel type.
- **Most expensive car identified per body style** using window functions to rank cars by price within each body style group.
- **Rear-engine cars show a specific pricing pattern**: identified which body style has the highest average price specifically among rear-engine-placement cars.
- **Fuel type price gap analyzed by drive wheel type**: average price was compared between gas and diesel cars within each drive wheel category, to spot which drivetrain shows the biggest price gap by fuel type.

## Recommendation / Tool
This cleaned and feature-engineered dataset, combined with the EDA queries, provides a ready analytical base for:
- Pricing strategy analysis (e.g. which specs/configurations command a price premium)
- Fuel efficiency benchmarking across makes and configurations
- Feeding directly into a BI dashboard (Power BI/Tableau) for interactive exploration of price, performance, and efficiency by vehicle attribute

## Tools & Technology
- MySQL
- Window functions (`ROW_NUMBER()`) for per-group ranking
- CASE statements for categorical standardization

## Notes
- The `num_of_doors` column was converted from text to numeric (2 or 4) but its declared type wasn't explicitly changed to an integer type in the renaming section — worth confirming the column type supports numeric values before running aggregate/numeric operations on it.
- The "most expensive car per body style" query uses `LIMIT 5` after filtering to `row_nu = 1`, which will only return up to 5 body styles' top cars — if there are more than 5 body styles in the dataset, some will be excluded from the result.
