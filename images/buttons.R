

tree = read.tree(text="((t1:0.8,t2:0.9):0.6,((t4:0.8,t5:0.5):0.4,t3:0.9):0.3);")
#tree$edge.length = c(.6,.8,.9,.3,.4,.8,.5, 1)

png("phylogram.png", width=40, height=40)
par(mar = c(0,0,0,0))
par(oma = c(0,0,0,0))
plot((tree), "p", show.tip=FALSE, edge.width=1)
dev.off()

png("cladogram.png", width=40, height=40)
par(mar = c(0,0,0,0))
par(oma = c(0,0,0,0))
plot(tree, "c", show.tip=FALSE, edge.width=1, use.edge.length=FALSE)
dev.off()

png("fan.png", width=40, height=40)
par(mar = c(0,0,0,0))
par(oma = c(0,0,0,0))
plot(midpoint(tree), "f", show.tip=FALSE, edge.width=2)
dev.off()

png("unrooted.png", width=40, height=40)
par(mar = c(0,0,0,0))
par(oma = c(0,0,0,0))
plot(tree, "u", show.tip=FALSE, edge.width=2)
dev.off()

png("radial.png", width=40, height=40)
par(mar = c(0,0,0,0))
par(oma = c(0,0,0,0))
plot(tree, "r", show.tip=FALSE, edge.width=2)
dev.off()
