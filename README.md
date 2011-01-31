Paginary – View-based pagination for Rails
==========================================

Paginary is a simple plugin for Rails 3 that allows you to paginate in your
views only. No need to touch your models or controllers.

Paginary is currently in beta status.


Getting started
---------------

Use fabulous pagination in just three simple steps!

### 1: Add Paginary to your Gemfile

In your `Gemfile`, add:

    gem "paginary", "0.0.1.pre2"

### 2: Return Relations from your controllers

Make sure the controller actions that you wish to paginate return Active Record
`Relation` objects. This means that you should avoid using `.all`.

This works:

    # This is perfect:
    @posts = Post.where(:status => "published")
    @widgets = Widget.scoped

This does not work:

    # This does not work; do not use .all, use .scoped instead:
    @widgets = Widget.all


### 3: Add pagination helpers to your views

Something like this will do the trick:

    <%= paginate @widgets do |page| -%>
      <%= page.links %>
      <ul>
        <% page.items.each do |widget| -%>
          <li><%= link_to widget.name, widget %></li>
        <% end -%>
      <ul>
    <% end -%>


About Paginary
--------------

Paginary was created by Rolf Timmermans (r.timmermans *at* voormedia.com)

Copyright 2010-2011 Voormedia - [www.voormedia.com](http://www.voormedia.com/)


License
-------

Paginary is released under the MIT license.
