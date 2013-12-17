library(shiny)
library(ape)
library(phangorn)



readTrees <- function(file, format="phylip"){
    if(format=="phylip")tree = read.tree(file)
    else tree = read.nexus(file)
    if(class(tree)=="phylo")tree = list(tree)
    tree
}

shinyServer(function(input, session, output) {

    treeInput <- reactive({
        readTrees(input$file1$datapath, input$format)
    })
    

    output$treeControls <- renderUI({
        inFile <- input$file1        
        if (length(inFile)==1)
            return(NULL)        
        tree <- treeInput()
        ntrees <- length(tree) 
        if(ntrees>1)
        sliderInput("tpos", "Tree:", min=1, max=ntrees, value=1, step=1)    
    })
    
    pos <- reactive({
        input$tpos
    })

    
    output$phyloPlot <- renderPlot({
        inFile <- input$file1        
        if (length(inFile)==1)
            return(NULL)      
        trees <- treeInput()
        
        if(length(trees)==1)tree = trees[[1]]
        else tree = trees[[pos()]]
        
        if(input$midpoint) tree <- midpoint(tree)
        plot.phylo(tree, 
                type = input$type,
                show.tip.label = input$showTips,
                show.node.label = input$showNodes,
                direction=input$direction, 
                rotate.tree = input$rotate,
                use.edge.length = input$edgeLength,   
                edge.width = input$edgewidth, 
                edge.lty =input$lty,   
                edge.color =input$edgecolor,
                tip.color = input$tipcolor)
        if(input$scalebar) add.scale.bar()
    })

    
    
    output$downloadPlot <- downloadHandler(
        filename = function() { paste(input$filename, '.', input$ExportFormat, sep='') },
        content = function(file) {
            
            width = 6
            height = ifelse(input$type=='phylogram' || input$type=='cladogram',4,6)
            dpi=300
            ext = input$ExportFormat
            
#            png(file)
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
                        
            trees <- treeInput()
            if(length(trees)==1)tree = trees[[1]]
            else tree = trees[[pos()]]
            
            if(input$midpoint) tree <- midpoint(tree)

            plot.phylo(tree,
                       type = input$type,
                       show.tip.label = input$showTips,
                       show.node.label = input$showNodes,
                       direction=input$direction,
                       rotate.tree = input$rotate,
                       use.edge.length = input$edgeLength,
                       edge.width = input$edgewidth,
                       edge.lty =input$lty,
                       edge.color =input$edgecolor,
                       tip.color = input$tipcolor)
            if(input$scalebar) add.scale.bar()
            dev.off()
        })
    
    output$rcode <- renderPrint({       
        inFile <- input$file1       
        if (length(inFile)==1)
            return(NULL)
        trees <- treeInput()
        cat("library(ape) \n", sep="")
        cat("library(phangorn) \n", sep="")      
        if(length(trees)==1){
            if(input$format=='phylip') cat("tree = read.tree('",input$file1$name,"') \n", sep="")
            else cat("tree = read.nexus('",input$file1$name,"') \n", sep="")
        }
        else {
            if(input$format=='phylip') cat("trees = read.tree('",input$file1$name,"') \n", sep="")
            else cat("trees = read.nexus('",input$file1$name,"') \n", sep="")
            cat("tree = trees[[",pos(),"]] \n", sep="")
        }
        if(input$midpoint) cat("tree = midpoint(tree)\n", sep="")
        if(input$showTips==FALSE)showTips = ", show.tip.label=FALSE"
        else showTips = ""
        if(input$showNodes==TRUE)showNodes = ", show.node.label=TRUE"
        else showNodes = ""
        if(input$direction!="rightwards") direction = paste(", direction='", input$direction, "'", sep="")
        else direction=""
        if(input$rotate!=0) rotate = paste(", rotate.tree=", input$rotate, sep="")
        else rotate=""    
        if(input$edgeLength==FALSE) edgeLength = paste(", use.edge.length=FALSE")
        else edgeLength=""
        if(input$edgewidth!=1) edgewidth = paste(", edge.width=", input$edgewidth, sep="")
        else edgewidth=""
        if(input$lty!=1) lty = paste(", edge.lty=", input$lty, sep="")
        else lty=""
        if(input$edgecolor!="black") edgecolor = paste(", edge.color='", input$edgecolor, "'", sep="")
        else edgecolor=""
        if(input$tipcolor!="black") tipcolor = paste(", tip.color='", input$tipcolor, "'", sep="")
        else tipcolor=""        
        cat("plot.phylo(tree, type='",input$type,"'", showTips, showNodes, direction, rotate, edgeLength, edgewidth, lty, edgecolor, tipcolor, ") \n", sep = "")
        if(input$scalebar) cat("add.scale.bar() \n", sep="")
    })
    
})

