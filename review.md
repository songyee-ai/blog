---
layout: page
title: 강의 리뷰
permalink: /review/
---

수업 회차 순서대로 정렬되어 있습니다. 위에서부터 읽으시면 됩니다.

{% assign reviews = site.categories.review | sort: "lesson" %}
{% if reviews.size > 0 %}
<ul class="entry-list">
{% for post in reviews %}
  <li class="entry">
    <div class="entry-head">
      {% if post.lesson and post.lesson > 0 %}<span class="lesson-no">{{ post.lesson }}회차</span>{% endif %}
      <a class="entry-title" href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <time class="entry-date" datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y-%m-%d" }}</time>
    </div>
    {% if post.summary %}<p class="entry-summary">{{ post.summary }}</p>{% endif %}
    {% if post.tags.size > 0 %}
    <p class="entry-tags">{% for tag in post.tags %}<span class="tag">{{ tag }}</span>{% endfor %}</p>
    {% endif %}
  </li>
{% endfor %}
</ul>
{% else %}
<p class="empty-note">아직 등록된 강의 리뷰가 없습니다.</p>
{% endif %}
