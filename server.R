# server.R

library(shiny)
library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)

# — wczytanie i przekształcenie danych (powtórzone z ui.R) —
dane <- read.csv("C:/Users/Laptop/Desktop/Studia/III ROK/VI semestr/T4BR/Exercises_session_6/work_files/TPMs_table_100genes.csv")

dane_long <- dane %>% 
  pivot_longer(
    cols      = matches("Control|Treated"), 
    names_to  = "Sample", 
    values_to = "TPMs"
  ) %>% 
  separate(
    Sample, 
    sep   = "_", 
    into  = c("Condition", "Sample_number")
  )

# — logika serwera —
function(input, output, session) {
  
  data_sel <- reactive({
    subset(dane_long, GeneID == input$genes_ids)
  })
  
  output$distPlot <- renderPlot({
    ggplot(data_sel(), aes(
      x    = Sample_number,
      y    = TPMs,
      fill = Condition
    )) +
      geom_col(position = "dodge") +
      scale_fill_manual(
        values = c(
          "Treated" = "#FED789FF",
          "Control" = "#023743FF"
        )
      ) +
      ggtitle(paste("The expression of gene", input$genes_ids)) +
      theme_minimal()
  })
}
