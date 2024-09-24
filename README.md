# Renewable Horizons: A Spatial and Temporal Analysis of Australia's Energy Transition and Its Environmental Impact

## Overview
**Renewable Horizons** is an interactive dashboard project designed to analyze the spatial and temporal trends of Australia's shift towards renewable energy. It explores how this energy transition impacts emissions, air quality, and energy generation across different states and territories in Australia.

The dashboard provides a clear visualization of historical data, along with future projections, to help stakeholders understand the trends in energy generation and environmental impact.

## Features
- **Interactive Visualization**: A dashboard offering dynamic visual representations such as Choropleth maps, stacked bar charts, and Sankey diagrams.
- **Spatial and Temporal Analysis**: Allows users to analyze energy transitions across different Australian regions over time.
- **Impact Analysis**: Visualizes the effect of renewable energy on emissions and air quality.

## Key Questions Addressed
- What are the trends in renewable energy adoption across Australia?
- How has renewable energy impacted emissions and air quality?
- How do these trends vary geographically and over time?

## Motivation
With climate change being a pressing issue, this project seeks to provide insights into how Australia is transitioning towards renewable energy, contributing to global efforts in reducing greenhouse gas emissions.

## Intended Audience
- **Researchers**: For analyzing energy transitions, emissions, and environmental impacts.
- **Policy Makers**: To gather data-driven insights for energy policies and decisions.
- **General Public**: For understanding the ongoing energy shift through intuitive visualizations.

## Technology Stack
- **Programming Language**: R
- **Framework**: Shiny for interactive web applications
- **Libraries**:
  - `shiny`, `shinydashboard` for building the interactive dashboard.
  - `leaflet` for creating dynamic maps.
  - `dplyr`, `sf`, `purrr`, `readxl`, `RColorBrewer` for data processing.
  - `plotly`, `highcharter`, `ggplot2`, `forecast` for visualizations and interactive plots.

## Data Sources
The project uses multiple datasets related to energy generation, consumption, and emissions. Key datasets include:
- **Australian Energy Update 2023**: Energy consumption data by energy source and state.
- **Postcode Data for Small-Scale Installations**: Annual installation data for various renewable energy sources.
- **State & Territory Inventories 2022**: Emission data by state and sector.
- **Geospatial Data**: Shapefiles for Australian postcodes to visualize spatial trends in energy installations.

## Installation
To run this project locally, ensure you have R and the following libraries installed:

```R
install.packages(c("shiny", "shinydashboard", "leaflet", "dplyr", "sf", "purrr", "readxl", "RColorBrewer", "plotly", "highcharter", "ggplot2", "forecast"))
