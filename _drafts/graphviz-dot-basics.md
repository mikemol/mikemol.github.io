---
layout: post
title:  "Dot Language Basics"
date:   2018-02-04 15:40:00 -0500
categories: graphviz dot
---

I was asked to do a piece on the basics of Graphviz. I'm going to assume you can find a way to access the software; anything I say here will be out of date soon enough. So I'm just going to talk about Graphviz and the Dot language itself.

## Graphviz and Dot are Different Things

No, they really are. Just like `cc` and the C language are different things, so are Graphviz and Dot. Graphviz is a distribution of programs that implement (and extend) the Dot language.

## A simple undirected graph

```dot
graph {
    a
    b
    c -- d
}
```

### Nodes

### Edges

## A more complicated undirected graph

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

### `circo` Layout Engine

### `fdp` Layout Engine

### `neato` Layout Engine

### `osage` Layout Engine

### `patchwork` Layout Engine

### `sfdp` Layout Engine

### `twopi` Layout Engine

## With Clusters

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

### `circo` Layout Engine

### `fdp` Layout Engine

### `neato` Layout Engine

### `osage` Layout Engine

### `patchwork` Layout Engine

### `sfdp` Layout Engine

### `twopi` Layout Engine
