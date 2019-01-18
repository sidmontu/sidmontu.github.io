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
                    c("Steps" = "Daily Steps",
                      "30-min cardio" = "30-minute jogs on treadmill",
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
data_table <- data[,c(1,2,10)]
data_plot <- data[,c(1,2,10)]
colnames(data_table) <- c("Date", "Distance (km)", "Time")
data_table <- data_table[complete.cases(data_table),]
data_plot <- data_plot[complete.cases(data_plot),]

# Server logic
server <- function(input,output) {

    captionText <- reactive({
        paste("Exercise: ",input$variable,sep="")
    })

    output$caption <- renderText({
        captionText()
    })

    output$active_plot <- renderPlot({
        ggplot(data_plot,aes(x=date,y=distance_km)) +
            geom_point() +
            geom_line(data=data_plot,aes(x=date,y=distance_km)) +
            xlab("Date") +
            scale_y_continuous("Distance (km)",limits=c(0,7),breaks=seq(0,7,by=1)) +
            theme_bw()
    })

    output$table <- renderTable(data_table)
}

shinyApp(ui,server)
