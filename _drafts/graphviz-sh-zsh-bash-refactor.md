---
layout: post
title:  "Sh-Zsh-Bash Chart Refactor"
date:   2018-01-05 21:32:00 -0500
categories: graphviz refactor sh zsh bash
---

So, on the Grand Rapids Slack team, T.J. Zimmerman shared an interesting chart (originally by [Peter Ward](https://github.com/flowblok), from his blog post [here](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html)) which showed the behaviors of `sh`, `zsh` and `bash` as they built (and tore down) their environments in each of (non-)remote, (non-)login and (non-)interactice sessions. It was interesting in that it conveyed a huge amount of very useful information, but I was, well, offended that it didn't seem to do so well.

I haven't (yet) secured Peter's permission to embed his image here, so you'll have to go look at it in his blog post listed above. But I'll describe my issues with it here.

Before I continue, let be clear that he clearly did a huge amount of research building his post (and his charts), and the information he assembled visually is quite valuable. He gets the credit for the research.

That said...

1. I found the chart to be difficult to process, visually; I'm not in any degree color-blind, but the closely-spaced lines were difficult to follow, and more than once while rebuilding the chart, I followed the wrong branch at one point or another because of the color-coded switchback approach.
1. If you don't read the supporting text around the chart, it's not clear what the `/etc/bash.bashrc -> {~/.profile, ~/.bash_profile, ~/.bash_login} -> running` construct means; I initially thought it implied each of `{~/.profile, ~/.bash_profile, ~/.bash_login}` would be consumed in some unclear order, but it turns out that subsequent entries in the list are only consumed if earlier entries aren't found.
1. It's very difficult to follow the flow in reverse; choose a node further down in the chart, and try to walk the chart backwards. Perhaps you'll have an easier time than I did, but I found the edges crowded and the paths complex, espcially around the `bash`-specific paths.
