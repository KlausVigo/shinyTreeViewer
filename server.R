library(shiny)
library(ape)
library(phangorn)


readTrees <- function(file, format="phylip"){
    if(format=="phylip")tree = read.tree(file)
    else tree = read.nexus(file)
    if(class(tree)=="phylo")tree = list(tree)
    tree
}


simulateTrees <- function(ntrees, ntips, rooted){
    tree <- rmtree(ntrees, ntips, rooted)
    if(class(tree)=="phylo")tree = list(tree)
    tree
}


shinyServer(function(input, session, output) {
 
    X <- reactiveValues()
    X$tree <- list(stree(3))
    X$sim <- TRUE 
    X$dB <- 0
    X$iB <- 0
    observe({
        if(input$downloadButton[1] > X$dB){ 
            X$tree <- treeInput()
            X$sim <- FALSE  
            X$dB <- input$downloadButton[1]
        }                      
        if(input$simulateButton[1] > X$iB){ 
            X$tree <- isolate(simulateTrees(input$ntrees, input$ntips, input$isrooted))
            X$sim <- TRUE
            X$iB <- input$simulateButton[1]
        }       
    })
    
    xx <- reactiveValues()
    xx$format <- "phylip"
    xx$type <- "phylogram"
    xx$font <- 1
    xx$phyloOrClado <- TRUE
    observe({
        if (input$phylogram != 0) {
            xx$type <- "phylogram"
            xx$phyloOrClado <- TRUE
        }
    })
    observe({
        if (input$unrooted != 0) {
            xx$type <- "unrooted"
            xx$phyloOrClado <- FALSE
        }
    })
    observe({
        if (input$fan != 0) {
            xx$type <- "fan"
            xx$phyloOrClado <- FALSE
        }
    })
    observe({
        if (input$cladogram != 0) {
            xx$type <- "cladogram"
            xx$phyloOrClado <- TRUE
        }
    })
    observe({
        if (input$radial != 0) {
            xx$type <- "radial"
            xx$phyloOrClado <- FALSE
        }
    })
    
    observe({
        if (input$font1 != 0) {
            xx$font <- 1
        }
    })
    observe({
        if (input$font2 != 0) {
            xx$font <- 2
        }
    })
    observe({
        if (input$font3 != 0) {
            xx$font <- 3
        }
    })
    observe({
        if (input$font4 != 0) {
            xx$font <- 4
        }
    })
    
    
    
    treeInput <- reactive({
        tmp = strsplit(tolower(input$file1$name), "[.]")[[1]]
        tmp = tmp[length(tmp)]
        if(is.na(pmatch("nex", tmp)))xx$format="phylip"
        else xx$format="nexus"
        readTrees(input$file1$datapath, xx$format)
    })
    
    
    output$treeControls <- renderUI({
#        inFile <- input$file1 
#        if (is.null(inFile))
#            return(NULL)    
#        if (length(inFile)==1)
#            return(NULL)        
        tree <- X$tree  #  treeInput()
        ntrees <- length(tree) 
        if(ntrees>1)
        sliderInput("tpos", "Tree:", min=1, max=ntrees, value=1, step=1)    
    })
    
    output$direction <- renderUI({
        if(xx$type == 'phylogram' || xx$type == 'cladogram')
        selectInput('direction', 'Direction',
                    c('rightwards', 'leftwards', 'upwards', 'downwards'))
    })

    output$axis <- renderUI({#        conditionalPanel(
        if(xx$phyloOrClado || xx$type == 'fan')
            checkboxInput("axis", "Axis", FALSE)
    })
     
    output$rotate <- renderUI({
        if(xx$type == 'fan' || xx$type == 'unrooted' || xx$type == 'radial')
            sliderInput("rotate", "Rotate:", min=0, max=360, value=0, step=1)
    }) 

    output$openangle <- renderUI({
        if(xx$type == 'fan' || xx$type == 'radial')
            sliderInput("openangle", "Open angle:", min=0, max=360, value=0, step=1)
    })


    output$lab4ut <- renderUI({
        if(xx$type == 'fan' || xx$type == 'unrooted' || xx$type == 'radial')
            radioButtons('lab4ut', 'Labels',
                         c('horizontal',
                           'axial'),
                         'axial')
    }) 

    
  
    
    yy <- reactiveValues()
    yy$axis <- FALSE

    observe({
        if(is.null(input$axis))yy$axis = FALSE
        else yy$axis <- input$axis
    })

    pos <- reactive({
        input$tpos
    })

    output$phyloPlot <- renderPlot({
#        inFile <- input$file1        
#        if (length(inFile)==1)
#            return(NULL)      
#        trees <- treeInput()
 
        trees = X$tree
        
        if(length(trees)==1)tree = trees[[1]]
        else tree = trees[[pos()]]
        
        if(input$midpoint) tree <- midpoint(tree)
        plot.phylo(tree, 
                type = xx$type,
                show.tip.label = input$showTips,
                show.node.label = input$showNodes,
                direction=input$direction, 
                rotate.tree = input$rotate,
                open.angle = input$openangle,
                lab4ut = input$lab4ut, 
                use.edge.length = input$edgeLength, 
                font = xx$font,
                edge.width = input$edgewidth, 
                edge.lty =input$lty,   
                edge.color =input$edgecolor,
                tip.color = input$tipcolor)
        if(input$margin){
#            tmp = get("last_plot.phylo", envir = .PlotPhyloEnv)
#            abline(h=tmp$y.lim)
#            abline(v=tmp$x.lim)  
            box("outer", col="red")
            box("inner", col="green")
            box("plot", col="blue") 
        }
        if((xx$phyloOrClado || xx$type == 'fan') && yy$axis){
            if(  input$direction == "leftwards" || input$direction == "rightwards") 
                axisPhylo(side = 1)
            else axisPhylo(side = 2)
        } 
        if(input$scalebar) add.scale.bar()
    })

    
    
    output$downloadPlot <- downloadHandler(
        filename = function() { paste(input$filename, '.', input$ExportFormat, sep='') },
        content = function(file) {
            
            width = 6
            height = ifelse(xx$type=='phylogram' || xx$type=='cladogram',4,6)
            dpi=300
            ext = input$ExportFormat
            
            switch(ext,
                   eps = postscript(file, height=height, width=width),
                   ps = postscript(file, height=height, width=width),       
                   tex = pictex(file, height=height, width=width),                                                      
                   pdf = pdf(file, height=height, width=width),
                   svg = svg(file, height=height, width=width),
                   wmf = win.metafile(file, width=width, height=height),
                   emf = win.metafile(file, width=width, height=height),
                   png = png(file, width=width, height=height, res = dpi, units = "in"),
                   jpeg = jpeg(file, width=width, height=height, res=dpi, units="in"),
                   jpg = jpeg(file, width=width, height=height, res=dpi, units="in"),   
                   bmp = bmp(file, width=width, height=height, res=dpi, units="in"),
                   tiff = tiff(file, width=width, height=height, res=dpi, units="in")                                      
            )
                        
            trees <- X$tree  #treeInput()
            if(length(trees)==1)tree = trees[[1]]
            else tree = trees[[pos()]]            
            if(input$midpoint) tree <- midpoint(tree)
            plot.phylo(tree,
                       type = xx$type,
                       show.tip.label = input$showTips,
                       show.node.label = input$showNodes,
                       direction=input$direction,
                       rotate.tree = input$rotate,
                       open.angle = input$openangle,
                       lab4ut = input$lab4ut, 
                       use.edge.length = input$edgeLength,
                       font = xx$font,
                       edge.width = input$edgewidth,
                       edge.lty =input$lty,
                       edge.color =input$edgecolor,
                       tip.color = input$tipcolor)
            if((xx$phyloOrClado || xx$type == 'fan') && yy$axis ){
                if(input$direction == "leftwards" || input$direction == "rightwards") 
                    axisPhylo(side = 1)
                else axisPhylo(side = 2)
            } 
            if(input$scalebar) add.scale.bar()
            dev.off()
        })
    
    output$rcode <- renderPrint({       
        inFile <- input$file1       
        if (length(inFile)==1)
            return(NULL)
        trees <- X$tree #treeInput()
        cat("library(ape) \n", sep="")
        cat("library(phangorn) \n", sep="")    
        
        if(!X$sim){
        if(length(trees)==1){
            if(xx$format=='phylip') cat("tree = read.tree('",input$file1$name,"') \n", sep="")
            else cat("tree = read.nexus('",input$file1$name,"') \n", sep="")
        }
        else {
            if(xx$format=='phylip') cat("trees = read.tree('",input$file1$name,"') \n", sep="")
            else cat("trees = read.nexus('",input$file1$name,"') \n", sep="")
            cat("tree = trees[[",pos(),"]] \n", sep="")
        }
        }
        else{
            if(length(trees)==1)  cat("tree = rtree(",input$ntips, ", rooted= ",input$isrooted,") \n", sep="")
            else{ cat("trees = rmtree(", input$ntrees, ",", input$ntips,", rooted=",input$isrooted,") \n", sep="")
            cat("tree = trees[[",pos(),"]] \n", sep="")
            }
        }  
        
        if(input$midpoint) cat("tree = midpoint(tree)\n", sep="")
        if(input$showTips==FALSE)showTips = ", show.tip.label=FALSE"
        else showTips = ""
        if(input$showNodes==TRUE)showNodes = ", show.node.label=TRUE"
        else showNodes = ""
        if(xx$phyloOrClado && input$direction!="rightwards") direction = paste(", direction='", input$direction, "'", sep="")
        else direction=""
        if(!xx$phyloOrClado && input$rotate!=0) rotate = paste(", rotate.tree=", input$rotate, sep="")
        else rotate="" 
        if((xx$type == 'fan' || xx$type == 'radial') && input$openangle!=0) openangle = paste(", open.angle=", input$openangle, sep="")
        else openangle="" 
        if(!xx$phyloOrClado) #(xx$type == 'fan' || xx$type == 'unrooted' || xx$type == 'radial')
            lab4ut = paste(", lab4ut='", input$lab4ut, "'", sep="")
        else lab4ut = ""
        if(input$edgeLength==FALSE) edgeLength = paste(", use.edge.length=FALSE")
        else edgeLength=""
        if(xx$font!=1) font = paste(", font=", xx$font, sep="")
        else font=""
        if(input$edgewidth!=1) edgewidth = paste(", edge.width=", input$edgewidth, sep="")
        else edgewidth=""
        if(input$lty!=1) lty = paste(", edge.lty=", input$lty, sep="")
        else lty=""
        if(input$edgecolor!="black") edgecolor = paste(", edge.color='", input$edgecolor, "'", sep="")
        else edgecolor=""
        if(input$tipcolor!="black") tipcolor = paste(", tip.color='", input$tipcolor, "'", sep="")
        else tipcolor=""        
        cat("plot.phylo(tree, type='",xx$type,"'", showTips, showNodes, direction, rotate, openangle, lab4ut, edgeLength, font, edgewidth, lty, edgecolor, tipcolor, ") \n", sep = "")
        if(input$scalebar) cat("add.scale.bar() \n", sep="")        
        if( (xx$phyloOrClado || xx$type == "fan") && yy$axis){
            if(input$direction == "leftwards" || input$direction == "rightwards") 
                cat("axisPhylo(side = 1) \n", sep="")
            else cat("axisPhylo(side = 2) \n", sep="")
        } 
    })
    
})

