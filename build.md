---
layout: page
title: 작업물
permalink: /build/
---

수업 중에 만든 것들입니다. 직접 해보고, 만드는 과정도 함께 읽을 수 있습니다.

{% assign builds = site.categories.build | sort: "date" | reverse %}
{% if builds.size > 0 %}
<div class="build-grid">
{% for post in builds %}
  <article class="build-card">
    {% if post.thumbnail and post.thumbnail != "" %}
    <a href="{{ post.url | relative_url }}" class="build-thumb">
      <img src="{{ post.thumbnail | relative_url }}" alt="{{ post.title }} 미리보기" loading="lazy">
    </a>
    {% endif %}
    <div class="build-body">
      <h3 class="build-title">
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        {% if post.status and post.status != "" %}<span class="build-status">{{ post.status }}</span>{% endif %}
      </h3>
      {% if post.summary %}<p class="build-summary">{{ post.summary }}</p>{% endif %}
      {% if post.stack.size > 0 %}
      <p class="build-stack">{% for s in post.stack %}<span class="stack-badge">{{ s }}</span>{% endfor %}</p>
      {% endif %}
      {% assign has_demo = false %}{% if post.demo_url and post.demo_url != "" %}{% assign has_demo = true %}{% endif %}
      {% assign has_repo = false %}{% if post.repo_url and post.repo_url != "" %}{% assign has_repo = true %}{% endif %}
      {% if has_demo or has_repo %}
      <p class="build-actions">
        {% if has_demo %}
        <a class="btn-demo" href="{{ post.demo_url }}" target="_blank" rel="noopener">체험하기</a>
        {% endif %}
        {% if has_repo %}
        <a class="btn-repo" href="{{ post.repo_url }}" target="_blank" rel="noopener">코드 보기</a>
        {% endif %}
      </p>
      {% endif %}
      <p class="build-more"><a href="{{ post.url | relative_url }}">제작 과정 읽기 →</a></p>
    </div>
  </article>
{% endfor %}
</div>
{% else %}
<p class="empty-note">아직 등록된 작업물이 없습니다.</p>
{% endif %}
