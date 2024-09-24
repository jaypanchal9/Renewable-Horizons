
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
The datasets used in this project are private and stored in the `Data/` folder. To access the datasets, please contact me at: **panchaljayofficial@gmail.com**

## Installation
To run this project locally, ensure you have R and the following libraries installed:

```R
install.packages(c("shiny", "shinydashboard", "leaflet", "dplyr", "sf", "purrr", "readxl", "RColorBrewer", "plotly", "highcharter", "ggplot2", "forecast"))
```

### Running the Project
1. Clone this repository.
   ```bash
   git clone https://github.com/your-username/renewable-horizons.git
   ```
2. Open the R project and run the Shiny app.
   ```R
   shiny::runApp('app.R')
   ```

## Usage
1. **Energy Generation Tab**: View trends in renewable energy installations across Australia by region and year.
2. **Energy Consumption Tab**: Analyze the shift from non-renewable to renewable energy sources over time.
3. **Emissions Impact Tab**: Explore how the energy transition has affected emissions and air quality across Australian states.

## Contributing
Contributions are welcome! Please fork the repository, make your changes, and submit a pull request.

## License
This project is licensed under the MIT License.
