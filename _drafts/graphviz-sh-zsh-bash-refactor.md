---
layout: post
title:  "Sh-Zsh-Bash Chart Refactor"
date:   2018-01-05 21:32:00 -0500
categories: graphviz refactor sh zsh bash
---
# Sh-Zsh-Bash Chart Refactor

So, on the Grand Rapids Slack team, T.J. Zimmerman shared an interesting chart (originally by [Peter Ward](https://github.com/flowblok), from his blog post [here](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html)) which showed the behaviors of `sh`, `zsh` and `bash` as they built (and tore down) their environments in each of (non-)remote, (non-)login and (non-)interactice sessions. It was interesting in that it conveyed a huge amount of very useful information, but I was, well, offended that it didn't seem to do so well.

I haven't (yet) secured Peter's permission to embed his image here, so you'll have to go look at it in his blog post listed above. But I'll describe my issues with it here.

Before I continue, let be clear that he clearly did a huge amount of research building his post (and his charts), and the information he assembled visually is quite valuable. He gets the credit for the research.

That said...

## Concerns

1. I found the chart to be difficult to process, visually; I'm not in any degree color-blind, but the closely-spaced lines were difficult to follow, and more than once while rebuilding the chart, I followed the wrong branch at one point or another because of the color-coded switchback approach.
1. If you don't read the supporting text around the chart, it's not clear what the `/etc/bash.bashrc -> {~/.profile, ~/.bash_profile, ~/.bash_login} -> running` construct means; I initially thought it implied each of `{~/.profile, ~/.bash_profile, ~/.bash_login}` would be consumed in some unclear order, but it turns out that subsequent entries in the list are only consumed if earlier entries aren't found.
1. It's very difficult to follow the flow in reverse; choose a node further down in the chart, and try to walk the chart backwards. Perhaps you'll have an easier time than I did, but I found the edges crowded and the paths complex, espcially around the `bash`-specific paths.

I thought, "I can do better than this. It won't even take that long." Well, it took me over a week of spare cycles at home to get Graphviz to produce something I was satisfied with. I was at least half-wrong, but I certainly learned a lot along the way! And, boy, did it produce a lot of blog fodder.

## Results

Here's (mostly; I found and fixed a bug or two) the same data as in the original chart, but cleaned up:

![A chart showing each of Sh, Zsh and Bash session setup and teardown workflows. Each shell variant covered includes each combination of non-login and login, non-interactive and interactive sessions. Bash further includes non-remote vs remote workflows. Non-login, non-interactive workflows are drawn in black. Non-login, interactive workflows are drawn in orange. Login, non-interactive workflows are drawn in sky blue. Login, interactive workflows are drawn in sea green. On the left is a column labeling the workflow by shell type and session type. On the right is a column containing the label 'Running...'. In between are columns with the occasional label identifying other files that may be consumed. The Sh non-login, non-interactive workflow proceeds directly to the Running state. The Sh non-login, interactive workflow evaluates $ENV, and then proceeds to the Running state. The Sh login, non-interactive state evaluates ~/.profile, then proceeds to the Running state. The Sh login, interactive state evaluates ~/.profile, then $ENV, and finally proceeds to the Running state. The Zsh non-login, non-interactive workflow evaluates /etc/zshenv, then ~/.zshenv, and then proceeds to the Running state. The Zsh non-login, interactive workflow evaluates ~/etc/zshenv, then ~/.zshenv, and finally ~/.zshrc before proceeding to the Running state. The Zsh login, non-interactive state evaluates ~/etc/zshenv, then ~/.zshenv, then ~/.zprofile, ~/.zlogin, then enters the Running state, and finally evaluates ~/.zlogout. The Zsh login, interactive workflow evaluates ~/.etc/zshenv, ~/.zshenv, ~/.zprofile, ~/.zshrc, ~/.zlogin, and then the Running state before proceeding to evaluate ~/.zlogout. The Bash Non-remote, Non-login, non-interactive workflow evaluates $BASH_ENV before proceeding to the Running state. The Bash non-remote, non-login, non-interactive state evaluates /etc/bash.bashrc, then ~/.bashrc, and finally proceeds to the Running state. The Bash non-remote, login, non-interactive workflow evaluates /etc/profile. It then attempts to evaluate each of ~/.profile, ~/.bash_login and ~/.bash_profile. If it finds one, it skips the rest and evaluates $BASH_ENV before proceeding to the Running state and finally evaluating ~/.bash_logout. The Bash non-remote, login, interactive workflow evaluates /etc/profile. It then attempts to evaluate each of ~/.profile, ~/.bash_login and ~/.bash_profile. If it finds one, it skips the rest and proceeds to the Running state before evaluating ~/.bash_logout. The Bash remote, non-login, non-interactive workflow evaluates /etc/bash.bashrc, then ~/.bashrc before proceeding to the Running state. The Bash remote, non-login, interactive workflow proceeds immediately to a label reading 'No path', and does not proceed further. The Bash Remote Login Non-Interactive workflow evaluates /etc/profile. It then attempts to evaluate each of ~/.profile, ~/.bash_login and ~/.bash_profile. If it finds one, it skips the rest and evaluates $BASH_ENV before proceeding to the Running state and finally evaluating ~/.bash_logout. Where ~/.profile, ~/.bash_login and ~/.bash_profile are considered, the first two are represented by a trio of boxes arranged with the name of the file in one box, 'Found' and 'Not found' in the other box. Lines lead into the box naming the file, while lines lead out from the 'Found' or 'Not found' boxes to signify whether th file in question was found or not. The trio of boxes are bound tightly to each other, and both trios of boxes and the ~/.bash_profile are arranged in a common column, top to bottom, in the order they're considered. The same column is shared by the box trios found for similar logic sequences in each other workflow that needs to consider ~/.profile, ~/.bash_login and ~/.bash_profile. Files of the same (or sufficiently similar) name are placed in the same columns, with dotted lines connecting them. Every instance of /etc/zshenv is connected with a dotted line, as is every instance of ~/.zshenv, every instance of /etc/profile, ~/.bashrc, and so on.]({{ site.url }}/assets/sh-zsh-bash-refactor/refactor-output/refactor-output.svg)

So, again, we're covering each of `sh`, `zsh` and `bash`, with every combination of shell, (non)remote, (non)login and (non)interactive, where the shell supports the distinction. (Only `bash` recognizes remote shells.)

### Swimlanes

The first thing to notice is the use of swimlanes.

![There is a single horizontal line drawn, with labels representing activities along it. The line is blueish-green and begins with Zsh Login Interactive, proceeds to /etc/zshenv, then to ~/.zshenv, ~/.zprofile, ~/.zshrc, ~/.zlogin, the Running state, and finally to ~/.zlogout.]({{ site.url }}/assets/sh-zsh-bash-refactor/swimlane/swimlane.svg)

Instead of using a particular-colored line bouncing from file node to file node shared with other colored lines, we use a single swimlane to identify a single combination of session parameters. While this makes the chart decidedly less compact, it reduces a great deal of pressure on the layout engine, letting us do much more tweaking, and giving us the option of packing in more information without the output looking like a tangled mess of spaghetti.

#### Swimlanes Origins / Rationale

The use of swimlanes came out of my earlier attempt to reformulate the chart as a truth table. This was before I discovered the special conditional relationships between ~/.profile, ~/.bash_login and ~/.bash_profile. Earlier still, I'd attempted to replace the nodes in the original chart with clusters where each workflow would stop off at a workflow-dedicated node in a cluster corresponding to the file being evaluated. If you're having a difficult time picturing that, don't worry; so did the layout engine&emdash;it gave me a bunch of spaghetti, in large part because it tries to route edges around clusters, rather than through them.

### Granular Same-Rank Association

The columnar behavior is in part because Graphviz thinks of this as a directed graph, but the placement of this or that in a given column comes from using the `rank=same` attribute in an anonymous subgraph. The syntax looks like this:

```dot
    {
        rank=same
        node [label="/etc/zshenv"]
        zsh_nn_etc_zshenv ->
        zsh_ni_etc_zshenv ->
        zsh_ln_etc_zshenv ->
        zsh_li_etc_zshenv
    }
```

The above code results in all of the `/etc/zshenv` nodes being in the same rank (and thus the same column, in this graph), and draws the eye-guiding edges connecting the nodes.

What's interesting about this approach is that while the above nodes will be in the same rank, we're not forcing them to be the _only_ things in that rank. If you find the `/etc/zshenv` nodes in the graph and look around, you'll find a node labeled "No Path" in the same rank! But since, the "No Path" node isn't part of the same series of directed, constraining edges that form the swimlanes, there's no reason for the layout engine to not put the node in the lowest rank following the session label node.

If we forced the column/rank to be _exclusive_ to our `/etc/zshenv` nodes (or the "No Path" node), we'd need an additional column/rank to fit all of the nodes, and the chart would be physically larger as a result, to no real gain.

#### `rank=same` Origins / Rationale

I originally tried to use common nodes, and then clusters, to group common points in the different workflows, but I invariably wound up with spaghetti flows. When you use clusters, Graphviz will try to pull the nodes in a cluster into the smallest possible space, distorting the graph outside of the cluster. However, the anonymous subgraph using `rank=same` doesn't have that distorting effect; it only forces nodes into a given rank.

The more I used constraining tools like clusters and edges with `[constraint=true]` (which is the default), the harder it became to avoid spaghetti. I felt like the Emporer; the tighter I gripped, the more slipped through my grasp. The more I relaxed, the easier it became.

### Eye-Guiding, Non-Constraining Lines

If you look at the `/etc/zshenv` nodes, you can see a small dotted line connecting them. The dotted line is invariably vertical; they're all within the `rank=same` groupings noted above, and are there to draw your eye along the column and help you identify role-related nodes. They also help drive the association that a column is a grouping, even without a column header.

#### Eye-guide Origins / Rationale

Without the clear bounding boxes offered by clusters, I wanted a way to get visible groupings. Drawing non-constraining lines provided that. A dotted line is less distracting from the swimlanes than a solid line would be.

### Colors

### HTML-like labels for Choices

### Same-rank, Constraining Edges
