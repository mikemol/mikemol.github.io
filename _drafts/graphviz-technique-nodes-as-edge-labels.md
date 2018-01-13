---
layout: post
title:  "Nodes as Labels"
date:   2018-01-12 19:36:00 -0500
categories: jekyll update nodes edges labels layout graphviz dot
---

So, let's revisit [my last post]({{page.previous.url}}), and look at one of the charts I built for it. It uses a technique I've found works around Dot's limited support for handling edge labels well. 

First, I apologize if I state some obvious things in here; Dot and Graphviz operate on a lot of computer science principles, and that's not my background. So I apologize for boring of you who already know what I'm talking about.

Edges in Dot are connections between nodes. Here's an example of two nodes, `A` and `B`, with an edge connecting `A->B`:

![Two nodes, labeled A and B. There is a line connecting node A to B, with an arrowhead pointing at node B.]({{ site.url }}/assets/graphviz-techniques-nodes-as-edge-labels/node-node/node-node.svg)

Here are those same two nodes and an edge, plus an edge label:

![Two nodes, labeled A and B. There is a line connecting node A to B, with an arrowhead pointing at node B. Overlapping the middle of the line begins the string 'A descriptive label'.]({{ site.url }}/assets/graphviz-techniques-nodes-as-edge-labels/node-edge-label/node-edge-label.svg)

Notice how the string 'A descriptive label' begins with some overlap on the edge? It doesn't look great. Now let's compound the issue by adding two more nodes, and giving all the edges the same label. (This is a common circumstance if, for example, you have something that has the same kind of relationship to several other things, and you want to express what type of relationship that is.)

![Four nodes, labeled A, B, C and D. There is a line connecting node A to each of B, C and D, with an arrowhead pointing at each of B, C and D. At the middle of each line begins the string 'A descriptive label'. In the case of the edge connecting A to C, the string labeling A-to-B encroaches on the A-to-C line, and in the case of the edge connecting A to D, the string labeling the A-to-C line encroaches on the A-to-D line.]({{ site.url }}/assets/graphviz-techniques-nodes-as-edge-labels/node-edge-label-many/node-edge-label-many.svg)

Now there isn't quite so much overlap (only `A->C` is actually vertical, so it winds up more crowded), but all of the edge labels still crowd the edges they label, as well as anything else they're crowding out.

We can clean this up significantly by, surprisingly enough, adding _another_ node. We'll play with some styling to make it look nice; the node we add won't be obviously recognizable as a node.

![Four nodes, labeled A, B, C and D. There is a line connecting node A to a space where the string 'A descriptive label' resides. This is the only lengthy string. There is an arrowhead on this line pointing at that string. From the string there are lines to each of B, C and D, with an arrowhead pointing at each of B, C and D.]({{ site.url }}/assets/graphviz-techniques-nodes-as-edge-labels/node-node-label/node-node-label.svg)

What we've done is pointed `A` at a node which we've given the `style` of `none`, so its border disappears, and we've given this node the label that we were previously applying to edges. Then we take this label-node and draw edges to `C`, `D` and `E`.

This does two things for us. First and foremost, Graphviz treats only nodes and edges as first-order objects, meaning they get the most attention when developing layout engines, and their placement and behavior is the cleanest and most reliable of all the things that might be drawn. Edge labels and clusters (we'll talk about those in another post) don't get as much love. In some layout engines, edge labels will be drawn, but you'll be shown a warning that edge labels aren't supported. And most layout engines don't support clusters at all!

So by using nodes where we might otherwise use edge labels or clusters, we get a more predictable result from Graphviz's layout engine.

Second, instead of needing one label for each edge, we can use one label for _all_ edges. That often saves a considerable amount of space in the graph layout, which makes it easier to build large or complex graphs without sacrificing as much readability.

Now see what the last post's chart would look like if it used edge labels instead of nodes as labels.

![Flow diagram of blog workflow. Labels are drawn over by edges in several places, several edge labels crowd other edges, and the "for writing to" edge appears to be missing; it's been drawn on top of the "Primary interface for" edge.]({{ site.url }}/assets/graphviz-techniques-nodes-as-edge-labels/blog-workflow-edgelabel/blog-workflow-edgelabel.svg)

See how the labels are being drawn over by edges? Granted, I have splines turned off, but it doesn't really help to turn them back on, except to get the "For writing to" edge drawn where you can see it again:

![Flow diagram of blog workflow. Labels aren't being drawn over by edges, but they are crowding several edges, with some edges taking strange circumlocutive routes. The edges themselves look dented and bent.]({{ site.url }}/assets/graphviz-techniques-nodes-as-edge-labels/blog-workflow-edgelabel-splines/blog-workflow-edgelabel-splines.svg)

Here, labels aren't being drawn over by edges, but they're very crowded. Notices the edge between Graphviz and SVG; it takes a very long route, and it look very dented as it passes near various other edges and labels; the layout engine had a difficult time finding it a clear path.

But if we use nodes in place of edge labels, it cleans up nicely:

![Flow diagram of content creation. The diagram is much taller than previous diagrams, but it's also much narrower. No edge overlaps any label, and there's a clear margin of space between label text and edges, aiding readability.]({{ site.url }}/assets/graphviz-techniques-nodes-as-edge-labels/blog-workflow/blog-workflow.svg)

The diagram is much taller than previous diagrams, but it's also much narrower. No edge overlaps any label, and there's a clear margin of space between label text and edges, aiding readability. We were also able to use nodes-as-labels to create concentration points; see where `Visual Studio Code`, `SVG` and `PNG` all point to `For writing to` before moving on to `Local git repo`? By being able to reuse the same label, we were able to take a great deal of strain off of the layout engine and let it give us a much cleaner result.

So, there. A fairly simple technique, but it carries a _big_ impact. May you find it useful!
