library(shiny)

ui <- fluidPage(
  tabsetPanel(
    tabPanel(title = "Teža",
      selectInput(inputId = "drzava",
                  label = "Država",
                  choices = unique(teza$Drzava),
                  selected = "Finland",
                  multiple = FALSE),
      selectInput(inputId = "teza",
                  label = "Teža",
                  choices = unique(teza$Teza),
                  multiple = FALSE),
      plotOutput("graf"),
      tableOutput("pri")
    ),
    tabPanel(title = "Starost",
             selectInput(inputId = "drz",
                         label = "Država",
                         choices = unique(starost$Drzava),
                         selected = "Finland",
                         multiple = FALSE),
             selectInput(inputId = "starost",
                         label = "Starost",
                         choices = unique(starost$Starost),
                         multiple = FALSE),
             plotOutput("sta"),
             tableOutput("tab")
    ),
    tabPanel(title = "Goriva",
             selectInput(inputId = "d",
                         label = "Država",
                         choices = unique(goriva$Drzava),
                         selected = "Finland",
                         multiple = FALSE),
             selectInput(inputId = "gorivo",
                         label = "Gorivo",
                         choices = unique(goriva$Vrsta_goriva),
                         multiple = FALSE),
             plotOutput("gor"),
             tableOutput("gor1")
    ),
    tabPanel(title = "Vrste motorjev",
             selectInput(inputId = "drza",
                         label = "Država",
                         choices = unique(vrsta_motorja$Drzava),
                         selected = "Finland",
                         multiple = FALSE),
             selectInput(inputId = "motor",
                         label = "Motor",
                         choices = unique(vrsta_motorja$Motor),
                         multiple = FALSE),
             selectInput(inputId = "fuel",
                         label = "Gorivo",
                         choices = unique(vrsta_motorja$Vrsta_goriva),
                         multiple = FALSE),
             plotOutput("mot"),
             tableOutput("mot1")
    )
  )
  )



server <- function(input, output) {
  
  podatki <- reactive({teza %>% filter(Drzava == input$drzava, Teza == input$teza)})
  
  output$graf <- renderPlot({
    h <- ggplot(data = podatki(), aes(x=Leto, y=St_avtomobilov)) + geom_point()
    mgam <- gam(data = podatki(), St_avtomobilov ~ s(Leto))
    h + geom_smooth(method = "gam", formula = y ~ s(x)) + 
      labs(title = input$drzava, x = "Leto", y = "Število avtomobilov") +
      theme(plot.title = element_text(hjust = 0.5))
    })
  
  output$pri <- renderTable({
    #podatki <- teza %>% filter(Drzava == input$drzava, Teza == input$teza)
    prihodnost <- data.frame(Leto=c(2018, 2019, 2020))
    mgam <- gam(data = podatki(), St_avtomobilov ~ s(Leto))
    #napoved <- predict(mgam, prihodnost)
    napoved <- prihodnost %>% mutate(St_avtomobilov=predict(mgam, .))
    napoved$Leto <- as.integer(napoved$Leto)
    return(napoved)
    })
    
  
  podatki2 <- reactive({starost %>% filter(Drzava == input$drz, Starost == input$starost)})
  
  output$sta <- renderPlot({
    h <- ggplot(data = podatki2(), aes(x=Leto, y=St_avtomobilov)) + geom_point()
    mgam <- gam(data = podatki2(), St_avtomobilov ~ s(Leto))
    h + geom_smooth(method = "gam", formula = y ~ s(x)) + 
      labs(title = input$drz, x = "Leto", y = "Število avtomobilov") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$tab <- renderTable({
    prihodnost <- data.frame(Leto=c(2018, 2019, 2020))
    mgam <- gam(data = podatki2(), St_avtomobilov ~ s(Leto))
    #napoved <- predict(mgam, prihodnost)
    napoved <- prihodnost %>% mutate(St_avtomobilov=predict(mgam, .))
    napoved$Leto <- as.integer(napoved$Leto)
    return(napoved)
  })
 
  podatki3 <- reactive({goriva %>% filter(Drzava == input$d, Vrsta_goriva == input$gorivo)})
  
  output$gor <- renderPlot({
    h <- ggplot(data = podatki3(), aes(x=Leto, y=St_avtomobilov)) + geom_point()
    mgam <- gam(data = podatki3(), St_avtomobilov ~ s(Leto))
    h + geom_smooth(method = "gam", formula = y ~ s(x)) + 
      labs(title = input$d, x = "Leto", y = "Število avtomobilov") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$gor1 <- renderTable({
    prihodnost <- data.frame(Leto=c(2018, 2019, 2020))
    mgam <- gam(data = podatki3(), St_avtomobilov ~ s(Leto))
    #napoved <- predict(mgam, prihodnost)
    napoved <- prihodnost %>% mutate(St_avtomobilov=predict(mgam, .))
    napoved$Leto <- as.integer(napoved$Leto)
    return(napoved)
  })
   
  podatki4 <- reactive({vrsta_motorja %>% filter(Drzava == input$drza, Motor == input$motor, Vrsta_goriva == input$fuel)})
  
  output$mot <- renderPlot({
    h <- ggplot(data = podatki4(), aes(x=Leto, y=Vrednost)) + geom_point()
    mgam <- gam(data = podatki4(), Vrednost ~ s(Leto))
    h + geom_smooth(method = "gam", formula = y ~ s(x)) + 
      labs(title = input$drza, x = "Leto", y = "Število avtomobilov") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$mot1 <- renderTable({
    prihodnost <- data.frame(Leto=c(2018, 2019, 2020))
    mgam <- gam(data = podatki4(), Vrednost ~ s(Leto))
    #napoved <- predict(mgam, prihodnost)
    napoved <- prihodnost %>% mutate(Vrednost=predict(mgam, .))
    napoved$Leto <- as.integer(napoved$Leto)
    return(napoved)
  })
    
    
}




shinyApp(ui = ui, server = server)































