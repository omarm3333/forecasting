---
title       : Stock Exchange Forecasting
subtitle    : Weekly forecast model application
author      : Omar Marquina
job         : Data Scientist
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Overview
This application builds a forcast model and predicts 3 weeks ahead of closing stock prices.

Data is collected from Google on-line data base and US Stock Exchange symbols are used.
N number of past months to build the model can be selected.

Results in forecasting plot, model summary, accuracy and forcasted values for the next 3 weeks.

To have acces to live application go to:

http://omarm33.shinyapps.io/Assignment/

--- .class #id

## Application Screen Shot

![Application Screen Shot](assets/img/app.png)

---

## Fcasting Class
The application creates a class **Fcasting** to collect all information regarding source data, the fit model and the forcasting.

A **plot** method is added to manage Fcasting class' plotting.

```r
setClass("Fcasting", representation (
  symbol    = "character", 
  forecast  = "forecast",
  from.date = "Date",
  to.date   = "Date",
  valid     = "logical"))
setMethod("plot","Fcasting", function(x, ...){
  plot(x@forecast, xlab="Weeks", ylab=paste(x@symbol,
  " Price ($)"), main = "3 Weeks Forecast")
})
fcast <<- new("Fcasting")
```

---
 
## Data Collect and Model Fitting
Symbol data is collected from Google on-line database and translated into time series with 7 days periods.

Fit model uses multiplicatives error, trend and season types (**MMM**). The forcast is for 21 days (3 weeks) after yesterday closing prices.



```r
stock.values <- getSymbols(symbol, 
  src  ="google", 
  from = fcast@from.date, 
  to   = fcast@to.date, auto.assign = FALSE)

ts1     <- ts(Cl(stock.values), frequency = 7)
ets.all <- ets(ts1, model = "MMM")
fcast@forecast <<- forecast(ets.all, h=21)
```

---

## Fcasting Results
The application results is the plot of the model data and the summary of the forecasting, including accurracy and 21 days of the forecast values.


```r
plot(fcast)
```

![plot of chunk plotting](assets/fig/plotting-1.png)



