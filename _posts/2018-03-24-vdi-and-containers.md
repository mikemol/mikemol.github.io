---
layout: post
title:  "VDI and Containers"
date:   2018-03-24 18:00:00 -0400
categories: containers
---

# VDI and Containers

The more I dig into containers, the more I'm convinced they should be used to implement VDI. An easy start would be to use a single container for the entire login session, accessed using a thin client running X or RDP.

Then, it would be interesting to see how much work is needed to make the various IPC mechanisms container-transparent. Unix domain sockets. IP connections to `localhost`. Shared memory.

Shared memory is probably the hardest, but some work has already been done there; Linux already has some code for live-migrating virtual machine's memory and block storage between hosts, and it'd be interesting to see how that work could be translated to sharing state for IPC mechanisms. You might be able to drive it using memory barrier instructions, similar to how VMWare did CPU virtualization before hardware-accelerated virtualization was a thing on PCs. You'd only want to trap membar instructions if executed by processes that have remote-memory file descriptors open, and there'd need to be some work to track what those are...

Sounds like fun.
