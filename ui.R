library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Power calculation to identify the cut-off discriminating high and low response group by IHC biomarker"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      tags$head(
        tags$style(type="text/css", "label.radio { display: inline-block; }", ".radio input[type=\"radio\"] { float: none; }"),
        tags$style(type="text/css", "select { max-width: 100px; }"),
        tags$style(type="text/css", "textarea { max-width: 100px; }"),
        tags$style(type="text/css", ".jslider { max-width: 100px; }"),
        tags$style(type='text/css', ".well { max-width: 710px; }"),
        tags$style(type='text/css', ".span4 { max-width: 210px; }")
      ),
      
      h2("Prevalence"),
      
      h4("Negative"),
      sliderInput("p0",
                  "Decimal",
                  min = 0,
                  max = 1,
                  value = 0.2),
      h4("Weak Positive"),
      sliderInput("p1",
                  "Decimal",
                  min = 0,
                  max = 1,
                  value = 0.4),
      h5("Strong Positive"),
      sliderInput("p2",
                  "Decimal",
                  min = 0,
                  max = 1,
                  value = 0.4),
      h2("Response Rate"),
      h5("Negative"),
      sliderInput("RRn",
                  "Decimal",
                  min = 0,
                  max = 1,
                  value = 0.1),
      h5("Weak Positive"),
      sliderInput("RRw",
                  "Decimal",
                  min = 0,
                  max = 1,
                  value = 0.2),
      h5("Strong Positive"),
      sliderInput("RRp",
                  "Decimal:",
                  min = 0,
                  max = 1,
                  value = 0.5),
      
      h3("Sample Size"),
      numericInput("n",
                   "Integal",
                   label = h6("Numeric input"),
                   value = 100),
     
      h3("Method"),
      radioButtons("method",
                   label = h5("Select Method"),
                   choices = list("Youden" = 1, 
                                  "minPvalue" = 2),selected = 1),
      h3("# of Permuation"),
      numericInput("B1",
                   "Integal",
                   label = h6("Numeric input"),
                   value = 500)
      
    
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h1("Power is  "),
      h1(textOutput("txt")),
      plotOutput("distPlot"),
      h2("Hypothesis: cut-off exists to classify subjects to higher response to lower response group. "),
      plotOutput("hypoPlot"),
      h5("The biomarker can be classified to negative (0), weak positive (<cut off), strong positive (>cut off) by IHC value. "),
      h5("The endpoint for this study is response rate. The Shiny apps for PFS and OS can be found here. "),
      h5("The power is determined by the prevalance and response rate of biomarker in each group, total sample size, # of permuation. "),
      h5("To simplify, the prevalance for each group is fixed."),
      h5("Maximizing Youden Index (recommended) and Minimizing the p-value for Chi-square statistics can be chosen to calculate the power.")
    )
  )
))

