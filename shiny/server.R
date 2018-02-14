library(shiny)

shinyServer(function(input, output) {
  
  starost1 <- eventReactive(input$klik, 
                           {starost %>% filter(Drzava == input$drzava, Leto == input$Leto)})
  
  output$graf <- renderPlot({
    s <- ggplot(data = starost1(), aes(x=Starost, y=St_avtomobilov)) +
      geom_col(fill = "cornflowerblue") + 
      labs(x = "Starost", y = "Število avtomobilov", title = isolate({input$drzava})) +
      theme(plot.title = element_text(hjust = 0.5))
    
    print(s)
    
    
  })
  
  output$teza <- renderPlot({
    podatki <- teza %>% filter(Drzava == input$drz, Leto == input$leto)
    g <- pie3D(podatki$St_avtomobilov ,labels = podatki$Teza,explode = 0.1, main = input$drz )
    
    print(g)
    
  })
  
  output$box <- renderPlot({
    b <- ggplot(data = goriva %>% filter(Drzava == input$izberi),
                aes(x = Vrsta_goriva, y = St_avtomobilov)) +
      geom_boxplot() + geom_point() +
      labs(title = input$izberi, x = "Vrsta goriva", y = "Število avtomobilov") + 
      theme(plot.title = element_text(hjust = 0.5))
    
    print(b)
    
  })
  
  motor1 <- eventReactive(input$clic, 
                            {vrsta_motorja %>% filter(Drzava == input$cou, Leto == input$let)})
  
  output$wrap <- renderPlot({
    a <- ggplot(data = motor1(), aes(x = Motor, y = Vrednost)) + geom_col() + facet_wrap(~Vrsta_goriva) +
      labs(title = isolate({input$cou}), x = "Velikost motorja", y = "Število avtomobilov") + 
      theme(plot.title = element_text(hjust = 0.5))
    
    print(a)
    
  })
  
  
})
