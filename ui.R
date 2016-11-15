library(markdown)
tabPanelAbout <- source("about.R")$value

shinyUI(navbarPage("shinyTreeViewer",
    tabPanel("File",  

        wellPanel(
            fluidRow(
                column(6,     
                    h2(HTML('<font color="#6C6CC4" size="5"> > Input </font>')),
                    radioButtons("datasource", HTML('<font size="4"> Choose data source:</font>'),
                                    list("Example: annotated tree"="exTree", 
                                         "Example: MCMC sample"="exMCMC",
                                         "Import tree"="file", 
                                         "Simulate trees"="simulate")),   
                    
                    conditionalPanel(condition = "input.datasource=='file'",
                                     fileInput("file1", "Load tree file"),
                                     actionButton("downloadButton", "update plot") #icon("refresh")),
                    ),
                    
                    conditionalPanel(condition = "input.datasource=='simulate'",
                                     #                    h3("Simulate tree"),    
                                     numericInput("ntips", "Number of tips", value=10, min=3),   
                                     numericInput("ntrees", "Number of trees", value=1, min=1),
                                     checkboxInput("isrooted", "Rooted", TRUE),
                                     actionButton("simulateButton", "update plot") #  icon("refresh"))
                    ),

                    
                       
#                    h3("Import tree"),   
#                    fileInput('file1', 'Import tree file'),
#                    actionButton("downloadButton", "update plot"), #icon("refresh")),
                    
                    tags$hr(),
                    h3("Export tree"), 
                    textInput('filename', 'Filename'),
                    selectInput('ExportFormat', '', choices = c('pdf', 'ps', 'tex', 'svg', 'png', 'jpg', 'bmp' )),
                    downloadButton('downloadPlot', 'Export Plot')       
                ),
                column(6 #,
#                    h3("Simulate tree"),    
#                    numericInput("ntips", "Number of tips", value=10, min=3),   
#                    numericInput("ntrees", "Number of trees", value=1, min=1),
#                    checkboxInput("isrooted", "Rooted", TRUE),
#                    actionButton("simulateButton", "update plot") #  icon("refresh"))
                )        
            )
        )     
    ),              
    tabPanel("Plot", 
        sidebarLayout(
            sidebarPanel(     
                HTML("<div id=\"ptype\" class=\"btn-group\">
<button id=\"phylogram\"  type=\"button\" class=\"btn action-button\">\n  <img src=\"./img/phylogram.png\" width=\"40\" height=\"40\" alt=\"phylogram\"/>\n</button>\n
<button id=\"unrooted\" type=\"button\" class=\"btn action-button\">\n  <img src=\"./img/unrooted.png\" width=\"40\" height=\"40\" alt=\"unrooted\"/>\n</button>
<button id=\"fan\" type=\"button\" class=\"btn action-button\">\n  <img src=\"./img/fan.png\" width=\"40\" height=\"40\" alt=\"fan\"/>\n</button>
<button id=\"cladogram\" type=\"button\" class=\"btn action-button\">\n  <img src=\"./img/cladogram.png\" width=\"40\" height=\"40\" alt=\"cladogram\"/>\n</button>
<button id=\"radial\" type=\"button\" class=\"btn action-button\">\n  <img src=\"./img/radial.png\" width=\"40\" height=\"40\" alt=\"radial\"/>\n</button>
</div>"),   
                # Layout        
                # maybe submitButton("Update plot!") for large trees
                uiOutput("treeControls"),
                
                uiOutput('direction'),
                
                uiOutput('rotate'),
                
                uiOutput('openangle'),         
                
                uiOutput('axis'),
                                
                checkboxInput("scalebar", "Scale bar", TRUE),  
                
                checkboxInput("margin", "Show margins", FALSE),
                checkboxInput("midpoint", "Midpoint rooting", FALSE),
                tags$hr(),
                #Labels
                HTML("<div id=\"font\" class=\"btn-group\">
<button id=\"font1\"  type=\"button\" class=\"btn action-button\">\n  <img src=\"./img/font1.svg\" width=\"40\" height=\"40\" alt=\"phylogram\"/>\n</button>\n
<button id=\"font2\" type=\"button\" class=\"btn action-button\">\n  <img src=\"./img/font2.svg\" width=\"40\" height=\"40\" alt=\"unrooted\"/>\n</button>
<button id=\"font3\" type=\"button\" class=\"btn action-button\">\n  <img src=\"./img/font3.svg\" width=\"40\" height=\"40\" alt=\"fan\"/>\n</button>
<button id=\"font4\"type=\"button\" class=\"btn action-button\">\n  <img src=\"./img/font4.svg\" width=\"40\" height=\"40\" alt=\"cladogram\"/>\n</button>
</div>"),    
                #Tips        
                checkboxInput("showTips", "Tip labels", TRUE),
                uiOutput('lab4ut'),
                textInput("tipcolor", "Tip color:", value="black"),
                
                #Nodes
                checkboxInput("showNodes", "Node labels (e.g. bootstrap values)", FALSE),
                tags$hr(),
                #Edges  
                checkboxInput("edgeLength", "Use edge length", TRUE),
                numericInput("edgewidth", "Edge width", value=1, min=0),
                textInput("edgecolor", "Edge color:", value="black"),
                numericInput("lty", "Line type:", value=1, min=0, max=6, step=1)                  
            ),
            
            mainPanel(
                plotOutput("phyloPlot")
            )
        )        
    ), 
    tabPanel("R code", verbatimTextOutput("rcode")),
    tabPanelAbout()
    
))

