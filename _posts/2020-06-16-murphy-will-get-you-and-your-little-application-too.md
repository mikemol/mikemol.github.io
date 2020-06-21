---
layout: post
title:  "Murphy Will Get You, and Your Little Application, Too"
date:   2020-06-14 21:00:00 -0400
categories: sre devops
tags: sre devops
---

Let's say you have an application that has two things depending on it. Every time you make a change, let's say there's a 10% chance of breaking a given consumer, which means that same change has a _19%_ chance of breaking _either_ consumer. That 19% chance of failure compounds to _45%_ on your second change. By four changes, you'll have had a 57% chance of one of those changes having broken _something_. The numbers get significantly worse the more unique consumers you have, the more changes you make, and the more risky the individual customer. At the same time, for whatever reason, you need to make changes in response to needs. This is very difficult problem. Entire books, entire _degrees_ are dedicated to teaching the analysis of complicated systems and mitigating risk in them. Tackling this problem is the _basis_ behind Site Reliability Engineering. It can't be tackled in a single blog post. So what do you do?

So, this post was going to be about some specific techniques and thinking habits I've evolved, but the prelude wanted to turn the post into a complete treatment of devops and SRE. That seems a bit out of scope for a single blog post, so this one's going back on the drafts pile while I review the literature, distill it into key points and categories, and figure out where my thoughts don't simply repeat what's already been said somewhere.
