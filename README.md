---
editor_options: 
  markdown: 
    wrap: 72
---

[![please replace with alt
text](https://img.shields.io/badge/anytext-youlike-blue)](https://example.org)
[![please replace with alt
text](https://img.shields.io/badge/anytext-youlike-blue)](https://example.org)
[![please replace with alt
text](https://img.shields.io/badge/anytext-youlike-blue)](https://example.org)

# Land Cover Change Analysis for Urban Deltaic Megaregions

## Table of Contents

-   [Introduction](#introduction)
-   [Project Objectives](#project-objectives)
-   [Data Sources](#data-sources)
-   [Methodology](#methodology)
-   [Metadata](#metadata)
-   [Tools and Technologies](#tools-and-technologies)
-   [How to Contribute](#how-to-contribute)

## Introduction {#introduction}

This repository contains R scripts, workflows and research outputs
developed and generated in the Land Cover Change (LCC) analysis of the
Pearl River Delta (PRD) urban megaregion. The results of this analysis
have been published in [Cannatella,
2023](http://www.lalavision.com/en/article/doi/10.12409/j.fjyl.202208170491?viewType=citedby-info).
Please refer to the paper for detailed findings and analysis. The
project utilized openly available datasets from various sources. For
further information, please see the [Data Sources](#data-sources)
section.

## Project Objectives {#project-objectives}

The primary objectives of this project are as follows:

1.  **Conduct Fine-Grained Land Cover Change (LCC) Analysis:** Utilize
    open remote sensing-derived data and spatial analysis techniques to
    conduct a comprehensive analysis of land cover changes in the Pearl
    River Delta (PRD) urban megaregion at a fine-grained temporal
    resolution of 1 year.

2.  **Identify Patterns and Trends:** Identify and analyze LCC patterns
    and trends in land cover change over a specific period, focusing on
    urbanization, agricultural expansion, and natural land cover
    transformations in [Low Elevation Coastal Zones
    (LECZs)](https://en.wikipedia.org/wiki/Low_Elevation_Coastal_Zone).

3.  **Assess Impacts on Environment and Society:** Assess the
    environmental and societal impacts of observed land cover changes,
    including implications for biodiversity, ecosystem services, and
    human well-being.

4.  **Provide Insights for Decision-Making:** Provide actionable
    insights and recommendations based on the analysis results to inform
    land use planning, conservation efforts, and sustainable development
    initiatives in the PRD region.

5.  **Contribute to Scientific Knowledge:** Contribute to the existing
    body of scientific knowledge on land cover dynamics in urban deltaic
    megaregions, particularly in the context of rapid urbanization and
    socio-environmental changes.

These objectives guide the methodology and analysis approach employed in
this project, aiming to contribute to a better understanding of land
cover dynamics and their implications for sustainable development.

## Data Sources {#data-sources}

The analysis of the Pearl River Delta's urbanization dynamics draws upon
a diverse array of data sourceswith global coverage:

-   [**ESA CCI Land Cover Maps (ESA
    CCI-LC)**](https://www.esa-landcover-cci.org/?q=node/164): Provides
    global land cover datasets at 300 m spatial resolution on an annual
    basis, from 1992 to 2015.
-   [**Shuttle Radar Topography Mission (SRTM)
    Images**](https://cmr.earthdata.nasa.gov/search/concepts/C1220566448-USGS_LTA.html)
    provides topographic data over 80% of the Earth's land mass,
    creating the first-ever near-global data set of land elevations.
-   [**GADM maps and data**](https://gadm.org/) provides maps and
    spatial data for all countries and their sub-divisions.

## Methodology {#methodology}

### Data Collection and Preprocessing

Data for the analysis were obtained from diverse sources, including
remote sensing imagery, geospatial datasets, and administrative records.
Elevation data were derived from the Shuttle Radar Topography Mission
(SRTM) dataset, with a spatial resolution of approximately 30 meters.
Raster tiles in .tiff format were downloaded from the SRTM dataset,
merged, and subsequently clipped using the bounding box of the
administrative boundaries vector file specific to the Pearl River Delta
(PRD). This preprocessing step ensured the creation of a seamless and
localized elevation dataset tailored to the study area. Additionally,
administrative boundaries for the PRD were delineated by merging
different shapefiles containing features on administrative boundaries of
Hong Kong, Macao, and Mainland cities forming the PRD. By harmonizing
and integrating these diverse datasets, the analysis facilitated a
comprehensive understanding of the urbanization dynamics within the PRD,
enabling informed decision-making and sustainable development
strategies.

Data were pre-processed and aggregated using QGIS and R packages such as
`terra` and `sf`, which provide advanced functionalities for
manipulating and analysing spatial data. This approach allowed for the
efficient management of large volumes of geospatial data and the
execution of aggregation and analysis operations at a regional level.

-   **Administrative boundaries**: Specific to the PRD were delineated
    by merging different shapefiles containing features on
    administrative boundaries of the Hong Kong and Macao Special
    Administrative Regions (SARs) and mainland cities forming the PRD in
    [QGIS](https://www.qgis.org/it/site/) software. This process
    facilitated the creation of a unified administrative boundary
    dataset tailored to the study area. <!--  -->

-   **Land Cover Change Maps**: Data for the Land Cover Change (LCC)
    analysis were obtained from external sources and clipped to the
    administrative boundaries of the Pearl River Delta (PRD). Raster
    datasets representing land cover maps were downloaded and processed
    using a custom [R
    script](https://github.com/dcannatella/LCCanalysis/blob/main/scripts/LCC_01_raster_v_extract.R)
    available in the project's repository. This script facilitated the
    preprocessing steps, including clipping the land cover maps to the
    PRD boundaries and subsequent reclassification based on the
    classification scheme outlined in Table 1. The resolution of the
    land cover rasters remained unchanged during the preprocessing
    steps, as the original resolution was deemed suitable for
    megaregional-scale analysis.

-   **Elevation**: Elevation data were derived from the Shuttle Radar
    Topography Mission (SRTM) dataset, with a spatial resolution of
    approximately 30 meters. Raster tiles in .tiff format were
    downloaded from the SRTM dataset, merged, and subsequently clipped
    using the bounding box of the administrative boundaries vector file
    specific to the PRD. Elevation data were reclassified into two
    categories: Low Elevation Coastal Zones (LECZs, areas below 10
    meters above sea level), and non-LECZs (areas above 10 meters above
    s.l.). This reclassification facilitated the identification of
    low-lying coastal areas susceptible to coastal inundation and other
    hydrological risks. The preprocessing and reclassification steps
    were implemented using a custom R script available in the project's
    repository:
    [scripts/LCC_02_spatiotemporalmatrix.R](https://github.com/dcannatella/LCCanalysis/blob/main/scripts/LCC_02_spatiotemporalmatrix.R).

\### Step-by-step workflow \#### Creating elevation raster (USGS
SRTM) 1. Creating the bounding box (bbox) from administrative
boundaries - Load the administrative boundary .shp files in
[QGIS](https://www.qgis.org/it/site/) (*Be aware of the CRS!*) - Merge
the administrative boundary features if necessary - Create the bbox of
the administrative boundaries using the `Extract Layer Extent` tool. -
Save the bbox as a .shp file 2. Retrieving Elevation data from SRTM
dataset - Go to [USGS EarthExplorer](https://earthexplorer.usgs.gov/).
(*To be able to download datasets, you have to create a free
account*). - Load the previously created bbox file to
`KML/Shapefile Upload` - Select the specific data range, cloud cover,
result options, etc. if necessary - Follow *Data Sets -\> Digital
Elevation -\> SRTM -\> SRTM Void Filled* to retrieve the SRTM data -
This will yield all tiles within the bbox - Download .tiff files for the
tiles 3. Merging the tiles - After downloading all the .tiff files, load
them back to the QGIS project - Check if there are any significant
NODATA values that might affect the analysis - Merge all the raster
tiles - Additionally, you can clip the raster to the bbox layer. - This
is the final preprocessed raster needed for LCC analysis. Save it as
`elevation.tiff` in the `data_input` folder.

### Reclassifying Land Cover Categories

-   ESA CCI products showcase [38 LC
    categories](https://maps.elie.ucl.ac.be/CCI/viewer/download/ESACCI-LC-QuickUserGuide-LC-Maps_v2-0-7.pdf),
    defined using the UN Land Cover Classification System
    ([UN-CCS](https://www.fao.org/land-water/land/land-governance/land-resources-planning-toolbox/category/details/en/c/1036361/)).
-   The script reclassifies ESA CCI LC categories into 7 categories,
    namely:
    -   urban areas
    -   agriculture/cropland
    -   agriculture/irrigated
    -   shrubland, grassland, sparse vegetation, bare areas
    -   forest
    -   forest/wetland
    -   water

```{=html}
<!-- ## **Metadata
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
- area of the city in km<sup>2</sup>   -->
```
## Metadata {#metadata}

### File Overview

### File List

``` plaintext
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
 │  ├─ LCC_03_maps.R
 │  ├─ LCC_03_stats_1.R
 │  └─ LCC_03_stats_2.R
 └─ README.md
```

### Relationship between files

### File formats and naming conventions

#### File formats

-   **SHP** - geospatial vector data
-   **TIFF -** raster data
-   **CSV** - tabular data

#### Naming conventions

-   files named lowercase, spaces replaced with underscore(snake-case)

### Data-specific Information

-   **missing data code:** NA \*\*\*\*
-   **not applicable:** N/A
-   **specialised formats or other abbreviations used:** N/A

### Data

<details>

<summary><strong>admin_bound.shp</strong></summary>

| 1   | number of variables         | 11                                                                                                  |
|------------------------|------------------------|------------------------|
| 2   | feature count               | 11                                                                                                  |
| 3   | geometry                    | Polygon (MultiPolygon)                                                                              |
| 4   | coordinate reference system | EPSG:32649 - WGS 84 / UTM zone 49N                                                                  |
| 5   | units                       | meters                                                                                              |
| 6   | extent                      | 536311.1228000000119209,2385920.8882999997586012 : 951609.7510999999940395,2699135.0296000000089407 |

**variable list:**

1.  **"OBJECTID"**
    1.  full name: Object Identifier
    2.  description: Unique identifier for each feature in the dataset
    3.  type of variable: Real (20.0)
    4.  unit of measure: NA
    5.  number of missing values: 0
2.  **"ISO"**
    1.  full name: ISO Code
    2.  description: ISO code for the country
    3.  type of variable: String (3.0)
    4.  unit of measure: NA
    5.  number of missing values: 1 <!-- 3. **“NAME”**
         1. full name: 
         2. description:
         3. type of variable: 
         4. unit of measure: 
         5. number of missing values:  -->
3.  **"NAME_0"**
    1.  full name: Country
    2.  description: Name of the country
    3.  type of variable: String (75.0)
    4.  unit of measure: NA
    5.  number of missing values: 2
4.  **"NAME_1"**
    1.  full name: Province
    2.  description: Name of the province
    3.  type of variable: String (75.0)
    4.  unit of measure: NA
    5.  number of missing values: 2
5.  **"NAME_2"**
    1.  full name: City
    2.  description: Name of the city
    3.  type of variable: String (75.0)
    4.  unit of measure: NA
    5.  number of missing values: 0
6.  **"TYPE_2"**
    1.  full name: Type
    2.  description: A prefecture-level city in the administrative
        division hierarchy of China; Dìjíshì(地级市)
    3.  type of variable: String (50.0)
    4.  unit of measure: NA
    5.  number of missing values: 2
7.  **"ENGTYPE_2"**
    1.  full name: Type in English
    2.  description: English term of Dìjíshì(地级市); prefecture level
        city
    3.  type of variable: String (50.0)
    4.  unit of measure: NA
    5.  number of missing values: 2
8.  **"AREA_SQKM"**
    1.  full name: Area in Square Kilometers
    2.  description: area of the city in square kilometers
        (km<sup>2</sup>)
    3.  type of variable: Real (24.15)
    4.  unit of measure: km<sup>2</sup>
    5.  number of missing values: 0
9.  **"SHAPE_LENGTH"**
    1.  full name: Shape Length
    2.  description: total perimeter of the city in meters (m)
    3.  type of variable: Real (24.15)
    4.  unit of measure: meters
    5.  number of missing values: 0
10. **"SHAPE_AREA"**
    1.  full name: Shape Area
    2.  description: area of the city in sqaure meters (m<sup>2</sup>)
    3.  type of variable: Real (24.15)
    4.  unit of measure: m<sup>2</sup>
    5.  number of missing values: 0

</details>

<details>

<summary><strong>PRD_frame.shp</strong></summary>

| 1   | number of variables         | 10                                                                                                  |
|------------------------|------------------------|------------------------|
| 2   | feature count               | 1                                                                                                   |
| 3   | geometry                    | Polygon (MultiPolygon)                                                                              |
| 4   | coordinate reference system | EPSG:32649 - WGS 84 / UTM zone 49N                                                                  |
| 5   | units                       | meters                                                                                              |
| 6   | extent                      | 536311.1228000000119209,2385920.8882999997586012 : 951609.7510999999940395,2699135.0296000000089407 |

**variable list:**

1.  **"MINX"**
    1.  full name: Minimum x coordinate
    2.  description: The minimum x coordinate (longitude) of the
        bounding box
    3.  type of variable: Real (24.15)
    4.  unit of measure: meters
    5.  number of missing values: 0
2.  **"MINY"**
    1.  full name: Minimum y coordinate
    2.  description: The minimum y coordinate (latitude) of the bounding
        box
    3.  type of variable: Real (24.15)
    4.  unit of measure: meters
    5.  number of missing values: 0
3.  **"MAXX"**
    1.  full name: Maximum x coordinate
    2.  description: The maximum x coordinate (longitude) of the
        bounding box
    3.  type of variable: Real (24.15)
    4.  unit of measure: meters
    5.  number of missing values: 0
4.  **"MAXY"**
    1.  full name: Maximum y coordinate
    2.  description: The maximum y coordinate (longitude) of the
        bounding box
    3.  type of variable: Real (24.15)
    4.  unit of measure: meters
    5.  number of missing values: 0
5.  **"CNTX"**
    1.  full name: Center x cooridinate
    2.  description: The x coordinate of the centroid of the bouding box
    3.  type of variable: Real (24.15)
    4.  unit of measure: meters
    5.  number of missing values: 0
6.  **"CNTY"**
    1.  full name: Center y coordinate
    2.  description: The y coordinate of the centroid of the bouding box
    3.  description:
    4.  type of variable: Real (24.15)
    5.  unit of measure: meters
    6.  number of missing values: 0
7.  **"AREA"**
    1.  full name: Area
    2.  description: The area of the bounding box
    3.  type of variable: Real (24.15)
    4.  unit of measure: square meters (m<sup>2</sup>)
    5.  number of missing values: 0
8.  **"PERIM"**
    1.  full name: Perimeter
    2.  description: The perimeter of the bounding box
    3.  type of variable: Real (24.15)
    4.  unit of measure: meters
    5.  number of missing values: 0
9.  **"HEIGHT"**
    1.  full name: Height
    2.  description: The height of the bounding box
    3.  type of variable: Real (24.15)
    4.  unit of measure: meters
    5.  number of missing values: 0
10. **"WIDTH"**
    1.  full name: Width
    2.  description: The width of the bounding box
    3.  type of variable: Real (24.15)
    4.  unit of measure: meters
    5.  number of missing values: 0

</details>

<details>

<summary><strong>elevation_USDG.tif</strong></summary>

| 1   | number of variables         | 1                                                                                   |
|------------------------|------------------------|------------------------|
| 2   | coordinate reference system | EPSG:4326 - WGS 84                                                                  |
| 3   | units                       | geographic (uses latitude and longitude for coordinates)                            |
| 4   | extent                      | 110.9995833330000039,20.9995833330000004 : 116.0004166669999961,25.0004166669999996 |
| 5   | width                       | 6001                                                                                |
| 6   | height                      | 4801                                                                                |
| 7   | data type                   | Float32                                                                             |
| 8   | number of bands             | 1                                                                                   |
| 9   | band 1                      | STATISTICS_APPROXIMATE=YES                                                          |

STATISTICS_MAXIMUM=1762 STATISTICS_MEAN=177.45374104316
STATISTICS_MINIMUM=-33 STATISTICS_STDDEV=234.50668980947
STATISTICS_VALID_PERCENT=100 Scale: 1 Offset: 0 \| \| 10 \| no data \|
N/A \|

</details>

<details>

<summary><strong>ESACCI_legend.csv</strong></summary>

| 1   | number of variables | 5   |
|-----|---------------------|-----|
| 2   | rows count          | 38  |

**variable list:**

1.  **"VALUE"**
    1.  full name: Classification Value
    2.  description: A numerical code representing different land cover
        types or classifications
    3.  type of variable: Integer (32 bit)
    4.  unit of measure: NA
    5.  number of missing values: -
2.  **"VALUE1"**
    1.  full name: Mainclass Value
    2.  description: A numerical code representing main land cover types
        or classifications
    3.  type of variable: Integer (32 bit)
    4.  unit of measure: NA
    5.  number of missing values: -
3.  **"VALUE2"**
    1.  full name: Subclass Value
    2.  description: A detailed numerical code representing
        subcategories within the main land cover types.
    3.  type of variable: Integer (32 bit)
    4.  unit of measure: NA
    5.  number of missing values: -
4.  **"LABEL1"**
    1.  full name: Label
    2.  description: Descriptive names of land cover types or
        classifications corresponding to 'VALUE' and 'VALUE2'.
    3.  type of variable: String
    4.  unit of measure: NA
    5.  number of missing values: -
5.  **"LABEL2"**
    1.  full name: Label
    2.  description: Descriptive names of land cover subtypes or
        classifications corresponding to 'VALUE' and 'VALUE2'.
    3.  type of variable: String
    4.  unit of measure: NA
    5.  number of missing values: -

</details>

<details>

<summary><strong>RCLCC_legend.csv</strong></summary>

| 1   | number of variables | 3   |
|-----|---------------------|-----|
| 2   | rows count          | 7   |

**variable list:**

1.  **"VALUE"**
    1.  full name: Classification Value
    2.  description: A numerical code representing different land cover
        types or classifications
    3.  type of variable: Integer (32 bit)
    4.  unit of measure: NA
    5.  number of missing values: -
2.  **"LABEL"**
    1.  full name: Label
    2.  description: Descriptive names of land cover types or
        classifications corresponding to 'VALUE'.
    3.  type of variable: String
    4.  unit of measure: NA
    5.  number of missing values: -
3.  **"COD"**
    1.  full name: Label
    2.  description: Code of land cover subtypes or classifications
        corresponding to 'VALUE' and 'LABEL'.
    3.  type of variable: String
    4.  unit of measure: NA
    5.  number of missing values: -

</details>

## Tools and Technologies {#tools-and-technologies}

-   **R Programming Language**: Utilized for data manipulation,
    analysis, and visualization.
-   **R Packages**: Leveraging various R packages such as `terra`, `sp`,
    `ggplot2`, and `leaflet` for geospatial analysis and visualization.
-   **Open Datasets**: Incorporating open datasets containing land cover
    information, possibly sourced from organizations like NASA, USGS,
    and ESA.
-   **Version Control**: Employing version control systems like Git to
    manage code and track changes.
-   **Markdown**: Using Markdown for documentation to maintain
    consistency and readability.

## How to contribute {#how-to-contribute}

Contributing to the project is encouraged! You can help by fixing bugs,
adding features, or improving documentation. If you have ideas, share
them by opening an issue. To contribute, fork the repository, make your
changes, and submit a pull request. Your contributions are valuable and
help improve the project for everyone. We welcome your input and look
forward to working together.

For further details and code examples, refer to the project repository
and accompanying documentation.

> > > > > > > fa6b2405cdc43b23187711c21e14d8b63d0a20e5

# Project Directory Tree

``` plaintext
                                                        levelName
1   LCCanalysis                                                   
2    ¦--data                                                      
3    ¦   ¦--admin_bound.cpg                                       
4    ¦   ¦--admin_bound.dbf                                       
5    ¦   ¦--admin_bound.prj                                       
6    ¦   ¦--admin_bound.qix                                       
7    ¦   ¦--admin_bound.qmd                                       
8    ¦   ¦--admin_bound.shp                                       
9    ¦   ¦--admin_bound.shx                                       
10   ¦   ¦--elevation_USDG.tif                                    
11   ¦   ¦--elevation_USDG.tif.aux.xml                            
12   ¦   ¦--ESACCI                                                
13   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-1992-v2.0.7.tif    
14   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-1993-v2.0.7.tif    
15   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-1994-v2.0.7.tif    
16   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-1995-v2.0.7.tif    
17   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-1996-v2.0.7.tif    
18   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-1997-v2.0.7.tif    
19   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-1998-v2.0.7.tif    
20   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-1999-v2.0.7.tif    
21   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2000-v2.0.7.tif    
22   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2001-v2.0.7.tif    
23   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2002-v2.0.7.tif    
24   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2003-v2.0.7.tif    
25   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2004-v2.0.7.tif    
26   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2005-v2.0.7.tif    
27   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2006-v2.0.7.tif    
28   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2007-v2.0.7.tif    
29   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2008-v2.0.7.tif    
30   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2009-v2.0.7.tif    
31   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2010-v2.0.7.tif    
32   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2011-v2.0.7.tif    
33   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2012-v2.0.7.tif    
34   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2013-v2.0.7.tif    
35   ¦   ¦   ¦--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2014-v2.0.7.tif    
36   ¦   ¦   °--ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7.tif    
37   ¦   ¦--ESACCI-2016-2022                                      
38   ¦   ¦   ¦--C3S-LC-L4-LCCS-Map-300m-P1Y-2016-v2.1.1.nc        
39   ¦   ¦   ¦--C3S-LC-L4-LCCS-Map-300m-P1Y-2016-v2.1.1.nc.aux.xml
40   ¦   ¦   ¦--C3S-LC-L4-LCCS-Map-300m-P1Y-2017-v2.1.1.nc        
41   ¦   ¦   ¦--C3S-LC-L4-LCCS-Map-300m-P1Y-2018-v2.1.1.nc        
42   ¦   ¦   ¦--C3S-LC-L4-LCCS-Map-300m-P1Y-2019-v2.1.1.nc        
43   ¦   ¦   ¦--C3S-LC-L4-LCCS-Map-300m-P1Y-2020-v2.1.1.nc        
44   ¦   ¦   ¦--C3S-LC-L4-LCCS-Map-300m-P1Y-2021-v2.1.1.nc        
45   ¦   ¦   °--C3S-LC-L4-LCCS-Map-300m-P1Y-2022-v2.1.1.nc        
46   ¦   ¦--ESACCI_legend.csv                                     
47   ¦   ¦--PRD_frame.cpg                                         
48   ¦   ¦--PRD_frame.dbf                                         
49   ¦   ¦--PRD_frame.prj                                         
50   ¦   ¦--PRD_frame.qmd                                         
51   ¦   ¦--PRD_frame.shp                                         
52   ¦   ¦--PRD_frame.shx                                         
53   ¦   °--RCLCC_legend.csv                                      
54   ¦--data_output                                               
55   ¦   ¦--01_landuse_temporal_WGS04.csv                         
56   ¦   ¦--01_landuse_temporal_WGS84.csv                         
57   ¦   ¦--02_stmatrix.csv                                       
58   ¦   ¦--03_cities_extent.csv                                  
59   ¦   °--ph                                                    
60   ¦--documents                                                 
61   ¦   ¦--images                                                
62   ¦   ¦   °--PRD2000.jpg                                       
63   ¦   ¦--report.html                                           
64   ¦   ¦--Report.rmd                                            
65   ¦   ¦--report2.html                                          
66   ¦   °--report2.Rmd                                           
67   ¦--fig_output                                                
68   ¦   ¦--01_PRDcities_area.jpg                                 
69   ¦   ¦--02_PRD_cities_lecz.jpg                                
70   ¦   ¦--03a_lc_distr_1992.jpg                                 
71   ¦   ¦--03a_lc_distr_2015.jpg                                 
72   ¦   ¦--04_urb_temp.jpg                                       
73   ¦   ¦--05_urb_city_lecz.jpg                                  
74   ¦   ¦--06_LCC_sankey.jpg                                     
75   ¦   ¦--07_trans_m.jpg                                        
76   ¦   ¦--m01a_LCC_1992.jpg                                     
77   ¦   ¦--m01a_LCC_2015.jpg                                     
78   ¦   ¦--m02a_UA_1992.jpg                                      
79   ¦   ¦--m02a_UA_1995.jpg                                      
80   ¦   ¦--m02a_UA_2000.jpg                                      
81   ¦   ¦--m02a_UA_2005.jpg                                      
82   ¦   ¦--m02a_UA_2010.jpg                                      
83   ¦   ¦--m02a_UA_2015.jpg                                      
84   ¦   ¦--OLD                                                   
85   ¦   ¦   ¦--landusePRDcities.pdf                              
86   ¦   ¦   °--landusePRDtot.pdf                                 
87   ¦   °--ph                                                    
88   ¦--images                                                    
89   ¦   °--PRD2000.jpg                                           
90   ¦--LCCanalysis.Rproj                                         
91   ¦--README.md                                                 
92   ¦--renv.lock                                                 
93   ¦--scripts                                                   
94   ¦   ¦--LCC_01_raster_v_extract.R                             
95   ¦   ¦--LCC_02_spatiotemporalmatrix.R                         
96   ¦   ¦--LCC_03_maps.R                                         
97   ¦   ¦--LCC_03_stats_1.R                                      
98   ¦   °--LCC_03_stats_2.R                                      
99   °--src                                                       
100      °--LICENSE                                               
                                                 name
1                                          LCCanalysis
2                                                 data
3                                      admin_bound.cpg
4                                      admin_bound.dbf
5                                      admin_bound.prj
6                                      admin_bound.qix
7                                      admin_bound.qmd
8                                      admin_bound.shp
9                                      admin_bound.shx
10                                  elevation_USDG.tif
11                          elevation_USDG.tif.aux.xml
12                                              ESACCI
13      ESACCI-LC-L4-LCCS-Map-300m-P1Y-1992-v2.0.7.tif
14      ESACCI-LC-L4-LCCS-Map-300m-P1Y-1993-v2.0.7.tif
15      ESACCI-LC-L4-LCCS-Map-300m-P1Y-1994-v2.0.7.tif
16      ESACCI-LC-L4-LCCS-Map-300m-P1Y-1995-v2.0.7.tif
17      ESACCI-LC-L4-LCCS-Map-300m-P1Y-1996-v2.0.7.tif
18      ESACCI-LC-L4-LCCS-Map-300m-P1Y-1997-v2.0.7.tif
19      ESACCI-LC-L4-LCCS-Map-300m-P1Y-1998-v2.0.7.tif
20      ESACCI-LC-L4-LCCS-Map-300m-P1Y-1999-v2.0.7.tif
21      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2000-v2.0.7.tif
22      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2001-v2.0.7.tif
23      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2002-v2.0.7.tif
24      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2003-v2.0.7.tif
25      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2004-v2.0.7.tif
26      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2005-v2.0.7.tif
27      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2006-v2.0.7.tif
28      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2007-v2.0.7.tif
29      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2008-v2.0.7.tif
30      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2009-v2.0.7.tif
31      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2010-v2.0.7.tif
32      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2011-v2.0.7.tif
33      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2012-v2.0.7.tif
34      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2013-v2.0.7.tif
35      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2014-v2.0.7.tif
36      ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7.tif
37                                    ESACCI-2016-2022
38          C3S-LC-L4-LCCS-Map-300m-P1Y-2016-v2.1.1.nc
39  C3S-LC-L4-LCCS-Map-300m-P1Y-2016-v2.1.1.nc.aux.xml
40          C3S-LC-L4-LCCS-Map-300m-P1Y-2017-v2.1.1.nc
41          C3S-LC-L4-LCCS-Map-300m-P1Y-2018-v2.1.1.nc
42          C3S-LC-L4-LCCS-Map-300m-P1Y-2019-v2.1.1.nc
43          C3S-LC-L4-LCCS-Map-300m-P1Y-2020-v2.1.1.nc
44          C3S-LC-L4-LCCS-Map-300m-P1Y-2021-v2.1.1.nc
45          C3S-LC-L4-LCCS-Map-300m-P1Y-2022-v2.1.1.nc
46                                   ESACCI_legend.csv
47                                       PRD_frame.cpg
48                                       PRD_frame.dbf
49                                       PRD_frame.prj
50                                       PRD_frame.qmd
51                                       PRD_frame.shp
52                                       PRD_frame.shx
53                                    RCLCC_legend.csv
54                                         data_output
55                       01_landuse_temporal_WGS04.csv
56                       01_landuse_temporal_WGS84.csv
57                                     02_stmatrix.csv
58                                03_cities_extent.csv
59                                                  ph
60                                           documents
61                                              images
62                                         PRD2000.jpg
63                                         report.html
64                                          Report.rmd
65                                        report2.html
66                                         report2.Rmd
67                                          fig_output
68                               01_PRDcities_area.jpg
69                              02_PRD_cities_lecz.jpg
70                               03a_lc_distr_1992.jpg
71                               03a_lc_distr_2015.jpg
72                                     04_urb_temp.jpg
73                                05_urb_city_lecz.jpg
74                                   06_LCC_sankey.jpg
75                                      07_trans_m.jpg
76                                   m01a_LCC_1992.jpg
77                                   m01a_LCC_2015.jpg
78                                    m02a_UA_1992.jpg
79                                    m02a_UA_1995.jpg
80                                    m02a_UA_2000.jpg
81                                    m02a_UA_2005.jpg
82                                    m02a_UA_2010.jpg
83                                    m02a_UA_2015.jpg
84                                                 OLD
85                                landusePRDcities.pdf
86                                   landusePRDtot.pdf
87                                                  ph
88                                              images
89                                         PRD2000.jpg
90                                   LCCanalysis.Rproj
91                                           README.md
92                                           renv.lock
93                                             scripts
94                           LCC_01_raster_v_extract.R
95                       LCC_02_spatiotemporalmatrix.R
96                                       LCC_03_maps.R
97                                    LCC_03_stats_1.R
98                                    LCC_03_stats_2.R
99                                                 src
100                                            LICENSE
```
