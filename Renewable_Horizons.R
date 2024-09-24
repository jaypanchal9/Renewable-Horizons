# List of required packages
required_packages <- c(
  "shiny", "shinydashboard", "shinyjs", "leaflet", "dplyr", 
  "sf", "readxl", "purrr", "RColorBrewer", "forecast", 
  "plotly", "DT", "highcharter", "tidyverse"
)

# Function to install missing packages
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package, dependencies = TRUE)
    library(package, character.only = TRUE)
  }
}

# Apply the function to the list of required packages
sapply(required_packages, install_if_missing)

# Load the libraries
lapply(required_packages, library, character.only = TRUE)


library(shiny)
library(shinydashboard)
library(shinyjs)
library(leaflet)
library(dplyr)
library(sf)
library(readxl)
library(purrr)
library(RColorBrewer)
library(forecast)
library(plotly)
library(DT)
library(highcharter)
library(tidyverse)

custom_css <- "
  .main-header .logo {
    height: 75px; 
    position: fixed;
  }
  .main-header .sidebar-toggle {
    height: 75px;
    line-height: 75px;
    padding: 0 15px;
    background-color: transparent;
    border: none;
  }
  .sidebar-menu {
    margin-top: 75px;
    position: fixed;
    width: 250px;
    height: calc(100% - 75px);
    overflow: auto;
  }
  .custom-legend {
    display: flex;
    justify-content: center;
    margin-top: 10px;
  }
  .custom-legend div {
    margin-right: 15px;
    display: flex;
    align-items: center;
  }
  .custom-legend span {
    width: 20px;
    height: 20px;
    display: inline-block;
    margin-right: 5px;
  }
  .main-header .sidebar-toggle:hover {
    background-color: transparent;
  }
  .main-header .sidebar-toggle:focus {
    outline: none;
  }
  .content-wrapper, .right-side {
    height: calc(100% - 75px);
    overflow-y: auto;
    padding-top: 75px;
  }
  .content {
    padding: 15px;
  }
  .main-header {
    position: fixed;
    width: 100%;
  }
  .section {
    border: 1px solid #ddd;
    padding: 10px;
    border-radius: 5px;
    background-color: #f9f9f9;
    margin: 1px;
    overflow: auto;
  }
  .plotly-container {
    height: 500px !important;
  }
  .leaflet-container {
    height: 500px !important;
  }
  .dataTables_wrapper .dataTables_length, 
  .dataTables_wrapper .dataTables_filter,
  .dataTables_wrapper .dataTables_info,
  .dataTables_wrapper .dataTables_paginate {
    color: #555;
  }
  .dataTables_wrapper .dataTables_filter input {
    border: 1px solid #ddd;
    border-radius: 5px;
    padding: 5px;
  }
  .dataTables_wrapper .dataTables_paginate .paginate_button {
    padding: 0 10px;
    margin-left: 2px;
    margin-right: 2px;
    border: 1px solid #ddd;
    border-radius: 5px;
  }
  .help-button {
    display: block;
    margin: 10px auto;
    padding: 10px 20px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  .help-button:hover {
    background-color: #0056b3;
  }
  .custom-row {
    margin-left: 2px !important;
    margin-right: 2px !important;
  }
  .custom-column {
    padding-left: 1px !important;
    padding-right: 1px !important;
  }
  .clickable-state {
    cursor: pointer;
    color: #007bff;
    text-decoration: underline;
  }
  .clickable-state:hover {
    color: #0056b3;
  }
"



ui <- dashboardPage(
  dashboardHeader(
    title = div(
      style = "display: flex; align-items: center; width: 100%;",
      tags$button(
        id = "sidebarToggle",
        type = "button",
        class = "sidebar-toggle",
        `data-toggle` = "offcanvas",
        `data-target` = ".sidebar-collapse",
        span(class = "icon-bar"),
        span(class = "icon-bar"),
        span(class = "icon-bar")
      ),
      span(style = "flex-grow: 1; text-align: center; padding-left: 15px;", "Renewable Horizons: A Spatial and Temporal Analysis of Australia's Energy Transition and Its Environmental Impact")
    ),
    titleWidth = "100%"
  ),
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      menuItem("Introduction", tabName = "introduction", icon = icon("info")),
      menuItem("Energy Generation", tabName = "energy_generation", icon = icon("bolt")),
      menuItem("Energy Consumption", tabName = "energy_consumption", icon = icon("fire")),
      menuItem("Air Impact due to Emission", tabName = "air_impact", icon = icon("cloud")),
      menuItem("Conclusion", tabName = "conclusion", icon = icon("flag"))
    )
  ),
  dashboardBody(
    useShinyjs(),  # Initialize shinyjs
    tags$head(
      tags$style(HTML(custom_css))
    ),
    tabItems(
      tabItem(tabName = "introduction",
              fluidRow(
                box(title = "Introduction", width = 12, status = "primary", solidHeader = TRUE, collapsible = FALSE,
                    p("Welcome to Renewable Horizons, an interactive dashboard that delves into Australia's journey towards a sustainable energy future. This project aims to explore the spatial and temporal dynamics of Australia's energy transition, focusing on the shift from fossil fuels to renewable energy and its environmental ramifications."),
                    h4("Project Motivation"),
                    p("In the wake of global climate challenges and the pressing need for sustainable development, Australia finds itself at a pivotal point. Rich in both conventional energy resources and renewable potential, the nation is uniquely positioned to lead this transformative era. This dashboard addresses the critical challenges of mitigating climate change while seizing the economic opportunities presented by renewable technologies."),
                    h4("Data Sources"),
                    p("Our analysis is based on a robust dataset that includes:"),
                    tags$ul(
                      tags$li("Australian Energy Statistics 2023: Annualized energy statistics by state."),
                      tags$li("ASGS Spatial Data: Geospatial data covering all of Australia."),
                      tags$li("Postcode Data for Small-Scale Installations: Annual installation data from 2001 to 2023."),
                      tags$li("Air Quality Index Data: Daily air quality index readings across multiple monitoring stations."),
                      tags$li("Australian Postcode Data: Postcode information with state, longitude, and latitude details.")
                    ),
                    h4("User Guide"),
                    p("Navigate through the dashboard to uncover detailed insights into Australia's energy landscape:"),
                    tags$ul(
                      tags$li("Energy Generation: Explore data on both renewable and non-renewable energy sources."),
                      tags$li("Energy Consumption: Analyze consumption patterns across different energy types."),
                      tags$li("Impact on Air Quality: Examine the relationship between energy transitions and air quality trends."),
                      tags$li("Conclusion: Review our findings and policy recommendations for a sustainable energy future.")
                    ),
                    h4("Spatial View of Number of Installation and Total Output in MW (Mega Watts)"),
                    tabsetPanel(
                      tabPanel("Total Output (MW)",
                               leafletOutput("outputMap", height = 600)
                      ),
                      tabPanel("Number of Installations",
                               leafletOutput("installationsMap", height = 600)
                      )
                    ),
                    h4("Lets Dive Deeper into this and Find More About how the Renewable Energy Generation is Impacting Australia's Energy Consumption and its Air Quality"),
                )
              )
      ),
      tabItem(tabName = "energy_generation",
              fluidRow(
                box(title = "Energy Generation", width = 12, status = "primary", solidHeader = TRUE,
                    fluidRow(class = "custom-row",
                             column(4, class = "custom-column",
                                    div(class = "section",
                                        h4("Map Insight Table"),
                                        dataTableOutput("insightTable"),
                                        actionButton("show_help_map", "Show Map Help", class = "help-button")
                                    ),
                                    div(class = "section", HTML("
              <h4>Description for Map and Bar Plot:</h4>
              <p>The map shows the distribution of renewable energy installations across different regions in Australia. Each circle represents the number of installations, with color indicating the region.</p>
              <p>The bar plot displays the total number of installations by region, providing a clear comparison of renewable energy adoption across the country.</p>
           "))
                             ),
                             column(8, class = "custom-column",
                                    div(class = "section", leafletOutput("map")),
                                    div(class = "section", plotlyOutput("barPlot"))
                             )
                    ),
                    fluidRow(class = "custom-row",
                             column(4, class = "custom-column",
                                    div(class = "section",
                                        radioButtons("plot_type", "Select Plot Type:",
                                                     choices = list("Historical Data" = "historical",
                                                                    "Predictions" = "predictions"),
                                                     selected = "historical"),
                                        sliderInput("year_range", "Select Year Range:",
                                                    min = 2001, 
                                                    max = 2028, 
                                                    value = c(2001, 2023),
                                                    step = 1,
                                                    sep = ""),
                                        checkboxInput("show_comparison", "Show Comparison Metrics", value = FALSE),
                                        actionButton("show_help_plot", "Show Plot Help", class = "help-button")
                                    ),
                                    div(class = "section", HTML("
              <h4>Description for Line Chart:</h4>
              <p>The line chart shows the temporal trends in small-scale renewable energy installations. It provides historical data and future predictions for various technologies, highlighting the growth patterns over time.</p>
           "))
                             ),
                             column(8, class = "custom-column",
                                    div(class = "section", plotlyOutput("plot"))
                             ),
                             column(12, class = "custom-column",
                                    div(class = "section", HTML("
              <h4>Geographic Distribution of Renewable Energy Installations:</h4>
              <p>This map illustrates the geographic spread of small-scale renewable energy installations across Australia. Each color represents a different state or territory, providing a clear visual differentiation. Notably, New South Wales (orange) and Queensland (green) display a high density of installations, particularly along the coastal areas, indicating these regions are leading in renewable energy adoption. Western Australia (pink) shows a significant concentration of installations around Perth. Conversely, areas in the Northern Territory and parts of South Australia show fewer installations, highlighting regional disparities in renewable energy deployment.</p>
              
              <h4>Total Installations by Region:</h4>
              <p>This bar chart compares the total number of small-scale renewable energy installations across Australian states and territories. New South Wales (NSW) stands out with the highest number of installations, exceeding 1 million. Queensland (QLD) and Victoria (VIC) follow, showing substantial engagement in renewable energy. In contrast, the Australian Capital Territory (ACT) and the Northern Territory (NT) have markedly fewer installations, suggesting lower adoption rates. This chart effectively highlights regional leaders and laggards in the implementation of renewable energy solutions.</p>
              
              <h4>Temporal Trends in Small-Scale Renewable Energy Installations:</h4>
              <p>This line chart tracks the historical growth of various types of small-scale renewable energy installations in Australia from 2001 to 2024. The chart includes data for SGU-Hydro, SGU-Solar, SGU-Wind, SWH-Air source heat pump, and SWH-Solar. SGU-Solar shows the most dramatic increase, surpassing 3.7 million installations by 2024, reflecting the widespread adoption of solar energy. SWH-Air source heat pump and SWH-Solar also demonstrate significant growth, though at a slower pace. SGU-Wind and SGU-Hydro have seen relatively stable installation numbers, indicating lesser focus on these technologies. This chart underscores the rapid rise of solar energy as the dominant renewable technology in Australia over the past two decades.</p>
              
              <h4>Historical and Predicted Trends in Small-Scale Renewable Energy Installations:</h4>
              <p>This line chart extends the analysis by presenting both historical data and future predictions for small-scale renewable energy installations in Australia from 2001 to 2028. The categories tracked include SGU-Hydro, SGU-Solar, SGU-Wind, SWH-Air source heat pump, and SWH-Solar. Future projections suggest that SGU-Solar installations will continue their rapid growth, potentially exceeding 5.6 million by 2028. Installations of SWH-Air source heat pump and SWH-Solar are also expected to rise steadily. Meanwhile, SGU-Wind and SGU-Hydro installations are forecasted to remain relatively stable. This chart provides a comprehensive outlook on the future trajectory of renewable energy installations, emphasizing the continued dominance and expected expansion of solar energy solutions in Australia's renewable energy landscape.</p>
          "))
                             )
                             
                    )
                )
              ),
              tags$script(HTML("
                    var selectedRegions = [];
                
                    $(document).on('click', '.legend-item', function() {
                      var region = $(this).attr('data-value');
                      var index = selectedRegions.indexOf(region);
                
                      if (index === -1) {
                        selectedRegions.push(region);
                      } else {
                        selectedRegions.splice(index, 1);
                      }
                
                      Shiny.setInputValue('selectedRegions', selectedRegions.slice());
                    });
  "))
              
      ),
      
      tabItem(tabName = "energy_consumption",
              fluidRow(
                box(title = "Energy Consumption", width = 12, status = "primary", solidHeader = TRUE,
                    fluidRow(class = "custom-row",
                             column(4, class = "custom-column",
                                    div(class = "section",
                                        actionButton("showHistorical", "Historical"),
                                        actionButton("showPredictions", "Predictions"),
                                        checkboxInput("showAdvanced", "Show Advanced Calculations", FALSE),
                                        uiOutput("yearSlider"),
                                        actionButton("showHelpTrendModal", "Show Help for Trend Plot", class = "help-button")
                                    )
                             ),
                             column(8, class = "custom-column",
                                    div(class = "section", plotlyOutput("energyPlot"))
                             )
                    ),
                    fluidRow(class = "custom-row",
                             column(4, class = "custom-column",
                                    div(class = "section", HTML("
            <h4>Description for Map and Bar Plot:</h4>
            <p>The map shows the distribution of renewable energy installations across different regions in Australia. Each circle represents the number of installations, with color indicating the region.</p>
            <p>The bar plot displays the total number of installations by region, providing a clear comparison of renewable energy adoption across the country.</p>
                            ")),              
                                    div(class = "section",
                                        actionButton("showHelpSankeyModal", "Show Help for Sankey Diagram", class = "help-button")
                                    )
                             ),
                             column(8, class = "custom-column",
                                    div(class = "section", highchartOutput("sankeyPlot"))
                             ),
                             column(12, class = "custom-column",
                                    div(class = "section", HTML("
              <h4>Energy Consumption Distribution in Australia 2021:</h4>
            <p>This Sankey diagram provides a detailed visualization of the energy consumption distribution across Australia in 2021. The left side of the diagram categorizes the primary energy sources: Oil, Coal, Gas, and Renewables. These energy sources are traced through their consumption across various states and territories, including Queensland, New South Wales, Western Australia, Victoria, South Australia, and the Northern Territory. The thickness of each flow represents the volume of energy consumed. Notably, Coal and Gas dominate the energy mix in states like New South Wales and Queensland, while Western Australia shows a balanced distribution among Coal, Gas, and Oil. Renewables, although growing, still represent a smaller fraction compared to fossil fuels. This diagram effectively highlights the regional disparities in energy consumption and the reliance on different energy sources across Australia.</p>
            
            <h4>Non-Renewable Energy Consumption Trends by State and National Level in Australia (Historical):</h4>
            <p>This line chart illustrates the historical trends in non-renewable energy consumption in Australia, covering the period from 1960 to 2020. The y-axis measures energy consumption in petajoules (PJ). Over the decades, national consumption has surged, particularly from the 1970s onwards, reaching a peak of over 6000 PJ around 2010. New South Wales, Queensland, and Victoria have been the largest consumers of non-renewable energy, reflecting their industrial and economic activities. The chart also shows a slight decline in recent years, indicating a potential shift towards more sustainable energy practices. The data reveals that despite the overall increase in consumption, there are emerging trends towards reducing reliance on non-renewable sources.</p>
            
            <h4>Non-Renewable Energy Consumption Trends by State and National Level in Australia (Historical and Predicted):</h4>
            <p>This enhanced line chart combines historical data from 1960 to 2020 with predictions up to 2028, offering a comprehensive view of non-renewable energy consumption trends in Australia. The historical data shows a steady increase in energy consumption, peaking around 2010. Predictions suggest a gradual decline in national consumption, reflecting the impact of policies and initiatives aimed at reducing non-renewable energy use. New South Wales, Queensland, and Victoria continue to be significant consumers; however, the forecast indicates stabilization or slight reductions in their energy consumption. This chart underscores Australia's efforts towards transitioning to sustainable energy, highlighting the expected decrease in non-renewable energy reliance while maintaining economic growth and development.</p>
                          "))
                             )
                    )
                )
              )
      )
      
      
      ,
      tabItem(tabName = "air_impact",
              fluidRow(
                box(title = "Air Impact", width = 12, status = "primary", solidHeader = TRUE,
                    fluidRow(class = "custom-row",
                             column(4, class = "custom-column",
                                    div(class = "section",
                                        HTML("
                                  <h4>Net Emissions by State Over Time:</h4>
                                  <p>This plot illustrates the trend of net emissions across various Australian states and territories from the financial year 1989-90 to 2021-22. Each colored area represents a different state or territory, providing a visual comparison of how emissions have changed over the years.</p>
                                  <h4>Emissions Distribution by Type for All States in 2021-22:</h4>
                                  <p> This pie chart illustrates the proportion of emissions by different types (Energy, Land Use, Agriculture, etc.) for all the states in the year 2021-22.</p>
                                  <h4>Total Emissions for Australia by State in 2021-22:</h4>
                                  <p>This map depicts the total emissions for each Australian state and territory in the financial year 2021-22. The colors on the map indicate varying levels of emissions, allowing a quick assessment of which regions are the largest contributors to overall emissions in Australia.</p>
                                  "),
                                        actionButton("ShowHelp_1", "How to Interact with Plot")
                                    )
                                    
                             ),
                             column(8, class = "custom-column",
                                    div(class = "section", plotlyOutput("emissionPlotUnique"))
                             ),
                             column(4, class = "custom-column",
                                    div(class = "section",
                                        HTML("
                        <p class='clickable-state' data-state='New South Wales'>New South Wales</p>
                        
                        <p>2021-22 Emissions: 111.0 Mt CO2-e<br>
                           Trend: 27% reduction from 2004-05 levels.<br>
                           Key Points: Decrease driven by reductions in energy, agriculture, and land sectors. Transport emissions down 2% since 2004-05. Emissions rose by 3% post-pandemic.</p>
                  
                        <p class='clickable-state' data-state='Queensland'>Queensland</p>
                        
                        <p>2021-22 Emissions: 124.1 Mt CO2-e<br>
                           Trend: 35% reduction from 2004-05 levels.<br>
                           Key Points: Decrease primarily in land sector; increases in energy and fossil fuel extraction. Transport emissions up 20%.</p>
                           
                        <p class='clickable-state' data-state='Victoria'>Victoria</p>
                        <p>2021-22 Emissions: 84.7 Mt CO2-e<br>
                           Trend: 31% reduction from 2004-05 levels.<br>
                           Key Points: Significant decreases in energy and land sectors. Transport emissions decreased by 2%.</p>
                        
                        <p class='clickable-state' data-state='Western Australia'>Western Australia</p>
                        
                        <p>2021-22 Emissions: 124.1 Mt CO2-e<br>
                            Trend: 35% reduction from 2004-05 levels.<br>
                            Key Points: Decrease primarily in land sector; increases in energy and fossil fuel extraction. Transport emissions up 20%.</p>
                            
                        <p class='clickable-state' data-state='South Australia'>South Australia</p>
                        
                        <p>2021-22 Emissions: 15.8 Mt CO2-e<br>
                           Trend: 57% reduction from 2004-05 levels.<br>
                           Key Points: Major reductions in energy sector, particularly electricity generation.</p>
                           
                        <p class='clickable-state' data-state='Tasmania'>Tasmania</p>
                        
                        <p>2021-22 Emissions: -4.3 Mt CO2-e (net sink)<br>
                            Trend: 128% reduction from 2004-05 levels.<br>
                            Key Points: Significant decrease in land sector emissions due to reduced forest harvesting.</p>
                            
                        <p class='clickable-state' data-state='Northern Territory'>Northern Territory</p>
                        
                        <p>2021-22 Emissions: 16.7 Mt CO2-e<br>
                           Trend: 49% increase from 2004-05 levels.<br>
                           Key Points: Growth driven by mining and fossil fuel extraction.</p>
                           
                        <p class='clickable-state' data-state='Australian Capital Territory'>Australian Capital Territory</p>
                        
                        <p>2021-22 Emissions: 1.3 Mt CO2-e<br>
                           Trend: 10% reduction from 2004-05 levels.<br>
                           Key Points: Increase in transport emissions by 15%.</p>
                            ")
                                    )),
                             column(8, class = "custom-column",
                                    div(class = "section", plotlyOutput("pieChartUnique"))
                             ),
                             column(8, class = "custom-column",
                                    div(class = "section", leafletOutput("choroplethMapUnique"))
                             )
                    )
                )
              )
      ),
      tabItem(tabName = "conclusion",
              fluidRow(
                box(title = "Conclusion", width = 12, status = "primary", solidHeader = TRUE,
                    p("Summary of findings and reflections."),
                    column(12, class = "custom-column",
                           div(class = "section", HTML("
                            <h4>Energy Consumption Distribution in Australia 2021:</h4>
                            <p>This Sankey diagram provides a detailed visualization of energy consumption distribution in Australia for the year 2021. The diagram categorizes primary energy sources—Oil, Coal, Gas, and Renewables—and traces their consumption across various states and territories, including Queensland, New South Wales, Western Australia, Victoria, South Australia, and Northern Territory. Each colored flow represents the volume of energy consumed by each region from each source. Notably, Queensland and New South Wales show significant consumption of coal and gas, while Western Australia demonstrates a more balanced distribution among Coal, Gas, and Oil. Although growing, renewables still represent a smaller fraction compared to fossil fuels. This visualization effectively highlights regional dependencies on different energy sources and underscores the ongoing challenge of increasing the share of renewable energy in Australia's energy mix.</p>
                            
                            <h4>Non-Renewable Energy Consumption Trends by State and National Level in Australia (Historical):</h4>
                            <p>This line chart illustrates historical trends in non-renewable energy consumption across Australian states and at the national level from 1960 to 2020. The y-axis measures energy consumption in petajoules (PJ). Over the decades, national consumption surged, particularly from the 1970s to the early 2000s, reaching a peak of over 6000 PJ around 2010. Major contributors to this consumption include New South Wales, Queensland, and Victoria, reflecting their industrial and economic activities. The chart also indicates a slight decline in recent years, suggesting a potential shift towards more sustainable energy practices. This historical data provides valuable insights into how non-renewable energy consumption has evolved in Australia over the decades.</p>
                            
                            <h4>Non-Renewable Energy Consumption Trends by State and National Level in Australia (Historical and Predicted):</h4>
                            <p>This enhanced line chart combines historical data from 1960 to 2020 with predictions extending to 2028, offering a comprehensive view of non-renewable energy consumption trends in Australia. The historical data shows a steady increase in energy consumption, peaking around 2010. Predictions suggest a gradual decline in national consumption, reflecting the impact of policies and initiatives aimed at reducing non-renewable energy use. New South Wales, Queensland, and Victoria continue to be significant consumers, but the forecast indicates stabilization or slight reductions in their non-renewable energy consumption. This chart underscores Australia's efforts to transition to sustainable energy, highlighting the expected decrease in reliance on non-renewable sources while maintaining economic growth.</p>
                            
                            <h4>Net Emissions by State Over Time:</h4>
                            <p>This plot illustrates the trend of net emissions across various Australian states and territories from the financial year 1989-90 to 2021-22. Each colored area represents a different state or territory, providing a visual comparison of how emissions have changed over the years.</p>
                            
                            <h4>Emissions Distribution by Type for New South Wales in 2021-22:</h4>
                            <p>This pie chart breaks down the sources of emissions in New South Wales for the financial year 2021-22. It shows the percentage contribution of different emission types, including Energy, Land Use, Agriculture, Industrial Processes, and Waste, highlighting the dominant sources of emissions in the state.</p>
                            
                            <h4>Total Emissions for Australia by State in 2021-22:</h4>
                            <p>This map depicts the total emissions for each Australian state and territory in the financial year 2021-22. The colors on the map indicate varying levels of emissions, allowing for a quick visual assessment of which regions are the largest contributors to overall emissions in Australia.</p>
                            
                            <h4>Geographic Distribution of Renewable Energy Installations:</h4>
                            <p>This map illustrates the geographic spread of small-scale renewable energy installations across Australia. Different colors represent installations in various states and territories, highlighting regions with higher concentrations of renewable energy projects. The eastern coast, particularly New South Wales (orange) and Queensland (green), show a high density of installations. Western Australia (pink) also has a significant concentration around Perth, while other regions show varying levels of distribution. This map emphasizes the regional differences in the adoption of renewable energy installations across Australia.</p>
                            
                            <h4>Total Installations by Region:</h4>
                            <p>This bar chart compares the total number of small-scale renewable energy installations across Australian states and territories. New South Wales (NSW) stands out with the highest number of installations, exceeding 1 million. Queensland (QLD) and Victoria (VIC) follow, showing substantial engagement in renewable energy. In contrast, the Australian Capital Territory (ACT) and the Northern Territory (NT) have markedly fewer installations, suggesting lower adoption rates. This chart effectively highlights regional leaders and laggards in the implementation of renewable energy solutions.</p>
                            
                            <h4>Temporal Trends in Small-Scale Renewable Energy Installations:</h4>
                            <p>This line chart tracks the historical growth of various types of small-scale renewable energy installations in Australia from 2001 to 2024. The chart includes data for SGU-Hydro, SGU-Solar, SGU-Wind, SWH-Air source heat pump, and SWH-Solar. SGU-Solar shows the most dramatic increase, surpassing 1 million installations by 2024, reflecting the widespread adoption of solar energy. SWH-Air source heat pump and SWH-Solar also demonstrate significant growth, though at a slower pace. SGU-Wind and SGU-Hydro have seen relatively stable installation numbers, indicating lesser focus on these technologies. This chart underscores the rapid rise of solar energy as the dominant renewable technology in Australia over the past two decades.</p>
                            
                            <h4>Historical and Predicted Trends in Small-Scale Renewable Energy Installations:</h4>
                            <p>This line chart extends the analysis by presenting both historical data and future predictions for small-scale renewable energy installations in Australia from 2001 to 2028. The categories tracked include SGU-Hydro, SGU-Solar, SGU-Wind, SWH-Air source heat pump, and SWH-Solar. Future projections suggest that SGU-Solar installations will continue their rapid growth, potentially exceeding 1.5 million by 2028. Installations of SWH-Air source heat pump and SWH-Solar are also expected to rise steadily. Meanwhile, SGU-Wind and SGU-Hydro installations are forecasted to remain relatively stable. This chart provides a comprehensive outlook on the future trajectory of renewable energy installations, emphasizing the continued dominance and expected expansion of solar energy solutions in Australia's renewable energy landscape.</p>
                            
                            <h4>Conclusion:</h4>
                            <p>Australia's journey towards a sustainable energy future is marked by significant progress in renewable energy adoption, efforts to reduce non-renewable energy consumption, and improvements in air quality. The geographic distribution of renewable energy installations shows that New South Wales and Queensland are leading in renewable energy adoption, with over 1 million installations in New South Wales alone. Historical data reveals a dramatic increase in SGU-Solar installations, with projections indicating continued rapid growth. The Sankey diagram highlights the regional dependencies on different energy sources, with coal and gas dominating in states like New South Wales and Queensland. Despite a historical surge in non-renewable energy consumption, recent trends and predictions show a gradual decline, reflecting Australia's commitment to reducing reliance on non-renewable sources. Improvements in air quality, driven by reductions in emissions from key sectors, highlight the environmental benefits of this transition. This dashboard serves as a comprehensive tool for understanding these trends and informing policy decisions to support Australia's energy transition while improving air quality and reducing environmental impacts.</p>

                             ")),
                           div(class = "section", tags$img(src = "https://rocklandcapital.com/wp-content/uploads/2022/03/solar-wind-2.jpg", 
                                    alt = "Solar and Wind Image", 
                                    width = "100%"))
                    )
                )
              )
      )
    )
  ),
  
  # Modals for help text
  tags$div(id = "modals",
           div(
             class = "modal fade", id = "modalHelpTrend", tabindex = "-1", role = "dialog",
             div(
               class = "modal-dialog", role = "document",
               div(
                 class = "modal-content",
                 div(
                   class = "modal-header",
                   tags$h5(class = "modal-title", "Trend Plot Help"),
                   tags$button(type = "button", class = "close", `data-dismiss` = "modal", `aria-label` = "Close",
                               tags$span(`aria-hidden` = "true", HTML("&times;"))
                   )
                 ),
                 div(
                   class = "modal-body",
                   p("Use the 'Historical' and 'Predictions' buttons to toggle between historical data and forecast data.
                      Adjust the year range using the slider to focus on a specific period.
                      Hover over the lines to see detailed information about energy consumption.
                      Check the 'Show Advanced Calculations' checkbox to display additional metrics like past year and past 5 years percentage change.")
                 ),
                 div(
                   class = "modal-footer",
                   tags$button(type = "button", class = "btn btn-secondary", `data-dismiss` = "modal", "Close")
                 )
               )
             )
           ),
           div(
             class = "modal fade", id = "modalHelpSankey", tabindex = "-1", role = "dialog",
             div(
               class = "modal-dialog", role = "document",
               div(
                 class = "modal-content",
                 div(
                   class = "modal-header",
                   tags$h5(class = "modal-title", "Sankey Diagram Help"),
                   tags$button(type = "button", class = "close", `data-dismiss` = "modal", `aria-label` = "Close",
                               tags$span(`aria-hidden` = "true", HTML("&times;"))
                   )
                 ),
                 div(
                   class = "modal-body",
                   p("The Sankey diagram displays the flow of energy consumption from sources to states.
                      Click on a node to highlight the links connected to it.
                      Click on a link to see detailed information about the flow between the connected nodes.
                      Click on the same element again to revert to the previous state.")
                 ),
                 div(
                   class = "modal-footer",
                   tags$button(type = "button", class = "btn btn-secondary", `data-dismiss` = "modal", "Close")
                 )
               )
             )
           )
  )
)




server <- function(input, output, session) {
  
  
  # Load the data
  file_path_unique <- "airquality.xlsx"
  data_unique <- read_excel(file_path_unique, sheet = "Sheet1")
  
  # Filter out rows that do not belong to States
  state_names_unique <- c("New South Wales", "Queensland", "Victoria", "Western Australia", "South Australia", "Tasmania", "Northern Territory", "Australian Capital Territory")
  state_data_unique <- data_unique %>% filter(State %in% state_names_unique)
  
  # Reshape the data for plotting, excluding the 'Year' column
  melted_data_unique <- state_data_unique %>%
    pivot_longer(cols = -c(State, Year), names_to = "Financial_Year", values_to = "Emissions")
  
  # Convert 'Emissions' to numeric, replacing non-numeric entries with NA and then fill NAs with 0
  melted_data_unique$Emissions <- as.numeric(as.character(melted_data_unique$Emissions))
  melted_data_unique$Emissions[is.na(melted_data_unique$Emissions)] <- 0
  
  # Calculate additional matrices
  melted_data_unique <- melted_data_unique %>%
    group_by(State) %>%
    arrange(State, Financial_Year) %>%
    mutate(
      `5 Year Avg` = zoo::rollmean(Emissions, 5, fill = NA, align = "right"),
      `Past Year Diff` = Emissions - lag(Emissions, 1),
      `Past 5 Year Diff` = Emissions - lag(Emissions, 5)
    ) %>%
    ungroup()
  
  # Define the color palette based on the provided image
  color_palette_unique <- c(
    "New South Wales" = "#FBB03B",     # NSW
    "Queensland" = "#A1DD4F",         # QLD
    "Victoria" = "#9C27B0",           # VIC
    "Western Australia" = "#FF4081",  # WA
    "South Australia" = "#00D4FF",    # SA
    "Tasmania" = "#0033CC",           # TAS
    "Northern Territory" = "#CCFF33", # NT
    "Australian Capital Territory" = "#F44336" # ACT
  )
  
  # Load the emissions data from the Excel file
  emissions_file_unique <- "airquality.xlsx"
  emissions_data_unique <- read_excel(emissions_file_unique, sheet = "Sheet1")
  
  # Preprocess the data
  emissions_2021_22_unique <- emissions_data_unique %>%
    select(State, `2021-22`) %>%
    rename(Emissions = `2021-22`) %>%
    filter(!State %in% c("Australia", "External Territories"))
  
  # Clean the names to ensure matching
  emissions_2021_22_unique$State <- str_trim(emissions_2021_22_unique$State)
  emissions_2021_22_unique$State <- str_replace_all(emissions_2021_22_unique$State, "\\s+", " ")
  
  # Load the shapefile
  shapefile_path_unique <- "STE_2021_AUST_GDA2020.shp"
  shapefile_states_unique <- st_read(shapefile_path_unique)
  
  # Clean the names in the shapefile to ensure matching
  shapefile_states_unique$STE_NAME21 <- str_trim(shapefile_states_unique$STE_NAME21)
  shapefile_states_unique$STE_NAME21 <- str_replace_all(shapefile_states_unique$STE_NAME21, "\\s+", " ")
  
  # Transform the CRS to WGS84
  shapefile_states_unique <- st_transform(shapefile_states_unique, crs = 4326)
  
  # Merge shapefile data with emissions data
  merged_emission_data_unique <- merge(shapefile_states_unique, emissions_2021_22_unique, by.x = "STE_NAME21", by.y = "State", all.x = TRUE)
  
  # Filter out rows with NA in Emissions column
  merged_emission_data_unique <- merged_emission_data_unique %>% filter(!is.na(Emissions))
  
  
  # Reactive value to store the selected region
  selected_region_unique <- reactiveVal("New South Wales")
  
  output$choroplethMapUnique <- renderLeaflet({
    # Define the color palette
    palette_unique <- colorNumeric("YlOrRd", domain = merged_emission_data_unique$Emissions)
    
    leaflet(data = merged_emission_data_unique) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(
        fillColor = ~palette_unique(Emissions),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = ~paste("State:", STE_NAME21,
                       "Emissions (Gt CO2-e):", Emissions),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      addLegend(
        pal = palette_unique,
        values = ~Emissions,
        title = "Emissions (Gt CO2-e)",
        position = "bottomright"
      )
  })
  
  output$emissionPlotUnique <- renderPlotly({
    tooltip_data_unique <- 
      melted_data_unique %>%
      mutate(
        tooltip_text = paste(
          "State:", State,
          "<br>Financial Year:", Financial_Year,
          "<br>Emissions:", scales::comma(Emissions)
        )
      )
    
    # Ensure the tooltip data is a data frame
    tooltip_data_unique <- as.data.frame(tooltip_data_unique)
    tooltip_data_unique$Financial_Year <- as.factor(tooltip_data_unique$Financial_Year)
    
    plot_unique <- ggplot(tooltip_data_unique, aes(x = Financial_Year, y = Emissions, fill = State, group = State, text = tooltip_text)) +
      geom_area(position = "stack", alpha = 0.6) +
      scale_fill_manual(values = color_palette_unique) +
      labs(title = "Net Emissions by State Over Time",
           x = "Financial Year", y = "Emissions", fill = "State") +
      scale_y_continuous(labels = scales::comma) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
    
    ggplotly(plot_unique, tooltip = "text") %>%
      layout(legend = list(orientation = "v", x = 1, y = 0.5))
  })
  
  file_path_data_unique <- "anga-state-territory-inventories-2022-emission - Copy.xlsx"
  
  # Function to load and process the data
  load_data_unique <- reactive({
    sheets_unique <- excel_sheets(file_path_data_unique)
    sheets_unique <- sheets_unique[sheets_unique != 'Australia']
    
    data_list_unique <- lapply(sheets_unique, function(sheet) {
      read_excel(file_path_data_unique, sheet = sheet)
    })
    names(data_list_unique) <- sheets_unique
    data_list_unique
  })
  
  # Function to create a pie chart for a given region's data frame
  create_pie_chart_unique <- function(region_name, df) {
    latest_year_unique <- tail(names(df), 1)
    
    latest_data_unique <- df %>%
      select(1, latest_year_unique) %>%
      rename(Type = 1, Emissions = latest_year_unique)
    
    plot_ly(latest_data_unique, labels = ~Type, values = ~abs(Emissions), type = 'pie', textinfo = 'label+percent',
            hoverinfo = 'label+value+percent', textposition = 'inside') %>%
      layout(title = paste("Emissions Distribution by Type for", region_name, "in", latest_year_unique),
             showlegend = TRUE)
  }
  
  # Render the pie chart based on the selected region
  output$pieChartUnique <- renderPlotly({
    region <- selected_region_unique()
    req(region)
    data_list_unique <- load_data_unique()
    create_pie_chart_unique(region, data_list_unique[[region]])
  })
  
  observe({
    shinyjs::runjs("
      $('.clickable-state').click(function() {
        Shiny.setInputValue('region', $(this).data('state'), {priority: 'event'});
      });
    ")
  })
  
  observeEvent(input$region, {
    selected_region_unique(input$region)
  })
  
  # Set the initial value of the region input to "New South Wales"
  selected_region_unique("New South Wales")
  
  # Show Help modal for Plots
  observeEvent(input$ShowHelp_1, {
    showModal(modalDialog(
      title = "Help Guide",
      HTML("<b>Emission Plot Help:</b><br>
          <ul>
            <li>The Emission Plot shows the net emissions by state over time.</li>
            <li>Hover over the plot to see detailed information for each state and year.</li>
            <li>Use the legend to highlight emissions for specific states.</li>
          </ul>
          <b>Pie Chart Help:</b><br>
          <ul>
            <li>The Pie Chart shows the emissions distribution by type for the selected region.</li>
            <li>Hover over the chart to see detailed information about each emission type.</li>
            <li>Click on a slice to focus on a particular emission type.</li>
          </ul>
          <b>Choropleth Map Help:</b><br>
          <ul>
            <li>The Choropleth Map shows the emissions distribution across different states.</li>
            <li>Hover over a state to see detailed information about its emissions.</li>
            <li>Use the legend to interpret the color coding of emissions levels.</li>
          </ul>"),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Reactive value to store the selected region
  selected_region <- reactiveVal("New South Wales")
  
  output$choroplethMap <- renderLeaflet({
    # Define the color palette
    pal <- colorNumeric("YlOrRd", domain = merged_data$Emissions)
    
    leaflet(data = merged_data) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(
        fillColor = ~pal(Emissions),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = ~paste("State:", STE_NAME21,
                       "Emissions (Gt CO2-e):", Emissions),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      addLegend(
        pal = pal,
        values = ~Emissions,
        title = "Emissions (Gt CO2-e)",
        position = "bottomright"
      )
  })
  
  output$emissionPlot <- renderPlotly({
    tooltip_data <- 
      data_melted %>%
      mutate(
        tooltip_text = paste(
          "State:", State,
          "<br>Financial Year:", Financial_Year,
          "<br>Emissions:", scales::comma(Emissions)
        )
      )
    
    # Ensure the tooltip data is a data frame
    tooltip_data <- as.data.frame(tooltip_data)
    tooltip_data$Financial_Year <- as.factor(tooltip_data$Financial_Year)
    
    p <- ggplot(tooltip_data, aes(x = Financial_Year, y = Emissions, fill = State, group = State, text = tooltip_text)) +
      geom_area(position = "stack", alpha = 0.6) +
      scale_fill_manual(values = state_colors) +
      labs(title = "Net Emissions by State Over Time",
           x = "Financial Year", y = "Emissions", fill = "State") +
      scale_y_continuous(labels = scales::comma) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
    
    ggplotly(p, tooltip = "text") %>%
      layout(legend = list(orientation = "v", x = 1, y = 0.5))
  })
  
  file_path <- "anga-state-territory-inventories-2022-emission - Copy.xlsx"
  
  # Function to load and process the data
  load_data <- reactive({
    sheets <- excel_sheets(file_path)
    sheets <- sheets[sheets != 'Australia']
    
    data_list <- lapply(sheets, function(sheet) {
      read_excel(file_path, sheet = sheet)
    })
    names(data_list) <- sheets
    data_list
  })
  
  # Function to create a pie chart for a given region's data frame
  plot_pie_chart <- function(region_name, df) {
    latest_year <- tail(names(df), 1)
    
    latest_data <- df %>%
      select(1, latest_year) %>%
      rename(Type = 1, Emissions = latest_year)
    
    plot_ly(latest_data, labels = ~Type, values = ~abs(Emissions), type = 'pie', textinfo = 'label+percent',
            hoverinfo = 'label+value+percent', textposition = 'inside') %>%
      layout(title = paste("Emissions Distribution by Type for", region_name, "in", latest_year),
             showlegend = TRUE)
  }
  
  # Render the pie chart based on the selected region
  output$pieChart <- renderPlotly({
    region <- selected_region()
    req(region)
    data_list <- load_data()
    plot_pie_chart(region, data_list[[region]])
  })
  
  observe({
    shinyjs::runjs("
      $('.clickable-state').click(function() {
        Shiny.setInputValue('region', $(this).data('state'), {priority: 'event'});
      });
    ")
  })
  
  observeEvent(input$region, {
    selected_region(input$region)
  })
  
  # Set the initial value of the region input to "New South Wales"
  selected_region("New South Wales")
  
  # Show Help modal for Plots
  observeEvent(input$ShowHelp, {
    showModal(modalDialog(
      title = "Emission Plot Help",
      HTML("<b>Help Guide:</b><br>
          <ul>
            <li>The Emission Plot shows the net emissions by state over time.</li>
            <li>Hover over the plot to see detailed information for each state and year.</li>
            <li>Use the legend to highlight emissions for specific states.</li>
          </ul>"),
      title = "Pie Chart Help",
      HTML("<b>Help Guide:</b><br>
          <ul>
            <li>The Pie Chart shows the emissions distribution by type for the selected region.</li>
            <li>Hover over the chart to see detailed information about each emission type.</li>
            <li>Click on a slice to focus on a particular emission type.</li>
          </ul>"),
      title = "Choropleth Map Help",
      HTML("<b>Help Guide:</b><br>
          <ul>
            <li>The Choropleth Map shows the emissions distribution across different states.</li>
            <li>Hover over a state to see detailed information about its emissions.</li>
            <li>Use the legend to interpret the color coding of emissions levels.</li>
          </ul>"),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Load the CSV data
  data_path <- "merged_installations.csv"
  installations_data <- read.csv(data_path)
  
  # Clean state names in the CSV data
  installations_data$state <- as.character(installations_data$state)
  installations_data$state <- trimws(installations_data$state)
  
  # Perform the aggregation by state
  aggregated_data <- installations_data %>%
    group_by(state) %>%
    summarise(
      number_of_installations = sum(number_of_installations, na.rm = TRUE),
      total_output_kw = sum(total_output_kw, na.rm = TRUE)
    )
  
  # Define state name mapping
  state_name_mapping <- c(
    "ACT" = "Australian Capital Territory",
    "NSW" = "New South Wales",
    "NT" = "Northern Territory",
    "QLD" = "Queensland",
    "SA" = "South Australia",
    "TAS" = "Tasmania",
    "VIC" = "Victoria",
    "WA" = "Western Australia"
  )
  
  # Map state names to match
  aggregated_data$state <- recode(aggregated_data$state, !!!state_name_mapping)
  
  # Load the shapefile for Australian states
  shapefile_path <- "STE_2021_AUST_GDA2020.shp"
  australia_states <- st_read(shapefile_path)
  
  # Transform the CRS to WGS84
  australia_states <- st_transform(australia_states, crs = 4326)
  
  # Merge the shapefile data with the aggregated data
  merged_data <- merge(australia_states, aggregated_data, by.x = "STE_NAME21", by.y = "state", all.x = TRUE)
  
  # Remove rows with NA values in the columns of interest
  merged_data <- merged_data[!is.na(merged_data$total_output_kw) & !is.na(merged_data$number_of_installations), ]
  
  # Convert total output to millions
  merged_data$total_output_mw <- merged_data$total_output_kw / 1e6
  
  # Render the leaflet maps
  output$outputMap <- renderLeaflet({
    leaflet(data = merged_data) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(
        fillColor = ~colorNumeric("YlOrRd", total_output_mw)(total_output_mw),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = ~paste("State:", STE_NAME21,
                       "Total Output (MW):", total_output_mw),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      addLegend(
        pal = colorNumeric("YlOrRd", merged_data$total_output_mw),
        values = ~total_output_mw,
        title = "Total Output (MW)",
        position = "bottomright"
      )
  })
  
  output$installationsMap <- renderLeaflet({
    leaflet(data = merged_data) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(
        fillColor = ~colorNumeric("YlGnBu", number_of_installations)(number_of_installations),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = ~paste("State:", STE_NAME21,
                       "Number of Installations:", number_of_installations),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      addLegend(
        pal = colorNumeric("YlGnBu", merged_data$number_of_installations),
        values = ~number_of_installations,
        title = "Number of Installations",
        position = "bottomright"
      )
  })
  
  # Toggle sidebar visibility when the button is clicked
  observeEvent(input$sidebarToggle, {
    shinyjs::toggleClass(selector = "body", class = "sidebar-collapse")
  })
  
  # Show Help modal for map
  observeEvent(input$show_help_map, {
    showModal(modalDialog(
      title = "Map Help",
      HTML("
        <h4>Map of Installations in Australia</h4>
        <p>This application provides a visual representation of installations in different regions of Australia.</p>
        <ul>
          <li><b>Map:</b> The map shows the installations in various regions. You can select regions by clicking on the legend items. The circles represent the number of installations, and you can hover over them to see detailed information.</li>
          <li><b>Bar Plot:</b> The bar plot displays the total number of installations by region. Hover over the bars to see the total number of installations and their percentage contribution.</li>
          <li><b>Insight Table:</b> This table provides a comparison between selected regions. It shows the difference in installation counts and the percentage difference.</li>
        </ul>
        <p>Select multiple regions to compare them. If less than two regions are selected, a message will prompt you to select at least two regions.</p>
      "),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Load the Excel file for installations data
  file_path <- "installations_data.xlsx"  # Adjust the path as needed
  sheets <- excel_sheets(file_path)
  
  # Define a small constant to add to installation counts to avoid log(0)
  small_constant <- 1
  
  # Aggregate the data to get total installations per year for each technology
  data_list <- map(sheets, ~{
    data <- read_excel(file_path, sheet = .x)
    data[is.na(data)] <- 0  # Replace NaNs with zeros
    yearly_totals <- colSums(data[-1, ], na.rm = TRUE)
    tibble(Year = as.numeric(names(yearly_totals)),
           Total_Installations = yearly_totals,
           Technology = .x)
  })
  
  # Combine all the data into a single dataframe
  data_aggregated <- bind_rows(data_list) %>%
    arrange(Technology, Year)
  
  # Prepare future years for prediction
  future_years <- tibble(Year = 2024:2028)
  
  # Fit ETS models and generate predictions
  fit_ets <- function(data) {
    ts_data <- ts(data$Total_Installations, start = min(data$Year), frequency = 1)
    fit <- ets(ts_data)
    forecast(fit, h = 5) # Forecast for 5 future years
  }
  
  # Generate predictions using ETS model
  predictions_list <- map(unique(data_aggregated$Technology), ~{
    tech_data <- data_aggregated %>% filter(Technology == .x)
    forecasts <- fit_ets(tech_data)
    future_preds <- forecasts$mean
    tibble(Year = future_years$Year,
           Total_Installations = as.numeric(future_preds),
           Technology = .x)
  })
  
  predictions <- bind_rows(predictions_list)
  
  # Combine historical data with predictions
  data_combined <- bind_rows(data_aggregated, predictions)
  
  # Calculate percentage change year over year
  data_combined <- data_combined %>%
    group_by(Technology) %>%
    arrange(Year) %>%
    mutate(Percentage_Change = (Total_Installations / lag(Total_Installations) - 1) * 100,
           Cumulative_Installations = cumsum(Total_Installations))
  
  # Handle zeros before log transformation
  data_combined <- data_combined %>%
    mutate(Total_Installations = ifelse(Total_Installations <= 0, NA, Total_Installations))
  
  # Load the CSV data for map installations
  data_path <- "merged_installations.csv"
  installations_data <- read.csv(data_path)
  
  # Define a color palette function based on the state
  state_palette <- colorFactor(rainbow(length(unique(installations_data$state))), installations_data$state)
  # Reactive value to keep track of help text visibility for plot
  help_visible_plot <- reactiveVal(FALSE)
  
  observe({
    if (input$plot_type == "historical") {
      updateSliderInput(session, "year_range",
                        min = min(data_aggregated$Year), 
                        max = max(data_aggregated$Year), 
                        value = c(min(data_aggregated$Year), max(data_aggregated$Year)),
                        step = 1)
    } else {
      updateSliderInput(session, "year_range",
                        min = min(data_combined$Year), 
                        max = max(data_combined$Year), 
                        value = c(min(data_combined$Year), max(data_combined$Year)),
                        step = 1)
    }
  })
  
  output$plot <- renderPlotly({
    selected_data <- data_combined %>%
      filter(Year >= input$year_range[1],
             Year <= input$year_range[2])
    
    if (input$plot_type == "historical") {
      selected_data <- selected_data %>% filter(Year <= max(data_aggregated$Year))
    }
    
    color_palette <- brewer.pal(n = length(unique(selected_data$Technology)), name = "Dark2")
    
    y_breaks <- c(1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000)
    y_labels <- c("1", "10", "100", "1k", "10k", "100k", "1M", "10M", "100M")
    
    plot <- ggplot(selected_data, aes(x = Year, y = Total_Installations, group = Technology, color = Technology)) +
      geom_line(size = 1.2) +
      geom_point(aes(text = paste("Renewable Energy Source:", Technology, "<br>Year:", Year, "<br>Total Installations:", Total_Installations,
                                  if (input$show_comparison) paste("<br>Percentage Change:", round(Percentage_Change, 2), "%",
                                                                   "<br>Cumulative Installations:", Cumulative_Installations) else "")),
                 size = 3, alpha = 0) + # Invisible points for tooltips
      scale_y_log10(breaks = y_breaks, labels = y_labels) +
      scale_x_continuous(breaks = 2001:2028) +
      scale_color_manual(values = color_palette) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, hjust = 0.5),
            legend.position = "right") +  # Move the legend to the bottom
      labs(title = "Temporal Trends in Small-Scale Renewable Energy Installations",
           x = "Year",
           y = "Total Number of Installations",
           color = "Renewable Energy Source")
    
    ggplotly(plot, tooltip = "text") %>%
      layout(hovermode = "closest", 
             legend = list(orientation = "v")) %>%
      style(hoverinfo = "text")
  })
  
  # Reactive value to keep track of help text visibility for plot
  help_visible_plot <- reactiveVal(FALSE)
  help_visible_map <- reactiveVal(FALSE)
  
  observeEvent(input$show_help_plot, {
    showModal(modalDialog(
      title = "Plot Help",
      HTML("<b>Help Guide:</b><br>
            <ul>
              <li><b>Select Plot Type:</b> Choose between historical data and predictions.</li>
              <li><b>Select Year Range:</b> Adjust the year range for the data to display.</li>
              <li><b>Show Comparison Metrics:</b> Check to display percentage change year over year and cumulative installations.</li>
            </ul>"),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  observeEvent(input$show_help_map, {
    showModal(modalDialog(
      title = "Map Help",
      HTML("<b>Map Help Guide:</b><br>
            <ul>
              <li><b>Map:</b> The map shows the installations in various regions. You can select regions by clicking on the legend items. The circles represent the number of installations, and you can hover over them to see detailed information.</li>
              <li><b>Bar Plot:</b> The bar plot displays the total number of installations by region. Hover over the bars to see the total number of installations and their percentage contribution.</li>
              <li><b>Insight Table:</b> This table provides a comparison between selected regions. It shows the difference in installation counts and the percentage difference.</li>
            </ul>"),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Reactive expression to get the selected regions' data
  selected_data <- reactive({
    if (is.null(input$selectedRegions) || length(input$selectedRegions) == 0) {
      installations_data
    } else {
      installations_data %>% filter(state %in% input$selectedRegions)
    }
  })
  
  # Render the leaflet map
  output$map <- renderLeaflet({
    map <- leaflet() %>%
      addProviderTiles(providers$Esri.WorldTopoMap) %>%
      setView(lng = 133.7751, lat = -25.2744, zoom = 4) %>%
      addCircles(lng = installations_data$longitude, lat = installations_data$latitude, weight = 1,
                 radius = ifelse(installations_data$state == "ACT", sqrt(installations_data$number_of_installations) * 100,
                                 sqrt(installations_data$number_of_installations) * 700),
                 color = state_palette(installations_data$state), 
                 fillColor = state_palette(installations_data$state), 
                 fillOpacity = 0.5,
                 popup = paste(installations_data$postcode, "Installations:", installations_data$number_of_installations)) %>%
      addLegendCustom(position = "bottomright", pal = state_palette, values = unique(installations_data$state),
                      title = "Region", opacity = 0.7)
    
    map
  })
  
  # Observe changes in the selected regions and update the map
  observe({
    data <- selected_data()
    
    if (nrow(data) > 0) {
      lng_range <- range(data$longitude, na.rm = TRUE)
      lat_range <- range(data$latitude, na.rm = TRUE)
      
      leafletProxy("map") %>%
        clearShapes() %>%
        addCircles(lng = data$longitude, lat = data$latitude, weight = 1,
                   radius = ifelse(data$state == "ACT", sqrt(data$number_of_installations) * 100,
                                   sqrt(data$number_of_installations) * 700),
                   color = state_palette(data$state), 
                   fillColor = state_palette(data$state), 
                   fillOpacity = 0.5,
                   popup = paste(data$postcode, "Installations:", data$number_of_installations)) %>%
        fitBounds(lng_range[1], lat_range[1], lng_range[2], lat_range[2])
    } else {
      cat("No data found for selected regions.\n")
    }
  })
  
  # Render bar plot
  output$barPlot <- renderPlotly({
    data <- selected_data()
    
    total_installations <- data %>%
      group_by(state) %>%
      summarise(total_installations = sum(number_of_installations, na.rm = TRUE)) %>%
      ungroup()
    
    overall_total <- sum(installations_data$number_of_installations)
    
    total_installations <- total_installations %>%
      mutate(`Total Percentage of Contribution` = round((total_installations / overall_total) * 100, 2))
    
    p <- ggplot(total_installations, aes(x = state, y = total_installations, fill = state, 
                                         text = paste("Installations:", total_installations, 
                                                      "<br>Total % Contribution:", `Total Percentage of Contribution`, "%"))) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Total Installations by Region", y = "Number of Installations", x = "Region") +
      scale_fill_manual(values = state_palette(unique(total_installations$state))) +
      scale_y_continuous(labels = scales::comma) +
      theme(legend.position = "none")  # Remove legend from the bar plot
    
    ggplotly(p, tooltip = "text")
  })
  
  # Render insight table
  output$insightTable <- renderDataTable({
    selected_regions <- input$selectedRegions
    
    if (length(selected_regions) < 2) {
      return(data.frame(Message = "Please select at least two regions to view the insight table"))
    }
    
    total_installations <- installations_data %>%
      filter(state %in% selected_regions) %>%
      group_by(state) %>%
      summarise(total_installations = sum(number_of_installations, na.rm = TRUE)) %>%
      ungroup()
    
    overall_total <- sum(installations_data$number_of_installations)
    
    insight_table <- expand.grid(Region1 = as.character(total_installations$state), Region2 = as.character(total_installations$state)) %>%
      filter(as.character(Region1) != as.character(Region2)) %>%
      rowwise() %>%
      mutate(`Region1 Installations` = total_installations$total_installations[match(Region1, total_installations$state)],
             `Region2 Installations` = total_installations$total_installations[match(Region2, total_installations$state)],
             `Difference Count` = abs(`Region1 Installations` - `Region2 Installations`),
             `Percentage Difference` = round(abs(`Region1 Installations` - `Region2 Installations`) / 
                                               ((`Region1 Installations` + `Region2 Installations`) / 2) * 100, 2)) %>%
      filter(`Region1 Installations` > `Region2 Installations`) %>%
      select(Region1, Region2, `Difference Count`, `Percentage Difference`)
    
    datatable(insight_table, options = list(
      pageLength = 10,
      lengthChange = FALSE,
      dom = 'tip',  # Removes the length menu and only shows table, information, and pagination
      language = list(search = "Search:")
    ), rownames = FALSE,
    colnames = c("Region 1", "Region 2", "Difference Count", "Percentage Difference (%)"))
  })
  
  
  # Load and prepare data for time series
  energy_stats_path <- "Australian_Energy_Statistics_2023_Table_C.xlsx"
  energy_sheets <- excel_sheets(energy_stats_path)
  energy_consumption <- read_excel(energy_stats_path, sheet = energy_sheets[1])
  
  energy_consumption <- rename(energy_consumption, Financial_year = names(energy_consumption)[1])
  
  # Correctly handle the Financial_year column
  energy_consumption_long <- energy_consumption %>%
    pivot_longer(cols = -Financial_year, names_to = "State", values_to = "Non_Renewable_Consumption") %>%
    mutate(Year = as.numeric(substr(Financial_year, 1, 4)))  # Extract the first year number
  
  # Calculate advanced metrics for historical data
  energy_consumption_long <- energy_consumption_long %>%
    arrange(State, Year) %>%
    group_by(State) %>%
    mutate(
      Past_Year_Change = (Non_Renewable_Consumption - lag(Non_Renewable_Consumption, 1)) / lag(Non_Renewable_Consumption, 1) * 100,
      Past_5_Years_Change = (Non_Renewable_Consumption - lag(Non_Renewable_Consumption, 5)) / lag(Non_Renewable_Consumption, 5) * 100
    )
  
  # Apply ARIMA to forecast for each state including Australia
  forecast_data <- energy_consumption_long %>%
    group_by(State) %>%
    do({
      ts_data <- ts(.$Non_Renewable_Consumption, start = min(.$Year), frequency = 1)
      fit <- auto.arima(ts_data)
      forecasted <- forecast(fit, h = 5)
      data.frame(Year = seq(max(.$Year) + 1, max(.$Year) + 5), 
                 Non_Renewable_Consumption = as.numeric(forecasted$mean),
                 State = unique(.$State))
    })
  
  # Combine historical and forecast data for plotting
  plot_data <- bind_rows(energy_consumption_long, forecast_data)
  
  # Calculate advanced metrics for forecast data
  plot_data <- plot_data %>%
    arrange(State, Year) %>%
    group_by(State) %>%
    mutate(
      Past_Year_Change = (Non_Renewable_Consumption - lag(Non_Renewable_Consumption, 1)) / lag(Non_Renewable_Consumption, 1) * 100,
      Past_5_Years_Change = (Non_Renewable_Consumption - lag(Non_Renewable_Consumption, 5)) / lag(Non_Renewable_Consumption, 5) * 100
    )
  
  # Load the data
  nodes <- read.csv("sankey_nodes_transformed.csv")
  links <- read.csv("sankey_links_transformed.csv")
  
  # Ensure node names are character type
  nodes$name <- as.character(nodes$name)
  
  # Define node groups
  node_groups <- c("Energy Source", "Energy Source", "Energy Source", "Energy Source", 
                   "Country", "State", "State", "State", "State", "State", "State", "State")
  
  # Add group column to nodes
  nodes <- nodes %>%
    mutate(group = node_groups)
  
  # Map node indices to names and groups
  links <- links %>%
    mutate(from = nodes$name[source + 1], to = nodes$name[target + 1])
  
  # Calculate total values for each node
  node_values <- links %>%
    gather(key = "type", value = "node", from, to) %>%
    group_by(node) %>%
    summarise(total_value = sum(value)) %>%
    arrange(desc(total_value))
  
  # Reorder nodes based on their total values
  nodes <- nodes %>%
    mutate(name = factor(name, levels = node_values$node)) %>%
    arrange(name)
  
  links <- links %>%
    mutate(from = factor(from, levels = levels(nodes$name)),
           to = factor(to, levels = levels(nodes$name))) %>%
    arrange(from, to)
  
  # Function to calculate percentages and prepare sankey data
  calculate_percentages <- function(links) {
    source_totals <- links %>%
      group_by(from) %>%
      summarise(total_value = sum(value))
    
    target_totals <- links %>%
      group_by(to) %>%
      summarise(total_value = sum(value))
    
    links <- links %>%
      left_join(source_totals, by = "from", suffix = c("", "_source")) %>%
      left_join(target_totals, by = "to", suffix = c("", "_target")) %>%
      mutate(
        percentage_from = value / total_value * 100,
        percentage_to = value / total_value_target * 100
      )
    
    links
  }
  
  # Prepare the data in the required format for highcharter
  prepare_sankey_data <- function(links) {
    lapply(1:nrow(links), function(i) {
      list(
        from = as.character(links$from[i]),
        to = as.character(links$to[i]),
        weight = links$value[i],
        percentage_to = links$percentage_to[i]
      )
    })
  }
  
  
  # Reactive value to toggle between historical and prediction data
  display_data <- reactiveVal("historical")
  
  # Generate the year slider based on the data range
  output$yearSlider <- renderUI({
    if (display_data() == "historical") {
      min_year <- min(energy_consumption_long$Year)
      max_year <- max(energy_consumption_long$Year)
    } else {
      min_year <- min(plot_data$Year)
      max_year <- max(plot_data$Year)
    }
    sliderInput("yearRange", "Select Year Range", min = min_year, max = max_year, 
                value = c(min_year, max_year), step = 1, sep = "")
  })
  
  # Update the plot based on the selected data and year range
  output$energyPlot <- renderPlotly({
    req(input$yearRange)  # Ensure yearRange input is available before proceeding
    
    if (display_data() == "historical") {
      data_to_plot <- energy_consumption_long
    } else {
      data_to_plot <- plot_data
    }
    
    data_to_plot <- data_to_plot %>%
      filter(Year >= input$yearRange[1] & Year <= input$yearRange[2])
    
    # Tooltip text
    tooltip_text <- if (input$showAdvanced) {
      ~paste("State:", State, "<br>Year:", Year, "<br>Consumption:", Non_Renewable_Consumption,
             "<br>Past Year Change:", ifelse(is.na(Past_Year_Change), "N/A", paste0(round(Past_Year_Change, 2), "%")),
             "<br>Past 5 Years Change:", ifelse(is.na(Past_5_Years_Change), "N/A", paste0(round(Past_5_Years_Change, 2), "%")))
    } else {
      ~paste("State:", State, "<br>Year:", Year, "<br>Consumption:", Non_Renewable_Consumption)
    }
    
    p <- plot_ly(data = data_to_plot, x = ~Year, y = ~Non_Renewable_Consumption, color = ~State, type = 'scatter', mode = 'lines', text = tooltip_text, hoverinfo = 'text') %>%
      layout(
        title = "Non-Renewable Energy Consumption Trends by State and National Level in Australia",
        xaxis = list(title = "Year"),
        yaxis = list(title = "Energy Consumption (PJ)")
      )
    
    if (display_data() == "predictions") {
      max_year <- max(energy_consumption_long$Year)
      p <- p %>%
        layout(
          shapes = list(
            list(
              type = "line",
              x0 = max_year,
              x1 = max_year,
              y0 = min(data_to_plot$Non_Renewable_Consumption, na.rm = TRUE),
              y1 = max(data_to_plot$Non_Renewable_Consumption, na.rm = TRUE),
              line = list(color = "black", dash = "dash")
            )
          )
        )
    }
    
    p$elementId <- NULL  # Remove elementId to avoid issues with shiny
    p
  })
  
  # Toggle data display on button click
  observeEvent(input$showHistorical, {
    display_data("historical")
  })
  
  observeEvent(input$showPredictions, {
    display_data("predictions")
  })
  
  # Reactive values to store filtered data and state stack
  reactive_links <- reactiveVal(calculate_percentages(links))
  state_stack <- reactiveVal(list(list(links = links, click_info = NULL)))
  
  output$sankeyPlot <- renderHighchart({
    highchart() %>%
      hc_add_series(
        type = "sankey",
        data = prepare_sankey_data(reactive_links()),
        name = "Sankey Series",
        tooltip = list(
          pointFormat = '<b>{point.fromNode.name}</b> → <b>{point.toNode.name}</b>: {point.weight} PJ ({point.percentage_to:.2f}%)'
        ),
        dataLabels = list(
          enabled = TRUE,
          align = "center",
          verticalAlign = "bottom",
          inside = FALSE,
          style = list(fontSize = "10px", color = "black")
        )
      ) %>%
      hc_title(text = "Energy Consumption Distribution in Australia 2021") %>%
      hc_chart(
        backgroundColor = "white",
        style = list(
          fontFamily = "Arial, sans-serif"
        )
      ) %>%
      hc_plotOptions(
        series = list(
          point = list(
            events = list(
              click = JS("function(event) {
                           var isNode = this.to === undefined;  // If `to` is undefined, it's a node
                           var clickInfo;
                           if (isNode) {
                             clickInfo = {type: 'node', name: this.name};
                           } else {
                             clickInfo = {type: 'link', from: this.from, to: this.to};
                           }
                           Shiny.setInputValue('click_info', clickInfo, {priority: 'event'});
                         }")
            )
          )
        )
      )
  })
  
  observeEvent(input$click_info, {
    click_info <- input$click_info
    
    if (!is.null(click_info)) {
      current_state <- list(links = reactive_links(), click_info = click_info)
      stack <- state_stack()
      
      # Check if the same element is clicked again to revert to the previous state
      if (length(stack) > 1 && identical(click_info, stack[[length(stack)]][["click_info"]])) {
        # Pop the previous state from the stack
        stack <- stack[-length(stack)]
        state_stack(stack)
        reactive_links(stack[[length(stack)]][["links"]])
        output$clickInfo <- renderPrint({
          "Returned to previous state"
        })
      } else {
        # Push the current state to the stack
        state_stack(c(stack, list(current_state)))
        
        if (click_info$type == "node") {
          node_name <- click_info$name
          
          filtered_links <- links %>% filter(from == node_name | to == node_name)
          reactive_links(filtered_links)
          output$clickInfo <- renderPrint({
            paste("Clicked node:", node_name)
          })
          
        } else if (click_info$type == "link") {
          from_node <- click_info$from
          to_node <- click_info$to
          
          filtered_links <- links %>% filter(from == from_node & to == to_node)
          
          reactive_links(filtered_links)
          output$clickInfo <- renderPrint({
            paste("Clicked link from", from_node, "to", to_node)
          })
        }
      }
    }
  })
  
  # Show Help modal for Trend Plot
  observeEvent(input$showHelpTrendModal, {
    showModal(modalDialog(
      title = "Trend Plot Help",
      HTML("<b>Help Guide:</b><br>
            <ul>
              <li><b>Select Plot Type:</b> Choose between historical data and predictions.</li>
              <li><b>Select Year Range:</b> Adjust the year range for the data to display.</li>
              <li><b>Show Comparison Metrics:</b> Check to display percentage change year over year and cumulative installations.</li>
            </ul>"),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Show Help modal for Sankey Diagram
  observeEvent(input$showHelpSankeyModal, {
    showModal(modalDialog(
      title = "Sankey Diagram Help",
      HTML("<b>Help Guide:</b><br>
            <ul>
              <li>The Sankey diagram displays the flow of energy consumption from sources to states.</li>
              <li>Click on a node to highlight the links connected to it.</li>
              <li>Click on a link to see detailed information about the flow between the connected nodes.</li>
              <li>Click on the same element again to revert to the previous state.</li>
            </ul>"),
      easyClose = TRUE,
      footer = NULL
    ))
  })
}

# Custom addLegend function with clickable items
addLegendCustom <- function(map, position, pal, values, title, opacity = 0.7) {
  legend_html <- paste0(
    "<div class='info legend'>",
    "<div class='legend-title'>", title, "</div>"
  )
  
  for (value in values) {
    color <- pal(value)
    legend_html <- paste0(
      legend_html,
      "<div class='legend-item' data-value='", value, "'>",
      "<i style='background:", color, "; opacity:", opacity, ";'></i> ",
      value,
      "</div>"
    )
  }
  
  legend_html <- paste0(legend_html, "</div>")
  
  map %>% addControl(html = legend_html, position = position)
}


shinyApp(ui, server)
