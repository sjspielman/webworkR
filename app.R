library(shiny)
library(shinythemes)
library(tidyverse)
library(reticulate)

reticulate::source_python("prepare_questions.py")
#use_python("/usr/local/bin/python3")


ui <- fluidPage(theme = shinytheme("united"),
  
  # Application title
  titlePanel("webworkR: Format your WebWork questions"),
  br(),
  p("Written by", a("Stephanie J. Spielman, Ph.D.",href="https://spielmanlab.github.io"), "and released under GPL-3 License. Source code:", 
    a("https://github.com/sjspielman/webworkR",href="https://github.com/sjspielman/webworkR")),
  br(),br(),

  p("Please use this", 
    a("example template",href="https://github.com/sjspielman/webworkR/master/blob/template.txt"), 
    "to format your questions as text files."),
  br(),br(),
   # sidebarPanel(
      fileInput("raw_questions", "Upload your questions as a text file using the format described above.",
                        accept = c(".txt"), # require txt file 
                        width = "100%"
                      ),
      textInput("question_set_name", "How would you like to name the question files? Please use ONLY numbers, letters, underscores, dashes, and/or spaces. No other fancy symbols!", width = "100%"),
      downloadButton("download_questions", "Format and DownloadWebWork Questions")
   # )
) # ui

server <- function(input, output) {

  
  output_name <- reactive({
    paste0(stringr::str_replace_all(input$question_set_name, " ", "-"), "/")
  })
  
  output$download_questions <- downloadHandler(
    filename = function() {
      paste(input$question_set_name, "-", Sys.Date(), ".zip", sep="")
    },
    content = function(file) {
      format_questions(input$raw_questions$datapath, output_name())
      zip(file, output_name())
    }
  )


}




# Run the application 
shinyApp(ui = ui, server = server)
