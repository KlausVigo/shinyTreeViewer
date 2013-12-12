shinyUI(pageWithSidebar(
    headerPanel("shinyTreeViewer"),
    sidebarPanel(
        
        fileInput('file1', 'Choose tree file'),
        radioButtons('format', 'File format',
                     c(phylip='phylip',
                       nexus='nexus'),
                     'phylip'), 
        tags$hr(),        
        textInput('filename', "Filename"),
        downloadButton('downloadPlot', 'Export Plot'),    
        tags$hr(),
# Layout        
# maybe submitButton("Update plot!") for large trees
        uiOutput("treeControls"),
        
        selectInput("type", "Choose a type:", 
                    choices = c('phylogram', 'cladogram', 'fan', 'unrooted', 'radial')), 
        conditionalPanel(
            condition = "input.type == 'phylogram' || input.type == 'cladogram'",
            selectInput('direction', 'Direction',
                        c('rightwards', 'leftwards', 'upwards', 'downwards'))
        ),
        conditionalPanel(
            condition = "input.type == 'fan' || input.type == 'unrooted' || input.type == 'radial'",
            numericInput("rotate", "Rotate:", value=0)
        ),         
        checkboxInput("scalebar", "scale bar", TRUE),  
#        checkboxInput("midpoint", "Midpoint rooting", FALSE),
        tags$hr(),
#Tips        
        checkboxInput("showTips", "Show tip labels", TRUE),
        textInput("tipcolor", "Tip color:", value="black"),
#Nodes
        checkboxInput("showNodes", "Show node labels (bs)", FALSE),
        tags$hr(),
#Edges  
        checkboxInput("edgeLength", "Use edge length", TRUE),
        numericInput("edgewidth", "Edge width", value=1),
        textInput("edgecolor", "Edge color:", value="black"),
        numericInput("lty", "Line type:", value=1)
        
    ),
    mainPanel(
        tabsetPanel(
            tabPanel("Plot", plotOutput("phyloPlot")), 
            tabPanel("R code", verbatimTextOutput("rcode")) 
        )

    )
))
