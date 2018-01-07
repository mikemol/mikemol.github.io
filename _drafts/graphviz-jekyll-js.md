---
layout: post
title:  "Graphviz content in Jekyll via Javascript"
categories: jekyll update graphviz javascript
---

So, most of what I want to write about (if you dig around GitHub, you can find my backlog as a bunch of empty draft posts) involves Dot and GraphViz. But as nice as Jekyll and Markdown are for blog posts, the simplest workflow has me separately building Graphviz assets into PNG or SVG and embedding them, and then due to GitHub limitations, ditching the SVG version, generating the PNG version at a silly size and scaling it down:

```dot
digraph graphviz-workflow {
    write_asset -> {svg png} [label="Emit outputs"]
    svg -> discard [label="GH Pages doesn't like SVG"]
    png -> rebuild -> embed -> {rewrite_asset done}

    rewrite_asset -> rebuild

    write_asset [label="Write DOT\nSeparately"]
    rebuild [label="Rebuild asset\nat higherDPI\nand scale down"]
    rewrite_asset [label="Tweak asset\nfor use case"]
}
```

...except here's the real problem: You're looking at a Dot representation of the workflow I just mentioned, not a visual representation.

What I _want_  is to be able to write Dot code inline with my posts, and have that content presented to _you_ visually.
