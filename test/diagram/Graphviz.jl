module TestGraphviz

using Base.Test
using Catlab.Diagram.Graphviz

# Pretty-print
##############

spprint(expr::Expression) = sprint(pprint, expr)

# Node statement
@test spprint(Node("n")) == "n;"
@test spprint(Node("n"; label="foo")) == "n [label=\"foo\"];"
@test spprint(Node("n"; shape="box", style="filled")) ==
  "n [shape=\"box\",style=\"filled\"];"

# Edge statement
@test spprint(Edge("n1","n2")) == "n1 -- n2;"
@test spprint(Edge("n1","n2"; label="foo")) == "n1 -- n2 [label=\"foo\"];"
@test spprint(Edge("n1","n2"; style="dotted", weight="10")) ==
  "n1 -- n2 [style=\"dotted\",weight=\"10\"];"
@test spprint(Edge("n1","p1","n2","p2")) == "n1:p1 -- n2:p2;"
@test spprint(Edge("n1","p1","n2","p2"; label="bar")) ==
  "n1:p1 -- n2:p2 [label=\"bar\"];"
@test spprint(Edge(src="n1", src_port="p1", tgt="n2", tgt_port="p2")) ==
  "n1:p1 -- n2:p2;"
@test spprint(Edge(src="n1", src_port="p1", src_anchor="w",
                   tgt="n2", tgt_port="p2", tgt_anchor="e")) ==
  "n1:p1:w -- n2:p2:e;"

# Graph statement
graph = Graph("G",
  Node("n1"),
  Node("n2"),
  Edge("n1","n2")
)
@test spprint(graph) == """
graph G {
  n1;
  n2;
  n1 -- n2;
}
"""

graph = Digraph("G",
  Node("n1"),
  Node("n2"),
  Edge("n1","n2")
)
@test spprint(graph) == """
digraph G {
  n1;
  n2;
  n1 -> n2;
}
"""

graph = Digraph("G",
  Node("n1"; label="foo"),
  Node("n2"; label="bar"),
  Edge("n1","n2");
  graph_attrs = Attributes(:rankdir => "LR"),
  node_attrs = Attributes(:shape => "box", :style => "filled"),
  edge_attrs = Attributes(:style => "dotted")
)
@test spprint(graph) == """
digraph G {
  graph [rankdir="LR"];
  node [shape="box",style="filled"];
  edge [style="dotted"];
  n1 [label="foo"];
  n2 [label="bar"];
  n1 -> n2;
}
"""

# Subgraph statement
subgraph = Subgraph("sub", 
  Node("n1"),
  Node("n2"),
  Edge("n1","n2")
)
@test spprint(subgraph) == """
subgraph sub {
  n1;
  n2;
  n1 -- n2;
}"""

subgraph = Subgraph(
  Node("n1"),
  Node("n2"),
  graph_attrs = Attributes(:rank => "same")
)
@test spprint(subgraph) == """
{
  graph [rank="same"];
  n1;
  n2;
}"""

end
