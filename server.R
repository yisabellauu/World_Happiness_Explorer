library(shiny)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(plotly)
library(broom)

server <- function(input, output, session) {
  
# 1.Happiness Trend Plot

    output$trendPlot <- renderPlotly({
    req(input$country)
    
    trend_data <- model_data %>%
      filter(Country.name == input$country)
    
    p <- ggplot(trend_data, aes(x = year, y = Life.Ladder)) +
      geom_line(linewidth = 1) +
      geom_point(size = 2) +
      labs(
        title = paste("Happiness Trend (Life Ladder):", input$country),
        x = "Year",
        y = "Life Ladder Score"
      ) +
      theme_minimal()
    
    ggplotly(p)
  })
  
# 2.Predictor Relationship Plot
    output$relationshipPlot <- renderPlotly({
      req(input$predictor)
      
      pred_label <- names(var_labels)[var_labels == input$predictor]
      
      p <- model_data %>%
        ggplot(aes(
          x = .data[[input$predictor]],
          y = Life.Ladder,
          color = year, 
          text = paste(
            "Country:", Country.name,
            "<br>Year:", year,
            "<br>Happiness:", round(Life.Ladder, 2),
            "<br>", pred_label, ":", round(.data[[input$predictor]], 2)
          )
        )) +
        geom_point(alpha = 0.7, size = 2) +
        geom_smooth(method = "lm", color = "#e74c3c", se = TRUE, inherit.aes = FALSE, 
                    aes(x = .data[[input$predictor]], y = Life.Ladder)) + 
        scale_color_viridis_c(option = "viridis", name = "Year") + 
        labs(
          title = paste("Happiness vs.", pred_label),
          x = pred_label,
          y = "Life Ladder Score"
        ) +
        theme_minimal()
      
      ggplotly(p, tooltip = "text")
    })
  
# 3.PCA outputs
  output$pcaPlot <- renderPlotly({
    p <- ggplot(pca_scores, aes(
      x = PC1,
      y = PC2,
      text = paste("Country:", Country, "<br>Year:", Year)
    )) +
      geom_point(alpha = 0.5, color = "#2ecc71") +
      labs(
        title = "PCA Score Plot (PC1 vs PC2)",
        x = "Principal Component 1",
        y = "Principal Component 2"
      ) +
      theme_minimal()
    
    ggplotly(p, tooltip = "text")
  })
  
  output$variancePlot <- renderPlotly({
    p <- ggplot(variance, aes(x = PC, y = Variance)) +
      geom_col(fill = "#34495e") +
      scale_y_continuous(labels = scales::percent) +
      labs(
        title = "Variance Explained by Principal Components",
        x = NULL,
        y = "Explained Variance (%)"
      ) +
      theme_minimal()
    
    ggplotly(p)
  })
  
  output$loadingPlot <- renderPlotly({
    loading_plot <- loadings %>%
      select(Variable, PC1, PC2) %>%
      pivot_longer(cols = c(PC1, PC2), names_to = "Component", values_to = "Loading")
    
    p <- ggplot(loading_plot, aes(
      x = Loading,
      y = reorder(Variable, Loading),
      text = paste("Variable:", Variable, "<br>Component:", Component, "<br>Loading:", round(Loading, 3))
    )) +
      geom_col(fill = "#9b59b6") +
      facet_wrap(~Component) +
      labs(title = "PCA Variable Loadings", x = "Loading Coefficient", y = NULL) +
      theme_minimal()
    
    ggplotly(p, tooltip = "text")
  })
  
# 4. Regression 
  dynamic_model <- reactive({
    req(input$reg_predictors)
    
    validate(
      need(length(input$reg_predictors) > 0, "Please select at least one predictor variable from the sidebar.")
    )
    
    std_data <- model_data %>%
      mutate(across(all_of(variables), scale))
    
    formula_str <- paste("Life.Ladder ~", paste(input$reg_predictors, collapse = " + "))
    
    lm(as.formula(formula_str), data = std_data)
  })
  
  output$coefPlot <- renderPlotly({
    model <- dynamic_model()
    
    coef_data <- tidy(model, conf.int = TRUE) %>%
      filter(term != "(Intercept)")
    
    p <- ggplot(coef_data, aes(
      x = estimate,
      y = reorder(term, estimate),
      text = paste("Predictor:", term, "<br>Standardized Beta:", round(estimate, 3), "<br>p-value:", format.pval(p.value))
    )) +
      geom_point(size = 3, color = "#2980b9") +
      geom_errorbar(aes(xmin = conf.low, xmax = conf.high), width = 0.2, color = "#2980b9") +
      geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
      labs(
        title = "Dynamic Standardized Regression Coefficients (β)",
        x = "Standardized Coefficient Estimate (β)",
        y = NULL
      ) +
      theme_minimal()
    
    ggplotly(p, tooltip = "text")
  })
  
  output$regSummaryTable <- renderTable({
    model <- dynamic_model()
    tidy(model) %>%
      mutate(
        estimate = round(estimate, 3),
        std.error = round(std.error, 3),
        statistic = round(statistic, 3),
        p.value = format.pval(p.value, digits = 3)
      )
  })
}