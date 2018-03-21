library(shiny)
library(data.table)
library(DT)

pdata <- data.table(readRDS("player_data.rds"))

player_names <- pdata[,Name_FirstLast]

num_cols <- length(colnames(pdata))

metrics <- colnames(pdata[,2:num_cols])

metrics.pre.select <- c("MP_Bnd_1_Ttl_Dist","MP_Bnd_2_Ttl_Dist")
players.pre.select <- c("Jeffrey Farina","Brandon Aubrey")

# UI
ui <- fluidPage(
  titlePanel("ND Soccer Drill App"),
  fluidRow(
    column(2,
           selectInput("players",
                       label = h5("Select Players"),
                       multiple = TRUE,
                       choices = player_names,
                       selected = players.pre.select
           )
    ),
    column(3,
           selectInput("metrics",
                       label = h5("Select Metrics"),
                       multiple = TRUE,
                       choices = metrics,
                       selected = metrics.pre.select
             )
    )
  ),
  fluidRow(
    column(10,
           dataTableOutput('tbl')
    )
  )
)

# Server
server <- function(input, output, session) {
  selected.players <- reactive({
    return (input$players)
    })
  selected.metrics <- reactive({
    return (input$metrics)
  })
  # Create table for player data
  table1 <- reactive({
    x <- pdata[Name_FirstLast %in% selected.players(), c("Name_FirstLast",selected.metrics()),with=FALSE]
   
    return(x)
  })
  
  # Create output table
  output$tbl <- renderDataTable(datatable(
    table1(), rownames = FALSE, options = list(searching = FALSE, paging = FALSE, lengthMenu = FALSE, col)
    )
  )
}

shinyApp(ui = ui, server = server)
