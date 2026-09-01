---
layout: page
title: 용어 사전
permalink: /glossary/
---

수업에서 만난 용어를 하나씩 정리합니다. 분야별로 묶고, 분야 안에서는 가나다순입니다.

{% assign all_terms = site.categories.glossary %}
{% if all_terms.size > 0 %}

<p class="glossary-count">현재 {{ all_terms | size }}개</p>

{% assign terms = all_terms | sort: "term" %}
{% assign groups = terms | group_by: "group" %}
{% for group in groups %}
<h2>{{ group.name | default: "기타" }}</h2>
<div class="table-scroll">
  <table class="glossary-table">
    <thead><tr><th>용어</th><th>한 줄 정의</th><th>회차</th></tr></thead>
    <tbody>
    {% for t in group.items %}
      <tr>
        <td><a href="{{ t.url | relative_url }}">{{ t.term | default: t.title }}</a>
            {% if t.term_en and t.term_en != "" %}<br><small>{{ t.term_en }}</small>{% endif %}</td>
        <td>{{ t.oneliner | default: t.summary }}</td>
        <td>{% if t.lesson and t.lesson > 0 %}{{ t.lesson }}회차{% endif %}</td>
      </tr>
    {% endfor %}
    </tbody>
  </table>
</div>
{% endfor %}

{% else %}
<p class="empty-note">아직 정리된 용어가 없습니다.</p>
{% endif %}
