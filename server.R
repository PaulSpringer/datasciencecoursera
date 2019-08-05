#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    # Libraries
    library(ggplot2)
    
    # Get data
    data("ToothGrowth")
    newData = data.frame(dose = seq(0.5, 2, 0.05))
    
    # Regression model inputs
    InputOJ <- ToothGrowth[ToothGrowth$supp == "OJ", ]
    InputVC <- ToothGrowth[ToothGrowth$supp == "VC", ]
    
    # Linear regression models
    modelOJ_lin <- lm(len ~ dose, data = InputOJ)
    modelVC_lin <- lm(len ~ dose, data = InputVC)
    
    # Quadratic regression models
    modelOJ_quad <- lm(len ~ dose + I(dose^2), data = InputOJ)
    modelVC_quad <- lm(len ~ dose + I(dose^2), data = InputVC)
    
    # Prediction for slider Input (considered dose)
    OJ_lin_pred_point <- reactive({
        considered_dose <- input$sliderDose
        predict(modelOJ_lin, newdata = data.frame(dose = considered_dose))
    })
    OJ_quad_pred_point <- reactive({
        considered_dose <- input$sliderDose
        predict(modelOJ_quad, newdata = data.frame(dose = considered_dose))
    })
    
    VC_lin_pred_point <- reactive({
        considered_dose <- input$sliderDose
        predict(modelVC_lin, newdata = data.frame(dose = considered_dose))
    })
    VC_quad_pred_point <- reactive({
        considered_dose <- input$sliderDose
        predict(modelVC_quad, newdata = data.frame(dose = considered_dose))
    })
    
    Pred_table <- reactive({
        result <- data.frame(OJ = c(OJ_lin_pred_point(), OJ_quad_pred_point()),
                             VC = c(VC_lin_pred_point(), VC_quad_pred_point()))
        result <- as.data.frame(cbind(Model = c("Linear", "Quadratic"), result))
        result
    })
    
    # Output Plot
    output$ToothData <- renderPlot({
        considered_dose <- input$sliderDose
        
        p <- ggplot(ToothGrowth, aes(x = dose, y = len, color = supp)) +
            ggtitle("Tooth length as function of dose by delivery method") + 
            theme(plot.title = element_text(size = 20, face = "bold")) +
            labs(x = "Dose of Vitamin C", y = "Tooth Length") +
            guides(color = guide_legend(title = 'Delivery\nMethod'))
        
        if(input$showData){
            p <- p + geom_point() 
        }
        
        if(input$showModelOJ & input$RadioButton == "LinModel"){
            p <- p + geom_line(data = newData,
                               aes(x = dose,
                                   y = predict(modelOJ_lin, newdata = newData)),
                               color = "#F8766D", size = 1.5) +
                geom_point(aes(x = considered_dose,
                               y = OJ_lin_pred_point()),
                           colour = "#F8766D", size = 7)
        }
        
        if(input$showModelOJ & input$RadioButton == "QuadModel"){
            p <- p + geom_line(data = newData,
                               aes(x = dose,
                                   y = predict(modelOJ_quad, newdata = newData)),
                               color = "#F8766D", size = 1.5) +
                geom_point(aes(x = considered_dose,
                               y = OJ_quad_pred_point()),
                           colour = "#F8766D", size = 7)
        }
        
        if(input$showModelVC & input$RadioButton == "LinModel"){
            p <- p + geom_line(data = newData,
                               aes(x = dose,
                                   y = predict(modelVC_lin, newdata = newData)),
                               color = "#00BFC4", size = 1.5) +
                geom_point(aes(x = considered_dose,
                               y = VC_lin_pred_point()),
                           colour = "#00BFC4", size = 7)
        }
        
        if(input$showModelVC & input$RadioButton == "QuadModel"){
            p <- p + geom_line(data = newData,
                               aes(x = dose,
                                   y = predict(modelVC_quad, newdata = newData)),
                               color = "#00BFC4", size = 1.5) +
                geom_point(aes(x = considered_dose,
                               y = VC_quad_pred_point()),
                           colour = "#00BFC4", size = 7)
        }
        
        print(p)

    })
    
    output$pred_table <- renderTable(Pred_table())

})
