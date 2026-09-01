---
layout: page
title: 학습 기록
---

AI Agent 수업에서 배운 것을 세 가지로 나눠 기록합니다 — **강의 리뷰**(회차별 수업 기록),
**용어 사전**(용어 하나씩 정리), **작업물**(수업 중 만든 것).

<section class="home-section">
<h2>처음 오셨나요?</h2>
<ul class="start-here">
  {% assign rv = site.categories.review %}
  {% unless rv %}{% assign rv = "" | split: "," %}{% endunless %}
  {% assign first = rv | sort: "lesson" | first %}
  {% if first %}
  <li><a href="{{ first.url | relative_url }}">1회차부터 순서대로 읽기</a> — 수업을 처음부터 따라갑니다</li>
  {% endif %}
  <li><a href="{{ '/glossary/' | relative_url }}">용어만 찾아보기</a> — 모르는 단어를 사전에서 바로 확인합니다</li>
  <li><a href="{{ '/build/' | relative_url }}">만든 것 구경하기</a> — 직접 체험해 볼 수 있습니다</li>
</ul>
</section>

<section class="home-section">
<h2>최근 강의 리뷰</h2>
{% assign reviews = site.categories.review %}
{% unless reviews %}{% assign reviews = "" | split: "," %}{% endunless %}
{% assign reviews = reviews | sort: "lesson" | reverse %}
{% if reviews.size > 0 %}
<ul class="entry-list">
{% for post in reviews limit: 5 %}
  <li class="entry">
    <div class="entry-head">
      {% if post.lesson and post.lesson > 0 %}<span class="lesson-no">{{ post.lesson }}회차</span>{% endif %}
      <a class="entry-title" href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </div>
    {% if post.summary %}<p class="entry-summary">{{ post.summary }}</p>{% endif %}
  </li>
{% endfor %}
</ul>
<p class="section-more"><a href="{{ '/review/' | relative_url }}">강의 리뷰 전체 보기 →</a></p>
{% else %}
<p class="empty-note">아직 등록된 강의 리뷰가 없습니다.</p>
{% endif %}
</section>

<section class="home-section">
<h2>최근 정리한 용어</h2>
{% assign terms = site.categories.glossary %}
{% unless terms %}{% assign terms = "" | split: "," %}{% endunless %}
{% assign terms = terms | sort: "date" | reverse %}
{% if terms.size > 0 %}
<p class="term-inline">
{% for post in terms limit: 6 %}<a class="term-link" href="{{ post.url | relative_url }}">{{ post.term | default: post.title }}</a>{% unless forloop.last %} · {% endunless %}{% endfor %}
</p>
<p class="section-more"><a href="{{ '/glossary/' | relative_url }}">용어 사전 전체 보기 →</a></p>
{% else %}
<p class="empty-note">아직 정리된 용어가 없습니다. <a href="{{ '/glossary/' | relative_url }}">용어 사전</a></p>
{% endif %}
</section>

<section class="home-section">
<h2>최근 작업물</h2>
{% assign builds = site.categories.build %}
{% unless builds %}{% assign builds = "" | split: "," %}{% endunless %}
{% assign builds = builds | sort: "date" | reverse %}
{% if builds.size > 0 %}
<ul class="entry-list">
{% for post in builds limit: 2 %}
  <li class="entry">
    <div class="entry-head">
      <a class="entry-title" href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </div>
    {% if post.summary %}<p class="entry-summary">{{ post.summary }}</p>{% endif %}
    {% if post.demo_url and post.demo_url != "" %}
    <p><a class="btn-demo" href="{{ post.demo_url }}" target="_blank" rel="noopener">체험하기</a></p>
    {% endif %}
  </li>
{% endfor %}
</ul>
<p class="section-more"><a href="{{ '/build/' | relative_url }}">작업물 전체 보기 →</a></p>
{% else %}
<p class="empty-note">아직 등록된 작업물이 없습니다. <a href="{{ '/build/' | relative_url }}">작업물</a></p>
{% endif %}
</section>
