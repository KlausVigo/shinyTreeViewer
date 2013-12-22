function(){
    tabPanel("About",
HTML("
    <p>shinyTreeviewer is a small treeviewer to plot phylogenetic trees using the R
    packages ape and phangorn.</p>
        <p>It is possible to run it from within R:</p>
        <p><code>shiny::runGitHub('shinyTreeViewer', 'KlausVigo')</code></p>
        <p>can launched also via the <a
    href='http://klash.shinyapps.io/shinyTreeViewer/'>RStudio server</a>.</p>
        <p>The source code shinyTreeviewer is on <a
    href='https://github.com/KlausVigo/shinyTreeViewer'>GitHub</a>. shinyTreeViewer
    is in early development so I am happy to recieve suggestions or bug reports. </p>
        <p> </p>
        <p><strong>References</strong> </p>
        <p><a href='http://www.rstudio.com/shiny'>shiny</a></p>
        <p><a href='http://ape-package.ird.fr/'>ape</a> </p>
        <p><a href='http://cran.r-project.org/web/packages/phangorn/'>phangorn</a></p>
        <p></p>
        <p><strong>License</strong> </p>
        <p>shinyTreeViewer is licensed under the GPLv3. </p>
    ")
)}


