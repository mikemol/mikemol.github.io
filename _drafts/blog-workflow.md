---
layout: post
title:  "Blog Workflow"
date:   2018-01-09 20:21:00 -0500
categories: jekyll update graphviz tooling
---

So, I was asked what my "platform" was, and I wasn't exactly sure what was meant. I can, however, discuss the tools and workflow involved, and take advantage of that discussion to actually refine it a bit. I might even create a dedicated page to it at some point.

So, here's a chart of the content flow and the tools content passes through.

![Flow diagram of content creation. Content is authored Visual Studio Code. Visual Studio Code previews Markdown and Dot. Visual Studio Code is the primary interface for the local Git repository. Visual Studio Code is used for writing content into the local Git repository. The local Git repository is read from by the local Jekyll engine. The local git repository is read from by GraphViz for rendering Dot into SVG and PNG, which are written into the local Git repository. The Local Git repository pushes to the GitHub Git repository, which feeds the Jekyll engine running on GitHub Pages. The Jekyll engine on GitHub Pages integrates Google Analytics into its output. The Jekyll engine on GitHub Pages generates an RSS feed, which is monitored by IFTTT. IFTTT Posts to LinkedIn, Twitter, Facebook and Reddit. IFTTT Adds posts to Buffer, which posts to Google Plus.]({{ site.url }}/assets/blog-workflow/blog-workflow/blog-workflow.svg)

## Content is authored in Visual Studio Code

With its ability to preview Markdown and Dot, Visual Studio Code makes for a great WYSIWYM editor.

Its strong Git integration makes storing the blog source in Git a natural conclusion. (And if you want to cheat and peek under the hood for this blog, [you can do that](https://github.com/mikemol/mikemol.github.io). Feel free to judge me for the consistency of my git behavior. Keeps me honest.)

## Graphic artifacts are rendered using GraphViz

I'm not hot with Inkscape. I don't have Adobe whatever. But, frankly, images are for telling stories, and the Dot language is fantastic for helping you define your image as a story. For example, you can see the story (in Dot language) for the above flow diagram [here]({{ site.url }}/assets/blog-workflow/blog-workflow/blog-workflow.dot). I find Dot to be a great language to try to tell a story in, and I find GraphViz to be helpfully unforgiving when my story is too complicated for presentation. I invariably find myself using GraphViz's layout behavior (and occasional recalcitrance when it won't do quite what I want) as a warning for when I'm not telling a story clearly or well, or when I've glossed over details, or when the story is _just plain wrong_ for the goals it's supposed to serve.

I render the Dot language content into PNG and SVG, which I save back into the local Git repository, next to the Dot file that generated them.

## GitHub Hosts the Content

My local git repository pushes up to the repository on GitHub, and GitHub maintains a Jekyll setup there to convert the contents of the repository into a bunch of static files. This works more or less OK (troubleshooting is tough at times), but it's free, and it's portable enough for me to take my content wherever I want.

Jekyll on GitHub also integrates Google Analytics for me. It's nice to see if anyone's actually reading what I'm writing.

## IFTTT Handles (most of) the publication

Jekyll generates an RSS feed, which IFTTT consumes. When new content appears, IFTTT posts to LinkedIn, Twitter, Facebook and Reddit. IFTTT doesn't have direct support for posting to Google+, but it does support adding links to a Buffer queue, and Buffer can post to Google+. So I have Buffer doing a scheduled drain into Google+. It seems to work.

## That's it!

That's it! That's my "platform." The set of tools I use to move content from my head to your eyes. It's not quite as easy as, say, a Wordpress install. But it requires a lot less operational support, at least from me. Which is a nice change of pace.
