library(shiny)
library(ggplot2)
library(ggthemes)

# UI logic
ui <- pageWithSidebar(

    # App title
    headerPanel("Fitness Log"),

    # Sidebar panel for inputs
    sidebarPanel(
        selectInput("variable", "Type:",
                    c("30-min cardio" = "30-minute jogs on treadmill",
                      "Strength" = "Pushups",
                      "IPPT Runs" = "2.4km IPPT runs",
                      "Long Distance Runs" = "Long-distance runs"))
    ),

    # Main panel for displaying outputs
    mainPanel(
        h3(textOutput("caption")),
        tableOutput('table'),
        plotOutput("active_plot")
    )
)

data <- read.csv("data.csv",header=T,sep=",")
data$date <- format(as.Date(data$date,format="%d-%m-%Y"),format="%d-%b, %Y")
# colnames(data) <- c("Date", "Distance (km)", "time_m", "time_s", "Weight (kg)", "Pushups", "Time")
data$time <- paste(data$time_m,"m:",formatC(data$time_s, width = 2, format = "d", flag = "0"),"s",sep="")
data_table <- data[,c(1,2,8)]
colnames(data_table) <- c("Date", "Distance (km)", "Time")

# Server logic
server <- function(input,output) {

    captionText <- reactive({
        paste("Exercise: ",input$variable,sep="")
    })

    output$caption <- renderText({
        captionText()
    })

    output$active_plot <- renderPlot({
        ggplot(data,aes(x=date,y=distance_km)) +
            geom_point() +
            geom_line() +
            xlab("Date") +
            scale_y_continuous("Distance (km)") +
            theme_bw()
    })

    output$table <- renderTable(data_table)
}

shinyApp(ui,server)
