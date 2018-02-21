---
layout: post
title:  "Dot Language Basics"
date:   2018-02-04 15:40:00 -0500
categories: graphviz dot
---
# Dot Language Basics Pt 1: Nodes, Edges and Simple Undirected graphs

I was asked to do a piece on the basics of Graphviz. I'm going to assume you can find a way to access the software; anything I say here will be out of date soon enough. So I'm going to talk about the Dot language itself, and how a handful of simple graphs behave in different layout engines.

## Graphviz and Dot are Different Things

No, they really are. Just like `cc` and the C language are different things, so are Graphviz and Dot. Graphviz is a distribution of programs that implement (and extend) the Dot language.

## A simple undirected graph

Wait, first, what's a graph? A graph is a set of nodes connected by edges. That's it. Here's an example:

```dot
graph {
    a -- b
}
```

So you see two nodes, named `a` and `b`, and the two nodes are connected by a single edge.

![Two nodes, labeled 'a' and 'b'. There is a line connecting node 'a' to 'b'.]({{ site.url }}/assets/graphviz-dot-basics/simple-undirected/simple-undirected.svg)

To create a node in Dot, all you need to do is mention it by name. This can be on its own, or while declaring an edge. So, this graph is identical to the above:

```dot
graph {
    a
    b
    a -- b
}
```

![Two nodes, labeled 'a' and 'b'. There is a line connecting node 'a' to 'b'.]({{ site.url }}/assets/graphviz-dot-basics/simple-undirected2/simple-undirected2.svg)


This also happens to be an _acyclic_ graph, which means there is only one path between any two nodes in the graph. It's trivial to make this into a _cyclic_ graph:

```dot
graph {
    a -- b
    a -- b
}
```

![Two nodes, labeled 'a' and 'b'. There are two lines connecting node 'a' to 'b'.]({{ site.url }}/assets/graphviz-dot-basics/simple-cyclic/simple-cyclic.svg)

Now there are two edges between the same two nodes. Since there's more than one path between the two nodes, the graph is no longer acyclic. But drawing two edges directly between the same two nodes feels like cheating to illustrate the concept, so here's another example of a simple cyclic graph:

```dot
graph {
    a -- b -- c -- a
}
```

![Three nodes, labeled 'a', 'b' and 'c'. There is a single line connecting 'a' to 'b', a single line connecting 'b' to 'c', and a single line connecting 'c' back to 'a'.]({{ site.url }}/assets/graphviz-dot-basics/simple-cyclic2/simple-cyclic2.svg)

Now we have three nodes, `a`, `b`. `c`, and they form a loop. If you choose a node and follow the edges, you can (inevitably will, in this case) eventually wind up where you started. Since there's more than two paths between a pair of nodes, this graph is said to be _cyclic_.

For our purposes, we don't _usually_ care about whether a graph is cyclic or acyclic, but Graphviz can occasionally get confused with _directed_ cyclic graphs. More on that (well, directed graphs) later.

# Dot Language Basics Pt 2: Layout Engines, Clusters and Complicated Undirected Graphs

So, we covered simple, undirected graphs. Let's look at a more complicated case, so we can briefly explore the available layout engines.

```dot
graph {
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

Remember, this is a _cyclic_ graph; within the graph, there exist two nodes which have more than one path to reach each other. In fact, it's pretty easy to identify three cyclic _subgraphs_ within the larger graph; `A-B-C`, `D-E-F` and `G-H-I`, and these smaller subgraphs are connected to each other. Here's a render with the basic, default `dot` layout engine:

![There are three groupings of nodes making up small, cyclic graphs, A-B-C, D-E-F and G-H-I. Connecting these smaller cyclic graphs are are a small set of lines, A--D, B--G and H--E. A is at the top of the overall graph, with B and C nearby. G, H and I are near the middle of the graph, and E, F and G are near the bottom of the graph.]({{ site.url }}/assets/graphviz-dot-basics/complicated-undirected-graph/complicated-undirected-graph.svg)

Notice how `A-B-C` is near the top of the graph, `D-E-F` is near the middle, and `G-H-I` is near the bottom of the graph. The edge `A-D` is much longer than any other edge, extending all the way from the top to the bottom of the graph. Let's look at some other layout engines.

### `circo` Layout Engine

### `fdp` Layout Engine

### `neato` Layout Engine

### `osage` Layout Engine

### `patchwork` Layout Engine

### `sfdp` Layout Engine

### `twopi` Layout Engine

## With Clusters

Now we take some of the more tightly-connected portions of our graph and explicitly instruct our layout engines to cluster them.

```dot
graph {
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

Again, a `dot` rendering:

You can see how the three groups `ABC`, `DEF` and `GHI` are now clustered together, with boxes drawn arond them.

### `circo` Layout Engine

### `fdp` Layout Engine

### `neato` Layout Engine

### `osage` Layout Engine

### `patchwork` Layout Engine

### `sfdp` Layout Engine

### `twopi` Layout Engine
