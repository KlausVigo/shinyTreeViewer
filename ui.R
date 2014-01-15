tabPanelAbout <- source("about.R")$value
shinyUI(pageWithSidebar(
    headerPanel("shinyTreeViewer"),
    sidebarPanel(
    actionButton("pButton", tags$img(src="phylogram.png", width="40", height="40", alt="phylogram")),
    actionButton("uButton", tags$img(src="unrooted.png", width="40", height="40", alt="unrooted")),
    actionButton("fButton", tags$img(src="fan.png", width="40", height="40", alt="fan")),
    actionButton("cButton", tags$img(src="cladogram.png", width="40", height="40", alt="cladogram")),
    actionButton("rButton", tags$img(src="radial.png", width="40", height="40", alt="radial")),    
#        tags$button(id="cladoButton", src="./images/cladogram.png"
#    , width="40", height="40"),
        fileInput('file1', 'Choose tree file'),
#        selectInput('format', 'File format', choices = c('phylip', 'nexus')),
#        tags$hr(),        
        textInput('filename', 'Filename'),
        selectInput('ExportFormat', '', choices = c('pdf', 'ps', 'tex', 'svg', 'png', 'jpg', 'bmp' )),
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
        checkboxInput("scalebar", "Scale bar", TRUE),  
        conditionalPanel(
            condition = "input.type == 'phylogram' || input.type == 'cladogram'",
            checkboxInput("axis", "Axis", FALSE)
        ),     
        checkboxInput("margin", "Show margins", FALSE),
        checkboxInput("midpoint", "Midpoint rooting", FALSE),
        tags$hr(),
#Tips        
        checkboxInput("showTips", "Tip labels", TRUE),
        textInput("tipcolor", "Tip color:", value="black"),
#Nodes
        checkboxInput("showNodes", "Node labels (e.g. bootstrap values)", FALSE),
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
            tabPanel("R code", verbatimTextOutput("rcode")),
            tabPanelAbout() 
        )
    )
))
