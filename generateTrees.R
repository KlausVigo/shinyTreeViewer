library(phangorn)
data(Laurasiatherian)
dm <- dist.ml(Laurasiatherian)
tree <- NJ(dm)
fit <- pml(tree, Laurasiatherian, bf=baseFreq(Laurasiatherian), k=4, inv=.2)
fit <- optim.pml(fit, model="GTR", optGamma=TRUE, optInv=TRUE, rearrangement="NNI")
fit <- optim.pml(fit, model="GTR", optGamma=TRUE, optInv=TRUE, rearrangement="stochastic")

bs <- bootstrap.pml(fit, multicore = TRUE, rearrangement="NNI")

tree2 <- plotBS(fit$tree, bs)

write.tree(tree2, file="bestTree.tre")
write.tree(bs, file="bootstrapTrees.tre")
