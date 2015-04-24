#!/usr/bin/Rscript

library(shiny)
library(ElemStatLearn)
data(ozone)

# **********************************
# Establish 'loess' data dimensions.
# **********************************
n_pred <- length(ozone[, 1])

shinyServer(
    function(input, output)
    {
        # First tab.
        # Graphics output, add button to download plot.
        output$loess_plot <- renderPlot({

            loess_functions <- matrix(NA, nrow=input$n_loess, ncol=n_pred)

            for(i in 1:nrow(loess_functions))
            {
                sample_set <- sample(1:n_pred, replace=TRUE)
                ozone_sampled <- ozone[sample_set, ]
                ozone_sampled_ordered <- ozone_sampled[order(ozone_sampled$ozone), ]
                loess_function_i <- loess(temperature ~ ozone,
                                       data=ozone_sampled_ordered,
                                       span=input$span_value, degree=1,
                                       na.action=na.omit)
                loess_functions[i, ] <- predict(loess_function_i,
                                          new_data=data.frame(ozone=1:n_pred))
            }
            plot(ozone$ozone, ozone$temperature,
                 pch=20, cex=1.5,
                 xlab="Ozone [ppm]", ylab="Temperature [F]"
            )
            for(i in 1:input$n_loess)
            {
                lines(1:n_pred, loess_functions[i, ],
                      col="grey", lwd=2)
            }
            lines(1:n_pred, apply(loess_functions, 2, mean, na.rm=TRUE),
                  col="red", lwd=5)
            # Second tab.
            # Raw data, add button to download raw dat.
            output$loess_matrix <- renderTable(loess_functions) 
        })
    }
)
