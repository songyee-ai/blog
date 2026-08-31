---
layout: page
title: 전체 목록
permalink: /archive/
---

{% assign posts = site.posts | sort: "lesson" %}
<ul class="post-list">
{% for post in posts %}
  <li>
    {% if post.lesson and post.lesson > 0 %}<strong>{{ post.lesson }}회차</strong> · {% endif %}
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    <small>{{ post.date | date: "%Y-%m-%d" }}</small>
    {% if post.summary %}<br><em>{{ post.summary }}</em>{% endif %}
    {% if post.tags.size > 0 %}
      <br>{% for tag in post.tags %}<code>{{ tag }}</code> {% endfor %}
    {% endif %}
  </li>
{% endfor %}
</ul>
