library(shiny)

shinyUI(fluidPage(
  
  #titlePanel("Avtomobilizem v Evropi"),
  
  tabsetPanel(
      tabPanel(title = "Starost",
               sliderInput(inputId = "Leto",
                           label = "Izberi leto", sep = "",
                           value = 2010, min = 2000, max = 2015, step = 1),
               selectInput(inputId = "drzava",
                           label = "Država",
                           choices = unique(starost$Drzava),
                           multiple = FALSE),
               actionButton(inputId = "klik",
                            label = "Osveži"),
               plotOutput("graf")),
      
     tabPanel(title = "Teža", 
              sliderInput(inputId = "leto",
                          label = "Izberi leto", sep = "",
                          value = 2000, min = 2000, max = 2015, step = 1),
              selectInput(inputId = "drz",
                          label = "Država",
                          choices = unique(teza$Drzava),
                          multiple = FALSE),
              plotOutput("teza")
     ),
     
     tabPanel(title = "Goriva",
              selectInput(inputId = "izberi",
                          label = "Država",
                          choices = unique(goriva$Drzava),
                          multiple = FALSE),
              plotOutput("box")
       
     ),
     
     tabPanel(title = "Velikosti motorjev",
              sliderInput(inputId = "let",
                          label = "Izberi leto", sep = "", 
                          value = 2000, min = 2000, max = 2015, step = 1),
              selectInput(inputId = "cou",
                          label = "Država",
                          choices = unique(vrsta_motorja$Drzava),
                          multiple = FALSE),
              actionButton(inputId = "clic",
                           label = "Osveži"),
              plotOutput("wrap"))
     
    )
))
