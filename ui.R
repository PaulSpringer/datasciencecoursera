#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that predicts Tooth growth for pigs based on dose
# and delivery method of Vitamin C
shinyUI(fluidPage(

    # Application title
    titlePanel("Tooth Growth for Pigs in dependence on Vitamin C"),

    # Sidebar with a slider input for considered Vitamin C dose
    sidebarLayout(
        sidebarPanel(
            sliderInput("sliderDose",
                        "Considered Dose:",
                        min = 0.5,
                        max = 2,
                        value = 1),
            radioButtons("RadioButton", "Regression model for the fit:",
                         choiceNames = c("Linear Model", "Quadratic Model"),
                         choiceValues = c("LinModel", "QuadModel")),
            h4("Options:"),
            checkboxInput("showData", "Show/Hide data points",
                          value = TRUE),
            checkboxInput("showModelOJ", "Show/Hide model for orange juice (OJ)",
                          value = TRUE),
            checkboxInput("showModelVC", "Show/Hide model for ascorbic acid (VC)",
                          value = TRUE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs",
                         tabPanel("Output", br(),
                                  plotOutput("ToothData"),
                                  h3("Overview Predictions"),
                                  div(tableOutput("pred_table"),
                                      style = "font-size:150%")),
                         tabPanel("Documentation", br(), 
                                  h2("Documentation for the App"),
                                  h3("General"),
                                  "This App allows the user to predict
                                  tooth growth of a pig depending on the dosage
                                  of vitamin C and on the delivery method of
                                  vitamin C. Two delivery methoda are considered:
                                  OJ - orange juice and VC - ascorbin acid.
                                  The data are taken from standard R data set
                                  ToothGrowth.",
                                  h3("Input"),
                                  h4("Considered Dose"),
                                  "The user can choose a dosage of vitamin C in
                                  order to predict corresponding expected tooth
                                  growth. Input is made via a slider.",
                                  h4("Regression model for the fit"),
                                  "The user can decide between linear or quadratic
                                  regression model (via radio button).",
                                  h4("Options"),
                                  "1. A check box to show or hide data points.", br(),
                                  "2. A check box to show or hide predicted model
                                  for orange juice.", br(),
                                  "3. A check box to show or hide predicted model
                                  for ascorbin acis.",
                                  h3("Output"),
                                  h4("Plot"),
                                  "As first output the user see a plot which
                                  contains:", br(),
                                  "1. Data points from ToothGrowth data set - Dose
                                  of Vitamin C on x-axis and Tooth length on
                                  y-axis. Different colors decode various delivery methods.",
                                  br(),
                                  "2. Two regression curves for two
                                  delivery methods. Shape of the curves depends
                                  on chosen regression model (linear or quadratic).",
                                  br(),
                                  "3. Two large points along regression curves
                                  which correspond to chosen considered dose.",
                                  h4("Overview Predictions"),
                                  "A table which contains predictions for all
                                  models and all delivery methods depending on
                                  considered dose.")
                        )
        )
    )
))
