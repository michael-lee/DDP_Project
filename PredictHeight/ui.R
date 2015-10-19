library(shiny)

shinyUI(fluidPage(
    navbarPage("PredictHeight",
        tabPanel("Home",
            sidebarLayout(
                sidebarPanel(
                    helpText("Instructions"),
                    helpText("Father's Height: Input the father's known
                             height using the slider."),
                    helpText("Mother's Height: Input the mother's known
                             height using the slider."),
                    helpText("Child's Gender: Select the gender of the child
                             that you would like the height predicted."),
                    sliderInput(inputId = "inFh",
                                 label = "Father's Height (cm):",
                                 value = 175,
                                 min = 150,
                                 max = 200),
                    sliderInput(inputId = "inMh",
                                 label = "Mother's Height (cm):",
                                 value = 175,
                                 min = 150,
                                 max = 200),
                    radioButtons(inputId = "inGen",
                                 label = "Child's Gender: ",
                                 choices = c("Female"="female", "Male"="male"),
                                 inline = TRUE)
                ),
                mainPanel(
                    htmlOutput("parentsText"),
                    htmlOutput("prediction"),
                    plotOutput("barsPlot", width = "80%")
                )
            )
        ),
        tabPanel("About",
            mainPanel(
                column(12,
                       includeHTML("about.html"))
            )
        )
    )
))
