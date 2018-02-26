---
layout: post
title:  "Dot Language Basics Pt 2: Layout Engines, Clusters and Complicated Undirected Graphs"
date:   2018-02-27 09:00:00 -0500
categories: graphviz dot
---
# Dot Language Basics Pt 2: Layout Engines, Clusters and Complicated Undirected Graphs

So, we covered simple, undirected graphs. Let's look at a couple more complicated cases, one with clustering and one without, so we can explore layout engines.

```dot
graph {
    A [style="filled" fillcolor="#F0E442" color="#E69F00" penwidth=8]
    B [style="filled" fillcolor="#F0E442" color="#009E73" penwidth=8]
    C [style="filled" fillcolor="#F0E442" color="#CC79A7" penwidth=8]
    D [style="filled" fillcolor="#56B4E9" color="#E69F00" penwidth=8]
    E [style="filled" fillcolor="#56B4E9" color="#009E73" penwidth=8]
    F [style="filled" fillcolor="#56B4E9" color="#CC79A7" penwidth=8]
    G [style="filled" fillcolor="#D55E00" color="#E69F00" penwidth=8]
    H [style="filled" fillcolor="#D55E00" color="#009E73" penwidth=8]
    I [style="filled" fillcolor="#D55E00" color="#CC79A7" penwidth=8]

    A -- B
    B -- C
    C -- A

    D -- E
    E -- F
    F -- D

    G -- H
    H -- I
    I -- G

    A -- D
    B -- G
    H -- E
}
```

Remember, this is a _cyclic_ graph; within the graph, there exist two nodes which have more than one path to reach each other. In fact, it's pretty easy to identify three cyclic _subgraphs_ within the larger graph; `A-B-C`, `D-E-F` and `G-H-I`, and these smaller subgraphs are connected to each other. For visualizations' sake, I've added color information to each node, so the nodes will be easier to identify. Since we're dealing with three sets of three nodes, I've color-coded each node based on both which grouping it's part of, and which member of which grouping it is.

Now let's consider how we might draw attention to those subgraphs in the Dot language, by wrapping them up with clusters:

```dot
graph {
    A [style="filled" fillcolor="#F0E442" color="#E69F00" penwidth=8]
    B [style="filled" fillcolor="#F0E442" color="#009E73" penwidth=8]
    C [style="filled" fillcolor="#F0E442" color="#CC79A7" penwidth=8]
    D [style="filled" fillcolor="#56B4E9" color="#E69F00" penwidth=8]
    E [style="filled" fillcolor="#56B4E9" color="#009E73" penwidth=8]
    F [style="filled" fillcolor="#56B4E9" color="#CC79A7" penwidth=8]
    G [style="filled" fillcolor="#D55E00" color="#E69F00" penwidth=8]
    H [style="filled" fillcolor="#D55E00" color="#009E73" penwidth=8]
    I [style="filled" fillcolor="#D55E00" color="#CC79A7" penwidth=8]

    subgraph clusterA {
        A -- B
        B -- C
        C -- A
    }

    subgraph clusterB {
        D -- E
        E -- F
        F -- D
    }

    subgraph clusterC {
        G -- H
        H -- I
        I -- G
    }

    A -- D
    B -- G
    H -- E
}
```

Let's see how Graphviz handles these two very similar graphs, using the default `dot` layout engine:

| Clustered | Non-clustered |
| --- | --- |
| ![There are three groupings of nodes making up small, cyclic graphs, A-B-C, D-E-F and G-H-I. Each small cyclic graph is within its own rectangle, and the nodes within each rectangle are arranged in order, from top to bottom. The A-B-C cluster is at the top left, the G-H-I cluster is in the middle, and the D-E-F cluster is in the bottom-right. Connecting these smaller cyclic graphs are are a small set of lines, A--D, B--G and H--E.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph-clustered/complicated-undirected-graph-clustered.svg) | ![There are three groupings of nodes making up small, cyclic graphs, A-B-C, D-E-F and G-H-I. Connecting these smaller cyclic graphs are are a small set of lines, A--D, B--G and H--E. A is at the top of the overall graph, with B and C nearby. G, H and I are near the middle of the graph, and D, E and F are near the bottom of the graph.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph/complicated-undirected-graph.svg) |

Notice how in both the clustered and non-clustered cases, `A-B-C` is near the top of the graph, `D-E-F` is near the bottom, and `G-H-I` is near the middle of the graph. However, in the clustered case, each of the three groups are much more compact.

Let's look at some other layout engines.

### `circo` Layout Engine

The `man` page description for `circo` is quite a mouthful, and reads:

> `circo` draws graphs using a circular layout (see [Six and  Tollis,  GD  '99  and ALENEX  '99](https://scholar.google.com/scholar?cluster=9494396738495206724&hl=en&as_sdt=0,23), and [Kaufmann and Wiese, GD '02](https://scholar.google.com/scholar?cluster=278384429215122705&hl=en&as_sdt=0,23). The tool identifies biconnected components and draws the nodes of the component on a  circle. The  block‐cut‐ point tree is then laid out using a recursive radial algorithm. Edge crossings within a circle are minimized by placing as many edges on the circle's perimeter as possible. In particular, if the component is outerplanar, the compo‐ nent will have a planar layout.

> If a node belongs to multiple non‐trivial biconnected components, the layout puts the node in one of them. By default, this is the first non‐trivial component found in the search from the root component.

Here's what that means in practice for these graphs:

| Clustered | Non-clustered |
| --- | --- |
| ![There are three groupings of nodes making up small, cyclic graphs, A-B-C, D-E-F and G-H-I. Connecting these smaller cyclic graphs are are a small set of lines, A--D, B--G and H--E. The three small, cyclic graphs are distributed around a circle, with all nodes the same distance from the center of the circle.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph-clustered-circo/complicated-undirected-graph-clustered-circo.svg) | ![There are three groupings of nodes making up small, cyclic graphs, A-B-C, D-E-F and G-H-I. Connecting these smaller cyclic graphs are are a small set of lines, A--D, B--G and H--E. The three small, cyclic graphs are distributed around a circle, with all nodes the same distance from the center of the circle.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph-circo/complicated-undirected-graph-circo.svg) |

The first thing you'll notice is that both renders look identical; the `cluster` keyword is not part of the Dot language itself, and so whether or not it does anything depends on the layout engine.

You can see the circle, and if you look, you can find the small subgraphs, but they're not obvioius. Notice `circo` did not choose to place the `A` node next to the `D` node, even though that would have resulted in shorter edges and a cleaner result. When Graphviz does that sort of thing, it usually means that placement of nodes is somehow dependent on the listing order of the nodes in the source file itself, and you can usually get the result you're looking for by reordering the content in the source file.

### `fdp` Layout Engine

The `man` page description for `fdp` is brief:

> `fdp` draws undirected graphs using a ``spring'' model. It relies  on  a  force‐directed  approach  in  the  spirit of Fruchterman and Reingold (cf. [Software‐Practice & Experience 21(11), 1991, pp. 1129‐1164](https://scholar.google.com/scholar?cluster=15659702693092844398&hl=en&as_sdt=0,23)).

Here's what that means for these graphs:

| Clustered | Non-clustered |
| --- | --- |
| ![There are three groupings of nodes making up small, cyclic graphs, A-B-C, D-E-F and G-H-I. Each small cyclic graph is within its own box. The A-B-C cluster is at the top left, the G-H-I cluster is in the middle at the bottom, and the D-E-F cluster is in the top-right. Connecting these smaller cyclic graphs are are a small set of lines, A--D, B--G and H--E.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph-clustered-fdp/complicated-undirected-graph-clustered-fdp.svg) | ![There are three groupings of nodes making up small, cyclic graphs, A-B-C, D-E-F and G-H-I. Connecting these smaller cyclic graphs are are a small set of lines, A--D, B--G and H--E. The D-E-F cluster is near the top, while the A-B-C and G-H-I clusters overlap each other at the bottom.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph-fdp/complicated-undirected-graph-fdp.svg) |

The clustered version of this graph looks very fine in `fdp`; the graph isn't quite as compact as it could be, but the clusters, at least, highlight the structure of the graph, and are themselves close to each other. The non-clustered version of this graph, however, has no obvious structure; the `A-B-C` triad overlaps the `G-H-I` triad, and looks like a mess.

### `neato` Layout Engine

The `man` page description for `neato` is also brief:

> `neato`  draws  undirected graphs using ``spring'' models (see [Kamada and Kawai, Information Processing Letters 31:1, April 1989](https://scholar.google.com/scholar?cluster=3559379059294964525&hl=en&as_sdt=0,23)).

This doesn't tell you much, but the results speak for themselves:

| Clustered | Non-clustered |
| --- | --- |
| ![There are three groupings of nodes making up small, cyclic graphs, A-B-C, D-E-F and G-H-I. Connecting these smaller cyclic graphs are are a small set of lines, A--D, B--G and H--E. D-E-F is at the top of the graph, A-B-C is at the lower-left, and G-H-I is at the lower right. D-E-F has its D node to the left, while A-B-C has its A node at the top, resulting in only a short distance for the A-D edge. D-E-F has its E node to the right, while G-H-I has its H node at the top, leading to a similarly short edge for E-H. A-B-C has its B node to the right, while G-H-I has its G node to the left, leading to a short B-G edge as well.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph-clustered-neato/complicated-undirected-graph-clustered-neato.svg) | ![There are three groupings of nodes making up small, cyclic graphs, A-B-C, D-E-F and G-H-I. Connecting these smaller cyclic graphs are are a small set of lines, A--D, B--G and H--E. D-E-F is at the top of the graph, A-B-C is at the lower-left, and G-H-I is at the lower right. D-E-F has its D node to the left, while A-B-C has its A node at the top, resulting in only a short distance for the A-D edge. D-E-F has its E node to the right, while G-H-I has its H node at the top, leading to a similarly short edge for E-H. A-B-C has its B node to the right, while G-H-I has its G node to the left, leading to a short B-G edge as well.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph-neato/complicated-undirected-graph-neato.svg) |

The first thing you should notice: There's no difference between the clustered and non-clustered versions. Just the same, you can _very_ clearly see all three cyclic subgraphs, they're well-spaced from each other, and their interconnections are very clear. The `neato` layout engine is very well-suited to this graph, clusters or no.

### `patchwork` Layout Engine

The `man` page description for `patchwork` describes something different:

> patchwork draws the graph as a  squarified  treemap  (see  [M.  Bruls  et  al., "Squarified treemaps", Proc. Joint Eurographics and IEEE TCVG Symp. on Visualization, 2000, pp. 33-42](https://scholar.google.com/scholar?cluster=16156845309181182620&hl=en&as_sdt=0,23)). The clusters of the graph are used to  specify  the tree.

| Clustered | Non-clustered |
| --- | --- |
| ![A grid is presented. The grid is three rows tall, the first row contains A, B, D, E, the second row contains C (spanning beneath A and B) and F (spanning beneath D and E), and the third row contains G, H and I. No edges are presented.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph-clustered-patchwork/complicated-undirected-graph-clustered-patchwork.svg) | ![A single 3x3 grid is presented. The nodes A, B and C occupy the first row. The nodes D, F and H occupy the second row. The nodes E, G and I occupy the third row. No edges are presented.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph-patchwork/complicated-undirected-graph-patchwork.svg) |

All edge information appears to have been lost in this render. That said, compare the clustered and non-clustered versions. In the clustered version, you can clearly see `A-B-C` grouped, `D-E-F` grouped, and `G-H-I` grouped. This behavior is called [treemapping](https://en.wikipedia.org/wiki/Treemapping).

### `twopi` Layout Engine

The `man` page description for `twopi` describes it as:

> twopi draws graphs using a radial layout (see [G.  Wills,  Symposium  on  Graph Drawing  GD'97, September, 1997](https://scholar.google.com/scholar?cluster=13431559378469939199&hl=en&as_sdt=0,23)).  Basically, one node is chosen as the center and put at the origin.  The remaining nodes are placed on a sequence  of  con centric  circles  centered about the origin, each a fixed radial distance from the previous circle.  All nodes distance 1 from the center are placed  on  the first  circle; all nodes distance 1 from a node on the first circle are placed on the second circle; and so forth.

| Clustered | Non-clustered |
| --- | --- |
| ![There are three groupings of nodes making up small, cyclic graphs, A-B-C, D-E-F and G-H-I. Connecting these smaller cyclic graphs are are a small set of lines, A--D, B--G and H--E. G-H-I is near the top of the graph, A-B-C near the middle, and D-E-F is near the bottom-left. B--G and A--D are short edges connecting their two subgraphs, but E--H spans more or less from the top right through the center to the bottom left.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph-clustered-twopi/complicated-undirected-graph-clustered-twopi.svg) | ![There are three groupings of nodes making up small, cyclic graphs, A-B-C, D-E-F and G-H-I. Connecting these smaller cyclic graphs are are a small set of lines, A--D, B--G and H--E. G-H-I is near the top of the graph, A-B-C near the middle, and D-E-F is near the bottom-left. B--G and A--D are short edges connecting their two subgraphs, but E--H spans more or less from the top right through the center to the bottom left.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph-twopi/complicated-undirected-graph-twopi.svg) |

Unfortunately, this doesn't work well for this graph. If I had to guess, I'd suspect it's largely because the structure of the graph has symmetry; the layout engine is having a hard time finding a node that's meaningful. There are ways we could help it; you can [specify the center node](https://www.graphviz.org/doc/info/attrs.html#d:root), for example, and you can create [invisible](https://www.graphviz.org/doc/info/attrs.html#d:style) nodes and edges. Invisible nodes and edges are quite useful on their own, and we'll cover those in another post.
