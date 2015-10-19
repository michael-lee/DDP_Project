library(shiny)
library(HistData)
library(dplyr)
library(ggplot2)
data(GaltonFamilies)

gf <- GaltonFamilies
gf <- gf %>% mutate(father=father*2.54,
                    mother=mother*2.54,
                    childHeight=childHeight*2.54)

regmod <- lm(childHeight ~ father + mother + gender, data=gf)

shinyServer(function(input, output) {
    output$parentsText <- renderText({
        paste(strong("Input:"),
              "<br/>",
              "Father's Height: ",
              strong(round(input$inFh, 1)),
              "cm",
              "<br/>",
              "Mother's Height: ",
              strong(round(input$inMh, 1)),
              "cm",
              "<br/><br/>")
    })
    output$prediction <- renderText({
        df <- data.frame(father=input$inFh,
                        mother=input$inMh,
                        gender=factor(input$inGen, levels=levels(gf$gender)))
        ch <- predict(regmod, newdata=df)
        sord <- ifelse(
            input$inGen=="female",
            "Daugther",
            "Son"
        )
        paste0(strong("Prediction:"),
               "<br/>",
               sord,
               "'s Height: ",
               strong(round(ch, 1)),
               " cm")
    })
    output$barsPlot <- renderPlot({
        sord <- ifelse(
            input$inGen=="female",
            "Daugther",
            "Son"
        )
        df <- data.frame(father=input$inFh,
                         mother=input$inMh,
                         gender=factor(input$inGen, levels=levels(gf$gender)))
        ch <- predict(regmod, newdata=df)
        yvals <- c("Father", sord, "Mother")
        df <- data.frame(
            x = factor(yvals, levels = yvals, ordered = TRUE),
            y = c(input$inFh, ch, input$inMh),
            colors = c(NA, "red", NA)
        )
        ggplot(df, aes(x=x, y=y, color=colors, fill=colors)) +
               geom_bar(stat="identity", width=0.5) +
               xlab("") +
               ylab("Height (cm)") +
               ylim(0, 200) +
               theme_minimal() +
               theme(legend.position="none")
    })
})