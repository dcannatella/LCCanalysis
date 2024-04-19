[![please replace with alt text](https://img.shields.io/badge/anytext-youlike-blue)](https://example.org) [![please replace with alt text](https://img.shields.io/badge/anytext-youlike-blue)](https://example.org) [![please replace with alt text](https://img.shields.io/badge/anytext-youlike-blue)](https://example.org)

# Land Cover Change Analysis for Urban Deltaic Megaregions

## Introduction

This repository contains R scripts, workflows and research outputs developed and generated in the Land Cover Change (LCC) analysis of the Pearl River Delta (PRD) urban megaregion. The results of this analysis have been published in [Cannatella, 2023](10.12409/j.fjyl.202208170491). Please refer to the paper for detailed findings and analysis.

. The project aims to analyze and understand the dynamics of land cover change over time, particularly within urban deltaic megaregions, which are large interconnected networks of cities and metropolitan areas in highly vulnerable environments.

## Project Objectives

1. **Data Collection**: Gather relevant open datasets containing land cover information within megaregions.
2. **Data Preprocessing**: Clean and preprocess the collected datasets to make them suitable for analysis.
3. **Land Cover Change Analysis**: Utilize statistical and geospatial techniques to analyze changes in land cover over time.
4. **Visualization**: Create visualizations to represent the findings effectively.
5. **Interpretation**: Interpret the results to gain insights into the drivers and implications of land cover change within megaregions.
6. **Documentation**: Document the entire process, including data sources, methodologies, and findings, to facilitate reproducibility and transparency.

## Tools and Technologies

- **R Programming Language**: Utilized for data manipulation, analysis, and visualization.
- **R Packages**: Leveraging various R packages such as `terra`, `sp`, `ggplot2`, and `leaflet` for geospatial analysis and visualization.
- **Open Datasets**: Incorporating open datasets containing land cover information, possibly sourced from organizations like NASA, USGS, and ESA.
- **Version Control**: Employing version control systems like Git to manage code and track changes.
- **Markdown**: Using Markdown for documentation to maintain consistency and readability.

## Data Sources

1. **[ESA CCI Land Cover Maps (ESA CCI-LC)](https://www.esa-landcover-cci.org/?q=node/164)**: Provides global land cover datasets at 300 m spatial resolution on an annual basis, from 1992 to 2015.
2. **[Shuttle Radar Topography Mission (SRTM) Images](https://cmr.earthdata.nasa.gov/search/concepts/C1220566448-USGS_LTA.html)** provides topographic data over 80% of the Earth's land mass, creating the first-ever near-global data set of land elevations.
5. **[GADM maps and data](https://gadm.org/)** provides maps and spatial data for all countries and their sub-divisions.

## Methodology

1. **Data Acquisition**: Download and preprocess relevant datasets from the identified sources.
2. **Data Preparation**: Clean and prepare the datasets for analysis, including handling missing values and ensuring consistency.
3. **Land Cover Classification**: Perform land cover classification using remote sensing techniques to categorize land cover types.
4. **Change Detection**: Utilize change detection algorithms to identify and quantify changes in land cover over time.
5. **Statistical Analysis**: Apply statistical methods to analyze the trends and patterns of land cover change within megaregions.
6. **Geospatial Visualization**: Create maps and visualizations using R packages to illustrate land cover change dynamics.
7. **Interpretation and Reporting**: Interpret the analysis results and document findings, including insights into the drivers and implications of land cover change.

## Example Workflow

1. **Data Collection**: Download NLCD datasets for the selected megaregions.
2. **Data Preprocessing**: Clean and preprocess the NLCD datasets to remove inconsistencies.
3. **Land Cover Classification**: Perform supervised or unsupervised classification to categorize land cover types.
4. **Change Detection**: Employ change detection algorithms to identify changes between different time periods.
5. **Visualization**: Generate maps and graphs to visualize the detected land cover changes.
6. **Interpretation**: Analyze the visualizations to understand the dynamics and drivers of land cover change.
7. **Documentation**: Document the entire workflow, including code snippets and analysis findings.

## Conclusion

Land cover change analysis within megaregions is essential for understanding urbanization, environmental impacts, and sustainable development. By leveraging open datasets and tools like R, meaningful insights can be gained to inform decision-making processes and land management strategies.

For further details and code examples, refer to the project repository and accompanying documentation.

---
**Note**: This Markdown documentation provides an overview of the project. Detailed documentation, code, and analysis results can be found in the project repository.
