---
layout: post
category: build
title: "{{TITLE}}"
date: {{DATE}} +0900
lesson: {{LESSON}}
tags: [{{TAGS}}]
summary: "{{SUMMARY}}"
demo_url: ""              # 실제로 체험할 수 있는 주소 (GitHub Pages 등)
repo_url: ""              # 별도 저장소 주소
thumbnail: "/assets/images/{{SLUG}}/cover.png"
stack: []                 # 예: ["HTML", "JavaScript", "Claude Code"]
status: "완성"            # 완성 / 진행중
---

## 무엇을 만들었나

> {{SUMMARY}}

**직접 해보기** → (demo_url)

**코드 보기** → (repo_url)

---

## 1. 만들기 전 스케치

<!-- 뭘 만들려고 했는지. 손그림·화면 구상 이미지를 넣으면 가장 좋다.
     이미지는 assets/images/{{SLUG}}/ 에 넣고 아래 형태로 불러옵니다. -->

{% raw %}<!--
{% include figure.html src="/assets/images/{{SLUG}}/sketch.png" alt="화면 구상" caption="그림 1. 만들기 전 스케치" %}
-->{% endraw %}



---

## 2. 만드는 과정 — 프롬프트 기록

<!-- 여기가 이 글의 핵심이다. 시간순으로 남긴다.
     "무엇을 요청했나 → 무엇이 나왔나 → 어디가 문제였나 → 어떻게 다시 요청했나"
     프롬프트 원문은 인용 블록(>)에 그대로 붙여넣는다. -->

### 시도 1

> (넣은 프롬프트)

결과:

고친 점:

### 시도 2

> (넣은 프롬프트)

결과:

고친 점:

---

## 3. 완성 화면

{% raw %}<!--
{% include figure.html src="/assets/images/{{SLUG}}/screen.png" alt="완성 화면" caption="그림 2. 완성 화면" %}
-->{% endraw %}



---

## 4. 코드에서 배운 부분

<!-- 이해한 코드 조각 1~2개만. 전체 코드는 저장소 링크로 대신한다. -->

```javascript

```

---

## 5. 막혔던 점과 해결

| 막힌 지점 | 원인 | 해결 방법 |
| --- | --- | --- |
|  |  |  |

---

## 6. 다음에 개선할 것

- [ ] 

---

## 관련 용어

<!-- 이 작업물에서 쓴 개념을 아래 형태로 연결합니다. -->

{% raw %}<!--
{% include term.html name="프로세스" %} · {% include term.html name="동기·비동기" %}
-->{% endraw %}


