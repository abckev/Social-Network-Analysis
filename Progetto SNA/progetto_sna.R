# packages
install.packages("igraph")
install.packages("openxlsx")
install.packages("plot.matrix")
install.packages("ggplot2")
install.packages("devtools")
install.packages("readr")
install.packages("ggraph")
install.packages("readxl")

# libraries
library(igraph)
library(openxlsx)
library(plot.matrix)
library(ggplot2)
library(devtools)
library(readr)
library(ggraph)
library(readxl)

# Reading the Excel file
df <- read_excel("cluster_summary.xlsx")

# Extracting unique domains
unique_domains <- trimws(unique(unlist(strsplit(cluster_summary$top.parent_domain,","))))

# Creating an empty data frame with specific dimensions
df <- data.frame(matrix(NA, nrow = length(cluster_summary$cluster), ncol = length(unique_domains)))
rownames(df) <- cluster_summary$cluster
colnames(df) <- unique_domains

# Populating the data frame with 1s and 0s
for(valore in 1:length(cluster_summary$cluster)){
  for(i in 1:length(unique_domains)){
    if(unique_domains[i] %in% trimws(unlist(strsplit(cluster_summary$top.parent_domain[valore], ",")))){
      df[valore,i] <- 1
    }else{
      df[valore,i] <- 0
    }
  }
}
# Viewing the data frame
View(df)

# Creating a dataframe with nodes and type 0=domain 1=cluster
v1 <- data.frame(node=cluster_summary$cluster, type=1) 
v2 <- data.frame(node=unique_domains, type=0)
v <- rbind(v1,v2)

# Creating a bipartite graph: cluster - domain
g <- graph_from_incidence_matrix(df)
write.graph(g,"rt_g.graphml2",format = "graphml")

# Bipartite projection
g.bp <- igraph::simplify(g, remove.multiple = T, remove.loops = T, edge.attr.comb = "min") # simplify the bipartite network to avoid problems with resulting edge weight in projected network
full_g1 <- suppressWarnings(igraph::bipartite.projection(g.bp, multiplicity = T)$proj1)
full_g2 <- suppressWarnings(igraph::bipartite.projection(g.bp, multiplicity = T)$proj2)

write.graph(g.bp,"proiezione_semplicato.graphml",format = "graphml")
write.graph(full_g1,"proiezione_cluster.graphml",format = "graphml")
write.graph(full_g2,"proiezione_dominio.graphml",format = "graphml")

# Calculating edge weights: calculates the number of times a cluster has used a domain
count <- colSums(df)
count

# Creating a vector of edge weights based on counts
pesi_archi <- rep(0, ecount(g.bp))  # Initializes a weight vector of length equal to the number of edges in the graph
archi <- get.edgelist(g.bp)

for (i in 1:(length(archi)/2)) {
  arco <- archi[i, ]         # Prendi un arco dalla lista
  weight <- count[arco[2]]   # Ottieni il conteggio del dominio associato all'arco
  pesi_archi[i] <- weight    # Assegna il peso all'arco corrispondente nel vettore dei pesi
}

pesi_archi
# Interaction with the user for choosing the weight threshold
threshold <- 2
#threshold <- readline("Enter your weight threshold: ")
threshold <- as.numeric(threshold)

# Deleting edges lower than the threshold
simplify_graph <- function(g, threshold) {
  filtered_graph <- delete_edges(g, E(g.bp)[pesi_archi <= threshold])
  return(filtered_graph)
}

# Simplification of the graph using the chosen weight threshold
filtered_graph <- simplify_graph(g.bp, threshold)

# Visualization of the filtered graph
plot(filtered_graph, edge.label = E(filtered_graph)$weight, edge.width = 2, main = "Filtered graph")

write.graph(filtered_graph,"filtered_graph.graphml",format = "graphml")
