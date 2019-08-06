# Jekyll-slim

[![Gem Version](http://img.shields.io/gem/v/jekyll-slim.svg?style=flat)](#)
[![Dependency
Status](http://img.shields.io/gemnasium/slim-template/jekyll-slim.svg?style=flat)](https://gemnasium.com/slim-template/jekyll-slim)
[![Code
Climate](http://img.shields.io/codeclimate/github/slim-template/jekyll-slim.svg?style=flat)](https://codeclimate.com/github/slim-template/jekyll-slim)
[![Build Status](http://img.shields.io/travis/slim-template/jekyll-slim.svg?style=flat)](https://travis-ci.org/slim-template/jekyll-slim)

A gem that adds [slim-lang](http://slim-lang.com) support to [Jekyll](http://github.com/mojombo/jekyll). Works for for pages, includes and layouts.

## Installation

Add this line to your Gemfile in the group "jekyll-plugins":

    gem 'jekyll-slim', git: 'https://github.com/aiomaster/jekyll-slim'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-slim

In your Jekyll project's `_config.yml`:

    # _config.yml
    plugins:
     - jekyll-slim

## Usage

The gem will convert all the `.slim` files in your project's directory into HTML. That includes files in sub-directories, includes and layouts. Example:

```slim
# _layouts/default.slim
html
  head
  body
    .content-wrapper {{ content }}
```
To include a partial, use `include_template` and set the local variables you like:

```slim
# index.slim
---
layout: default
---

section.content Content goes here.
== include_template 'footer.slim', foo: 'cool shit', bar: 'another cool shit'
```
You can access these local variables with the include key.
```slim
# footer.slim
h1 = include.foo
p = include.bar
```
That way your footer.slim can also be included from any other template via liquid:
```html
<div class="footer">
{%- include footer.slim foo="yeah" bar="cool" -%}
</div>
```

You can access your site data like you would do in liquid:
For example if you have
```yaml
# _data/topics.yml
- title: Cool slim
  description: slim is fantastic
- title: Fancy slim
  description: I like slim
```
and in your template
```slim
- site.data.topics.each do |topic|
  h2 = topic.title
  p = topic.description
```
How cool is that? Can you feel the power of slim and ruby?
But what about all these fancy liquid filters we need sometimes?
No problem:
```slim
p id="#{render_liquid('tittle | slugify', title: 'slug i fy me')}"
```
Just give the liquid expression as a string and every variable you would like to access in a hash.

### Options

Is possible to set options available for Slim engine through the `slim` key in `_config.yml`. Example:

```yaml
# _config.yml
slim:
  pretty: true
  format: html5
```

## Credit

Jekyll-slim was heavily inspired by [jekyll-haml](https://github.com/samvincent/jekyll-haml). It is free software, and may be redistributed under the terms specified in the LICENSE file.

I found this gem [jekyll-slim](https://github.com/slim-template/jekyll-slim), but it is archived, so I made my own fork from someone who removed the sliq experiments from it.
I added the `data_provider.rb` to have easy liquid like access to the data of my site.
Now I have some fun with slim, jekyll and liquid.
Maybe it is helpfull to someone.
