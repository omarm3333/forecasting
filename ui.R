library(shiny)
shinyUI(pageWithSidebar(
        headerPanel("Stocks Market Forecasting"),
        sidebarPanel(
                p('This application builds a forcast model and predicts 3 weeks ahead of closing stock prices.'),
                p('Data is collected from Google on-line data base and US Stock Exchange symbols are used.'),
                p('Past months to build the model can be selected.'),
                textInput('stock', 'Stock Exchange Symbol:', placeholder = 'GOOG'),
                numericInput('period', 'Number of months to build model:', value = 12),
                actionButton('goButton', 'Submit'),
                p("Please input stock symbol and period, and press Submit"),
                p("Results in forecasting plot, model summary, accuracy and forcasted values for the next 3 weeks.")
        ),
        mainPanel(
                h3('Forecasting Results - Weekly Periods'),
                h4('Forecast Plot '),
                verbatimTextOutput("dates"),
                plotOutput("plot"),
                h4('Forecast Summary'),
                verbatimTextOutput("forecast")
        )
))