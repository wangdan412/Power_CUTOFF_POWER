library(shiny)
library(OptimalCutpoints)


  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
datafunc <- function(n,p0,p1,p2,RRn,RRw, RRp, B1, method){
  cut <- 50
  methodt <- ifelse(method==1,"Youden","ValueDLR.Positive")
  out <- NA
  set.seed(100)
  for (i in 1:B1){
    Bs <- c(sample(1:(cut-1), p1*n, replace = TRUE), sample(cut:100, p2*n, replace = TRUE), rep(0,p0*n))
    genRRf <- function(x)ifelse(x>cut, sample(c(1,0),1,replace = TRUE, prob = c(RRp, 1-RRp)),ifelse(x==0,sample(c(1,0),1,replace = TRUE, prob = c(RRn,1-RRn)),sample(c(1,0),1,replace = TRUE, prob = c(RRw,1-RRw)) ) )
    RRg <- sapply(Bs, genRRf)
    Tim3 <- data.frame(Bs, RRg)
    cp <- optimal.cutpoints(X = "Bs", status = "RRg",
                            tag.healthy = 0, methods = methodt, data = Tim3,
                            categorical.cov = NULL, pop.prev = NULL,
                            control = control.cutpoints(), ci.fit = TRUE)
    
    out[i] <- cp[[1]][[1]]$optimal.cutoff$cutoff
  }
  return(out)
}



  shinyServer(function(input, output) {
    
    datainput <- reactive({datafunc(input$n,input$p0, input$p1,input$p2, input$RRn, input$RRw, input$RRp, input$B1,input$method)})
    
   output$txt <- renderText({
     out <- datainput()
     power <- sum(out<55&out>=45)/input$B1
     })
    
  
 
  output$distPlot <- renderPlot({
  Mode <- function(x) {
     ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
   }#end
       out<-datainput()
       hist(out, main = paste( "Picked cut-off (mode =", Mode(out), ")"), xlab = "cut-point")
      
  })
  
  output$hypoPlot <- renderPlot({
    
    x <-c(0, seq(0,50,1),seq(50,100,1))
    y <- c(input$RRn,rep(input$RRw,51),rep(input$RRp,51))
    plot(x,y,xlab="IHC",ylab = "Response Rate", type="l",lwd=2)  
    
  })
  
  
})
