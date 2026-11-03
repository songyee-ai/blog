---
layout: page
title: 용어 사전
permalink: /glossary/
---

수업에서 만난 용어를 하나씩 정리합니다. 분야별로 묶고, 분야 안에서는 가나다순입니다.

{% assign all_terms = site.categories.glossary %}
{% unless all_terms %}{% assign all_terms = "" | split: "," %}{% endunless %}
{% if all_terms.size > 0 %}

<p class="glossary-count">현재 {{ all_terms | size }}개</p>

<div class="glossary-search">
  <input type="search" id="glossary-q" placeholder="용어·영문·정의로 검색 (예: RAG, 토큰)" aria-label="용어 검색" autocomplete="off">
  <p class="glossary-search-status" id="glossary-status" aria-live="polite"></p>
</div>

{% assign terms = all_terms | sort: "term" %}
{% assign groups = terms | group_by: "group" %}
{% for group in groups %}
<section class="glossary-group">
<h2>{{ group.name | default: "기타" }}</h2>
<div class="table-scroll">
  <table class="glossary-table">
    <colgroup><col class="col-term"><col class="col-def"><col class="col-lesson"></colgroup>
    <thead><tr><th>용어</th><th>한 줄 정의</th><th>회차</th></tr></thead>
    <tbody>
    {% for t in group.items %}
      {% capture haystack %}{{ t.term | default: t.title }} {{ t.term_en }} {{ t.oneliner | default: t.summary }}{% endcapture %}
      <tr data-search="{{ haystack | strip_newlines | downcase | escape }}">
        <td><a href="{{ t.url | relative_url }}">{{ t.term | default: t.title }}</a>
            {% if t.term_en and t.term_en != "" %}<br><small>{{ t.term_en }}</small>{% endif %}</td>
        <td>{{ t.oneliner | default: t.summary }}</td>
        <td>{% if t.lesson and t.lesson > 0 %}{{ t.lesson }}회차{% endif %}</td>
      </tr>
    {% endfor %}
    </tbody>
  </table>
</div>
</section>
{% endfor %}

<p class="empty-note" id="glossary-empty" hidden>찾는 용어가 없습니다.</p>
<script src="{{ '/assets/js/glossary-search.js' | relative_url }}" defer></script>

{% else %}
<p class="empty-note">아직 정리된 용어가 없습니다.</p>
{% endif %}
