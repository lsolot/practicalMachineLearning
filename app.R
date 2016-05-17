#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
data(mtcars)
mtcars$am <- factor(mtcars$am)
levels(mtcars$am) <- c("Automatic", "Manual")
pred <- lm(mpg ~ wt + hp + am, data = mtcars)
summary(pred)


# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("MPG Prediction Using mtcars Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         # sliderInput("bins",
         #             "Number of bins:",
         #             min = 1,
         #             max = 50,
         #             value = 30)
         sliderInput("wt",
                     "Weight of Car (1000 lbs.):",
                     min = 1,
                     max = 6,
                     value = 3,
                     step = .01),
         sliderInput("hp",
                     "Horsepower:",
                     min = 25,
                     max = 500,
                     value = 50,
                     step = 1),
         selectInput("am",
                     "Transmission Type: ",
                     choices = c("Automatic", "Manual"))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        h4("Predicted MPG: "),
         #plotOutput("distPlot")
        verbatimTextOutput("mpg"),
        h4("Use the table below to see how well the prediction worked:"),
        tableOutput("mycars")
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
   
   # output$distPlot <- renderPlot({
   #    # generate bins based on input$bins from ui.R
   #    x    <- faithful[, 2] 
   #    bins <- seq(min(x), max(x), length.out = input$bins + 1)
   #    
   #    # draw the histogram with the specified number of bins
   #    hist(x, breaks = bins, col = 'darkgray', border = 'white')
   # })
    output$mpg <- renderText({ 
    round(predict(pred, newdata = data.frame(wt = input$wt, 
                                       hp = input$hp,
                                       am = input$am)), 2)
    })
    output$mycars <- renderTable({ mtcars })
})

# Run the application 
shinyApp(ui = ui, server = server)

