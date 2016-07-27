
library (UsingR)
library(quantmod)
library(methods)
library(forecast)
library(lubridate)

# Define Class Fcasting
suppressWarnings(setClass("Fcasting", 
         representation (symbol    = "character", 
                         forecast  = "forecast",
                         from.date = "Date",
                         to.date   = "Date",
                         valid    = "logical"
         )
))

# Define plot method for Fcasting class
setMethod("plot","Fcasting",
          function(x, ...) {
                  plot(x@forecast, xlab="Weeks", ylab=paste(x@symbol," Price ($)"),
                       main = "3 Weeks Forecast"
                       )
          }
          )

# Build model and fill in object Fcasting
stock.Forecast <- function (symbol, period) {
        fcast@valid  <<- FALSE
        fcast@symbol <<- toupper(symbol)
        
        if(nchar(symbol[1]) < 3) return ("")

        # Time period to use for model build
        yesterday       <- Sys.Date() - days(1)
        fcast@from.date <<- yesterday - months(period)
        fcast@to.date   <<- yesterday

        # Get stock prices from google
        stock.values <- NULL
        
        # Try catching errors
        try(stock.values <- getSymbols(symbol, src="google", 
                                   from = fcast@from.date, 
                                   to = fcast@to.date, auto.assign = FALSE),
            silent = TRUE
        )
        
        # On empty return value, return
        if (is.null(stock.values)) {
                return()
        }
        
        # Valid returning results
        fcast@valid <<- TRUE
        
        # Forecast based on closing prices.
        # Convert to time series with weekly periods
        ts1 <- ts(Cl(stock.values), frequency = 7)
        
        # Build model and save it in object with 3 weeks forecast
        ets.all <- ets(ts1, model = "MMM")
        fcast@forecast <<- forecast(ets.all, h=21)
}


shinyServer(
        function(input, output) {
                fcast <<- new("Fcasting")
                fcast@valid <<- FALSE
                
                observeEvent(input$goButton, {
                        stock.Forecast(input$stock, input$period)
                })
                output$forecast <- renderPrint({input$goButton;
                        if (fcast@valid)
                                summary(fcast@forecast)
                        else if(input$goButton)
                                "Symbol not exists or communication error."
                        else 
                                "Input a Stock Market Symbol"
                        })
                output$plot <- renderPlot({
                        if(input$goButton & fcast@valid)
                                plot(fcast)
                        else
                                ""
                })
                output$dates <- renderText({
                        if(input$goButton & fcast@valid)
                                paste("Period", fcast@from.date, "to", fcast@to.date)
                        else
                                ""
                })
        }
)