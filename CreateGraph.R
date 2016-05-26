library(rgexf)

# Create Graph
nodes <- data.frame(from = t$from, to = t$to, value = t$value, ts = t$ts)
g <- igraph::graph.data.frame(nodes, directed = T)
s <- graph.neighborhood(g,1,nodes=V(g)[TheDAOAddr])[[1]]
s <- simplify(s, remove.multiple = F, remove.loops = T) 

# Create Graph with unique addresses (and thus summarized transaction values)
nodes_summarized <- plyr::ddply(nodes, c("from", "to"), plyr::summarize, value = sum(value))
g_summarized <- igraph::graph.data.frame(nodes_summarized, directed = T)
s_summarized <- graph.neighborhood(g_summarized,1,nodes=V(g_summarized)[TheDAOAddr])[[1]]
s_summarized <- simplify(s_summarized, remove.multiple = F, remove.loops = T) 
saveAsGEXF(s_summarized,"TheDAO-unique-addresses.gexf")

# Visualisation notes
# - Move nodes of degree 1 to the side
# - Edges that go into The DAO are red
# - Edges that leave big player are green?
# - Copy value to weight
# - Remove edges of value 0
# - Edge thickness according to value
# - Node size

#plot(s, edge.arrow.size=.4,vertex.label=NA)