[![please replace with alt text](https://img.shields.io/badge/anytext-youlike-blue)](https://example.org) [![please replace with alt text](https://img.shields.io/badge/anytext-youlike-blue)](https://example.org) [![please replace with alt text](https://img.shields.io/badge/anytext-youlike-blue)](https://example.org)

# Land Cover Change Analysis for Urban Deltaic Megaregions

## Introduction

This repository contains R scripts, workflows and research outputs developed and generated in the Land Cover Change (LCC) analysis of the Pearl River Delta (PRD) urban megaregion. The results of this analysis have been published in [Cannatella, 2023](10.12409/j.fjyl.202208170491). Please refer to the paper for detailed findings and analysis. The project utilized openly available datasets from various sources. For further information, please see the Data Sources section.

```plaintext
# File Structure
 ├─ data
 ├─ data_output
 │  ├─ 01_landuse_temporal_WGS04.csv
 │  ├─ 02_stmatrix.csv
 │  └─ 03_cities_extent.csv
 ├─ documents
 ├─ fig_output
 ├─ scripts
 │  ├─ LCC_01_raster_v_extract.R
 │  ├─ LCC_02_spatiotemporalmatrix.R
 │  └─ LCC_03_stats_1.R
 └─ README.md
```

## Project Objectives

The primary objectives of this project are as follows:

1. **Conduct Fine-Grained Land Cover Change (LCC) Analysis:** Utilize open remote sensing-derived data and spatial analysis techniques to conduct a comprehensive analysis of land cover changes in the Pearl River Delta (PRD) urban megaregion at a fine-grained temporal resolution of 1 year.

2. **Identify Patterns and Trends:** Identify and analyze LCC patterns and trends in land cover change over a specific time span, focusing on urbanization, agricultural expansion, and natural land cover transformations in [Low Elevation Coastal Zones (LECz)](https://en.wikipedia.org/wiki/Low_Elevation_Coastal_Zone).

3. **Assess Impacts on Environment and Society:** Assess the environmental and societal impacts of observed land cover changes, including implications for biodiversity, ecosystem services, and human well-being.

4. **Provide Insights for Decision-Making:** Provide actionable insights and recommendations based on the analysis results to inform land use planning, conservation efforts, and sustainable development initiatives in the PRD region.

5. **Contribute to Scientific Knowledge:** Contribute to the existing body of scientific knowledge on land cover dynamics in urban deltaic megaregions, particularly in the context of rapid urbanization and socio-environmental changes.

These objectives guide the methodology and analysis approach employed in this project, aiming to contribute to a better understanding of land cover dynamics and their implications for sustainable development.


## Data Sources

The analysis of the Pearl River Delta's urbanization dynamics draws upon a diverse array of data sourceswith global coverage:

1. **[ESA CCI Land Cover Maps (ESA CCI-LC)](https://www.esa-landcover-cci.org/?q=node/164)**: Provides global land cover datasets at 300 m spatial resolution on an annual basis, from 1992 to 2015. 
<!-- 2. **[Shuttle Radar Topography Mission (SRTM) Images](https://cmr.earthdata.nasa.gov/search/concepts/C1220566448-USGS_LTA.html)** provides topographic data over 80% of the Earth's land mass, creating the first-ever near-global data set of land elevations. -->
5. **[GADM maps and data](https://gadm.org/)** provides maps and spatial data for all countries and their sub-divisions.

## Methodology

### Data Collection and Preprocessing


Data for the analysis were obtained from diverse sources, including remote sensing imagery, geospatial datasets, and administrative records. Elevation data were derived from the Shuttle Radar Topography Mission (SRTM) dataset, with a spatial resolution of approximately 30 meters. Raster tiles in .tiff format were downloaded from the SRTM dataset, merged, and subsequently clipped using the bounding box of the administrative boundaries vector file specific to the Pearl River Delta (PRD). This preprocessing step ensured the creation of a seamless and localized elevation dataset tailored to the study area. Additionally, administrative boundaries for the PRD were delineated by merging different shapefiles containing features on administrative boundaries of Hong Kong, Macao, and Mainland cities forming the PRD. By harmonizing and integrating these diverse datasets, the analysis facilitated a comprehensive understanding of the urbanization dynamics within the PRD, enabling informed decision-making and sustainable development strategies.
The data were processed and aggregated using QGIS and R packages such as `terra` and `sf`, which provide advanced functionalities for the manipulation and analysis of spatial data. This approach allowed for the efficient management of large volumes of geospatial data and the execution of aggregation and analysis operations at a regional level.

- **Administrative boundaries**: Specific to the PRD were delineated by merging different shapefiles containing features on administrative boundaries of the Hong Kong and Macao Special Administrative Regions (SARs) and mainland cities forming the PRD in [QGIS](https://www.qgis.org/it/site/). This process facilitated the creation of a unified administrative boundary dataset tailored to the study area.
<!--  -->
- **Land Cover Change Maps**: Data for the Land Cover Change (LCC) analysis were obtained from external sources and clipped to the administrative boundaries of the Pearl River Delta (PRD). Raster datasets representing land cover maps were downloaded and processed using a custom [R script](https://github.com/dcannatella/LCCanalysis/blob/newreadme/scripts/LCC_01_raster_v_extract.R) available in the project's repository (e.g., preprocessing_script.R). This script facilitated the preprocessing steps, including clipping the land cover maps to the PRD boundaries and subsequent reclassification based on the classification scheme outlined in Table 1. The resolution of the land cover rasters remained unchanged during the preprocessing steps, as the original resolution was deemed suitable for regional-scale analysis.

- **Elevation**: Elevation data were derived from the Shuttle Radar Topography Mission (SRTM) dataset, with a spatial resolution of approximately 30 meters. Raster tiles in .tiff format were downloaded from the SRTM dataset, merged, and subsequently clipped using the bounding box of the administrative boundaries vector file specific to the PRD. Elevation data were reclassified into two categories: areas above and below 10 meters above sea level. This reclassification facilitated the identification of low-lying coastal areas susceptible to inundation and other hydrological risks. The preprocessing and reclassification steps were implemented using a custom R script available in the project's repository: [`scripts/LCC_02_spatitemporalmatrix.R`](https://github.com/dcannatella/LCCanalysis/blob/newreadme/scripts/LCC_02_spatiotemporalmatrix.R).

 ### **Step-by-step workflow (USGS SRTM)
 1. Creating the bounding box (bbox) from administrative boundaries
    - Load the administrative boundary .shp files in [QGIS](https://www.qgis.org/it/site/) (*Be aware of the CRS!*)
    - Merge the adminstrative bounday features if necessary
    - Create the bbox of the administrative boundaries
    - Save the bbox as a .shp file
2. Retrieve Elevation data from SRTM dataset
    - Go to [USGS EarthExplorer](https://earthexplorer.usgs.gov/)
    - Load the previously created bbox file to *KML/Shapefile Upload*
    - Select the specific data range, cloud cover, result options, etc. if necessary
    - Follow *Data Sets -> Digital Elevation -> SRTM -> SRTM Void Filled* to retrieve the SRTM data
    - This will yield all tiles within the bbox
    - Download .tiff files for the tiles
3. Merging the tiles
    - After downloading all the .tiff files, load them back to the QGIS project
    - Check if there are any significant NODATA values that might affect the analysis
    - Merge all the raster tiles together
    - This is the final preprocessed raster needed for LCC analysis



### **Land Cover Change Analysis**
Utilize statistical and geospatial techniques to analyze changes in land cover over time.
### **Visualization**
Create visualizations to represent the findings effectively.
### **Results**
Interpret the results to gain insights into the drivers and implications of land cover change within megaregions.
### **Documentation**
Document the entire process, including data sources, methodologies, and findings, to facilitate reproducibility and transparency.

## **Metadata
### 01. landuse_temporal_WGS04

"x"
- longitude coordinate in WGS84

"y"
- latitude coordinate in WGS84

"y*nnnn*"
- the year of land cover dataset 

"classification" (the corresponding values in y*nnnn* column)
- **0**: (0-8) Possibly unclassified or undefined
- **1**: (189-198) Urban areas
- **2**: (9-18, 29-48) Agriculture/cropland
- **3**: (19-28) Agriculture/irrigated
- **4**: (119-128, 129-138, 139-158, 179-188, 199-208) Shrubland, grassland, sparse vegetation, bare areas
- **5**: (49-108, 109-118) Forests
- **6**: (159-178) Forest/wetland
- **7**: (209-218) Water bodies
- **8**: (219-228) Permanent snow and ice


### 02. stmatrix

"ID"
- a unique identifier for each data point

"city"
- the name of the city

"AB"
- elevation classification. "above" indicates elevation is above 10m, "below" indicates elevation is below 10m.

"y*nnnn*"
- the year of land cover dataset

"classification" (the corresponding values in y*nnnn* column)
- **0**: (0-8) Possibly unclassified or undefined
- **1**: (189-198) Urban areas
- **2**: (9-18, 29-48) Agriculture/cropland
- **3**: (19-28) Agriculture/irrigated
- **4**: (119-128, 129-138, 139-158, 179-188, 199-208) Shrubland, grassland, sparse vegetation, bare areas
- **5**: (49-108, 109-118) Forests
- **6**: (159-178) Forest/wetland
- **7**: (209-218) Water bodies
- **8**: (219-228) Permanent snow and ice

### 03. cities_extent
"city"
- the name of the city  

"area_km2"
- area of the city in km<sup>2</sup>  

## Tools and Technologies

- **R Programming Language**: Utilized for data manipulation, analysis, and visualization.
- **R Packages**: Leveraging various R packages such as `terra`, `sp`, `ggplot2`, and `leaflet` for geospatial analysis and visualization.
- **Open Datasets**: Incorporating open datasets containing land cover information, possibly sourced from organizations like NASA, USGS, and ESA.
- **Version Control**: Employing version control systems like Git to manage code and track changes.
- **Markdown**: Using Markdown for documentation to maintain consistency and readability.

## How to contribute
Contributing to the project is encouraged! You can help by fixing bugs, adding features, or improving documentation. If you have ideas, share them by opening an issue. To contribute, fork the repository, make your changes, and submit a pull request. Your contributions are valuable and help improve the project for everyone. We welcome your input and look forward to working together.


For further details and code examples, refer to the project repository and accompanying documentation.

