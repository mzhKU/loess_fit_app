#!/usr/bin/Rscript

library(shiny)

n_loess <- 10
span_value <- 0.2

shinyUI(
    pageWithSidebar(
        headerPanel("Loess Fit"),
        sidebarPanel(
            h3("Description"),
            p("This Shiny application allows to fit a number of Loess functions to
               a set of temperature/ozone value pairs."),
            p("By adjusting the parameters, the user can see the effect of
               the 'span' parameter and number of Loess fits on the total fit."),
            
            h3("Parameters"),

            # Number of Loess samples
            numericInput("n_loess", "Number of Loess Samples (max: 40)",
                         n_loess, min=1, max=80, step=1
            ),
            # Span value for Loess fit
            numericInput("span_value", "Span value",
                         span_value, min=0.01, max=1.0, step=0.01
            )
        ),
        mainPanel(
            # Formatting
            h3("Loess Fitting."),
            tabsetPanel(
                # Plots
                tabPanel("Loess Plot", 
                    plotOutput("loess_plot")
                ),
                # Table
                tabPanel("Loess Table",
                    tableOutput("loess_matrix")
                )
            )
        )
    )
)
