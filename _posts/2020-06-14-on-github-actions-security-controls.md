---
layout: post
title:  "On GitHub Actions Security Controls"
date:   2020-06-14 21:00:00 -0400
categories: automation github security devops
tags: automation github security devops
---

As I write this, GitHub Actions are still in beta, which is probably a good thing. To understand where I'm coming from, understand that much of my day job is currently figuring out how to engineer automated CI and CD pipelines. I must presume an auditor will inspect my process and automation, and insist I anticipate significant lapses in judgment--or even active malice--in my processes' inputs.

I won't presume to try to write a full security review of GHA; I'm not that deep into the field, and I haven't studied GHA _that_ closely. I'm also not going to try to explain GHA in detail. That's what their documentation is for, and I'm sure someone will put together an online course on it. Bully for them!

Let's dig in.

## The goods on GitHub Actions

GitHub Actions _steps_ are defined using references to specific points in the history of other `git` repositories. That's _great_ because you can lean on `git`'s intrinsic integrity and traceability assurances; Merkle trees are fantastic.

GitHub Actions pipelines are defined entirely within `git` repo state. That's good; that means that whatever your controls and processes are that govern your source code can be trivially extended to govern the automation that processes your code.

## The bad

However, defining the pipelines entirely within the `git` repository your source code exists within can be troublesome, too; consider that--for whatever reason--you may have varying trust levels of people with `write` access to your `git` repository. You trust as fully as you trust anyone, while others can't be trusted not to repurpose credentials or resources inappropriately in a pinch.

In other pipeline tools like Concourse-CI or Jenkins, you can deal with this by filtering jobs out by controlling which branches get considered for work. It's _sort of_ there with GitHub Actions, except the control point is present in the very same `git` commit as workflow code that may or may not get executed.

That means that a foolish actor *can modify both the automation actions and the instructions on whether or not to perform those actions in the same feature branch*, even the same commit. As a control point, it's not helpful.

## The ugly

GitHub tried to work around some of these issues by adding a new `workflow` scope to their OAuth token. However, it causes all kinds of issues:

- [https://github.com/gitextensions/gitextensions/issues/4916#issuecomment-557509451](https://github.com/gitextensions/gitextensions/issues/4916#issuecomment-557509451)
- [https://github.com/desktop/desktop/issues/6526](https://github.com/desktop/desktop/issues/6526)
- [https://github.com/github/VisualStudio/issues/2455](https://github.com/github/VisualStudio/issues/2455)
- [https://github.com/MicrosoftDocs/vsonline/issues/568](https://github.com/MicrosoftDocs/vsonline/issues/568)
- [https://github.com/microsoft/vscode/issues/97396](https://github.com/microsoft/vscode/issues/97396)

One comment by @jcansdale [summed it up](https://github.com/MicrosoftDocs/vsonline/issues/568#issuecomment-640726420) best:

> Not having the `workflow` scope can cause a world of pain. As well as not being able to touch workflow files, you can't push workflow changes that have been merged from `master`. Users can easily end up with branches that they can't push. 😨

If you're using OAuth app tokens to authenticate for your `git` pushes, it seems unsafe to merge; instead, you should probably rebase.

## Suggestions

GitHub should limit access to repository secrets by branch name; likely layered on top of the existing "branch protections" framework. _Alone_, this would be the single, most valuable security improvement; I could stick my secrets in operational branches defined by branch name pattern rules. (Caveat: GitHub needs to fix the bypass that allows an arbitrary user with `write` access to _create_ a nonexisting branch that matches branch protection rules.)

The control point for the logic for selecting which branches to evaluate for workflows should change. Only changes to the repository's default (Typically `master`) branch should affect branch eligibility. That way, changes to branch filtering rules must pass through whatever other controls are in place for the repository, be it `CODEOWNERS`, review requirements, or even passing linting and automated sanity checks.

GitHub should introduce an OAuth token scope that grants the same level of access as granted by SSH usage. I don't doubt we'll see more repository controls and tie-ins migrate to in-repository representations; it's too elegant a solution to integrity, transparency, and traceability to pass up. However, if GitHub introduces a new OAuth scope each time they do this, they'll wreak havoc on tools that are only trying to ship code around.

Finally, GitHub should consider making it feasible for one repository's defined workflows to respond to another repository's events. Or to allow different repositories' workflows to send events to each other so that the processing logic _can_ be controlled separately from the code processed. Doing so is less than ideal from a DevOps tight-feedback-loop perspective, and wouldn't be my preferred approach. Still, the looser coupling makes managing various security considerations much less complicated.
