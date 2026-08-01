# World Happiness & Socio-Economic Indicators Explorer

An end-to-end data science project analyzing global happiness trends (2008–2022). 
This project includes both an **interactive R Shiny application** and a **comprehensive statistical analysis report**.

## 🔗 Quick Links
- 🚀 **[Live Interactive Shiny App](https://yisabellauuu.shinyapps.io/World-Happiness-Explorer/)**
- 📄 **[Regression Report]()**

An interactive R Shiny application designed for exploring temporal happiness trends, analyzing bivariate relationships with socio-economic drivers, performing PCA dimensionality reduction, and dynamic linear regression modeling based on World Happiness Report data.

---
## Key Features
- **Trend Exploration**: Track happiness trajectory (`Life Ladder`) per country across years (2008–2022).
- **Interactive Scatter Plots**: Bivariate predictor analysis with custom feature coloring and hover-over metadata.
- **PCA Dimensionality Reduction**: Biplots, explained variance, and loading plots to identify latent dimensions.
- **Dynamic Regression**: Select custom predictor subsets to refit standardized linear models ($\beta$ coefficients & 95% CI) in real-time.


**R Packages**: `shiny`, `bslib`, `tidyverse`, `plotly`, `broom`

**Deployment**: shinyapps.io
