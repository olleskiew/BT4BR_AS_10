# ui.R

library(shiny)
library(readr)
library(tidyr)
library(dplyr)

# — wczytanie i przekształcenie danych (to samo co w server.R) —
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

# — definicja interfejsu —
fluidPage(
  titlePanel("The expression of chosen gene across samples"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "genes_ids",
        label   = "Choose Gene ID:",
        choices = unique(dane_long$GeneID)
      )
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)
