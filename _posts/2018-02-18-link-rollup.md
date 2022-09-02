---
layout: post
title: Link Rollup 2018-02-15
date:   2018-02-16 18:21:00 -0500
categories: links
---

So, the first (probably)-weekly link rollup. Rather than say "oh, cool, look at this!" for everything I spot that I think is useful or interesting, I'll just drop the link in a queue and flush the queue as a single post later.

So...

## [Redirect in response to POST transaction](http://www.alanflavell.org.uk/www/post-redirect.html)

I'm designing a new API, documenting each endpoint's responses meanings, and I found myself with that exact question.

## [OpenAPI Specification](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md)

Like I said. Designing a new API. Now, I'm a big fan of [JSON-SCHEMA](http://json-schema.org/), and OpenAPI is an extension (with some backward-incompatible adjustments) of that. I'll probably still look at JSON-SCHEMA for record formats, data-at-rest; OpenAPI's ability to `{$ref}` over to a JSON-SCHEMA schema for parameter and response object structures means I can encode data structure validation end-to-end from the database through the API all the way to the client's understanding of the data structure. That's fantastic.

(Now, are there any databases that support applying JSON-SCHEMA schemas to value formats? Or am I going to have to stuff a thin OpenAPI wrapper around `etcd` and `redis` to achieve that? Hm. Has me thinking about how to handle schema changes. There's another fun problem space to noodle on.)
