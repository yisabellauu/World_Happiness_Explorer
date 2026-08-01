library(shiny)
library(bslib)
library(plotly)

ui <- page_sidebar(
  title = "World Happiness Explorer",
  
  sidebar = sidebar(
    
    #  1: Trend 
    conditionalPanel(
      condition = "input.nav_tabs == 'Trend'",
      h5("Trend Controls"),
      selectInput(
        "country",
        "Select Country:",
        choices = unique(model_data$Country.name),
        selected = "United States"
      ),
      p(class = "text-muted", "Select a country to observe its temporal happiness trajectory.")
    ),
    
    #  2: Predictor Relationship 
    conditionalPanel(
      condition = "input.nav_tabs == 'Predictor Relationship'",
      h5("Predictor Controls"),
      selectInput(
        "predictor",
        "Select Predictor Variable (X-axis):",
        choices = var_labels
      )
    ),
    
    #  3: PCA Analysis 
    conditionalPanel(
      condition = "input.nav_tabs == 'PCA Analysis'",
      h5("PCA Controls"),
      p("PCA reduces the 6 socio-economic predictors into principal components."),
      p(class = "text-muted", "Use hover in the plots to inspect individual country-years.")
    ),
    
    #  4: Dynamic Regression 
    conditionalPanel(
      condition = "input.nav_tabs == 'Regression Insights'",
      h5("Dynamic Model Controls"),
      checkboxGroupInput(
        "reg_predictors",
        "Select Features for Regression:",
        choices = var_labels,
        selected = unname(var_labels)
      ),
      helpText("Check/uncheck variables to refit the standardized linear model dynamically.")
    )
  ),
  
  #  - Tabs 
  navset_tab(
    id = "nav_tabs",
    
    # --- TAB 1: TREND ---
    nav_panel(
      "Trend",
      card(
        card_header("Instructions"),
        p("Explore how national happiness (Life Ladder) changes over time (2008–2022). Select different countries in the sidebar.")
      ),
      plotlyOutput("trendPlot")
    ),
    
    # --- TAB 2: PREDICTOR RELATIONSHIP ---
    nav_panel(
      "Predictor Relationship",
      card(
        card_header("Instructions"),
        p("Examine bivariate linear relationships between Happiness and specific predictors. Hover over data points to see Country and Year details.")
      ),
      plotlyOutput("relationshipPlot")
    ),
    
    # --- TAB 3: PCA ANALYSIS ---
    nav_panel(
      "PCA Analysis",
      card(
        card_header("Instructions"),
        p("Dimensionality reduction using Principal Component Analysis (PCA). Understand variable correlations and major latent axes.")
      ),
      layout_column_wrap(
        width = 1/2,
        plotlyOutput("pcaPlot"),
        plotlyOutput("variancePlot")
      ),
      hr(),
      h4("Variable Contributions (Loadings)"),
      plotlyOutput("loadingPlot")
    ),
    
    # --- TAB 4: DYNAMIC REGRESSION ---
    nav_panel(
      "Regression Insights",
      card(
        card_header("Instructions"),
        p("Dynamically fit a Multiple Linear Regression model with standardized features (Z-scores). Compare normalized Beta coefficients and confidence intervals across selected features.")
      ),
      plotlyOutput("coefPlot"),
      hr(),
      h4("Model Summary Table"),
      tableOutput("regSummaryTable")
    )
  )
)