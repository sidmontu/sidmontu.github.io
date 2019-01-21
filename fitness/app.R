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
                      "Long Distance Runs" = "Long-distance runs",
                      "Weight" = "Weight (kg)"))
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

data_plot_distance <- data[,c(1,2,10)]
data_plot_distance <- data_plot_distance[complete.cases(data_plot_distance),]
data_table_distance <- data_plot_distance
colnames(data_table_distance) <- c("Date", "Distance (km)", "Time")

data_plot_steps <- data[,c(1,9)]
data_plot_steps <- data_plot_steps[complete.cases(data_plot_steps),]
data_table_steps <- data_plot_steps
colnames(data_table_steps) <- c("Date", "Steps")

data_plot_weight <- data[,c(1,5)]
data_plot_weight <- data_plot_weight[complete.cases(data_plot_weight),]
data_table_weight <- data_plot_weight
colnames(data_table_weight) <- c("Date", "Weight (kg)")

# Server logic
server <- function(input,output) {

    captionText <- reactive({
        paste("Exercise: ",input$variable,sep="")
    })

    output$caption <- renderText({
        captionText()
    })

    output$active_plot <- renderPlot({
        if (input$variable == "Daily Steps") {
            ggplot(data_plot_steps,aes(x=date,y=steps/1e3)) +
                geom_point() +
                geom_line(data=data_plot_steps,aes(x=date,y=steps/1e3)) +
                geom_hline(yintercept=mean(data_plot_steps$steps)/1e3,linetype="dashed",color="red") +
                annotate("text", x=min(data_plot_steps$date), y=mean(data_plot_steps$steps)/1e3 + 0.3, label= "Mean", color="red") +
                xlab("Date") +
                scale_y_continuous("Daily Steps (Thousands)",breaks=seq(0,ceiling(max(data_plot_steps$steps/1e3)),by=1)) +
                theme_bw()
        } else if (input$variable == "Weight (kg)") {
            ggplot(data_plot_weight,aes(x=date,y=weight_kg)) +
                geom_point() +
                geom_line(data=data_plot_weight,aes(x=date,y=weight_kg)) +
                geom_hline(yintercept=80,linetype="dashed",color="blue") +
                annotate("text", x=max(data_plot_distance$date), y=80.5, label= "Target", color="blue") +
                xlab("Date") +
                scale_y_continuous("Weight (kg)") +
                theme_bw()
        } else {
            ggplot(data_plot_distance,aes(x=date,y=distance_km)) +
                geom_point() +
                geom_line(data=data_plot_distance,aes(x=date,y=distance_km)) +
                geom_hline(yintercept=6.5,linetype="dashed",color="darkgreen") +
                annotate("text", x=max(data_plot_distance$date), y=6.7, label= "Current target", color="darkgreen") +
                xlab("Date") +
                scale_y_continuous("Distance (km)",limits=c(0,7),breaks=seq(0,7,by=1)) +
                theme_bw()
        }
    })

    output$table <- renderTable({
        if (input$variable == "Daily Steps") {
            data_table_steps
        } else if (input$variable == "Weight (kg)") {
            data_table_weight
        } else {
            data_table_distance
        }
    })

}

shinyApp(ui,server)
