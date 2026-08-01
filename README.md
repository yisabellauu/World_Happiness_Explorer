# World Happiness & Socio-Economic Indicators Explorer

Live-Demo: https://yisabellauuu.shinyapps.io/World-Happiness-Explorer/

An interactive R Shiny application designed for exploring temporal happiness trends, analyzing bivariate relationships with socio-economic drivers, performing PCA dimensionality reduction, and dynamic linear regression modeling based on World Happiness Report data.
---
## Key Features
- **Trend Exploration**: Track happiness trajectory (`Life Ladder`) per country across years (2008–2022).
- **Interactive Scatter Plots**: Bivariate predictor analysis with custom feature coloring and hover-over metadata.
- **PCA Dimensionality Reduction**: Biplots, explained variance, and loading plots to identify latent dimensions.
- **Dynamic Regression**: Select custom predictor subsets to refit standardized linear models ($\beta$ coefficients & 95% CI) in real-time.


**R Packages**: `shiny`, `bslib`, `tidyverse`, `plotly`, `broom`
**Deployment**: shinyapps.io
