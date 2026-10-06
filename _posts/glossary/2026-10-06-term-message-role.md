---
layout: post
category: glossary
title: "메시지 역할"
date: 2026-10-06 +0900
term: "메시지 역할"
term_en: "Message Role"
group: "에이전트"
oneliner: "모델에 보내는 메시지마다 붙이는 '누가 한 말인가' 표시 — system·developer·user·assistant·tool"
lesson: 19
tags: [에이전트, 메시지역할, role, 시스템프롬프트, 멀티턴, API, 프롬프트]
summary: "모델에 보내는 메시지마다 붙이는 '누가 한 말인가' 표시 — system·developer·user·assistant·tool"
related: ["프롬프트", "프롬프트 인젝션", "컨텍스트 엔지니어링", "토큰", "AI 에이전트"]
---

## 한 줄 정의

> 모델에 보내는 메시지마다 붙이는 '누가 한 말인가' 표시 — system·developer·user·assistant·tool

---

## 1. 비유로 이해하기

학교 연극 대본을 펼쳐 보자. 줄마다 앞에 이름표가 붙어 있다.

- **(무대 지시)** 주인공은 끝까지 존댓말을 쓴다. 무대 밖 이야기는 하지 않는다.
- **관객:** 이 다음엔 어떻게 돼요?
- **주인공:** 조금만 기다려 주세요.
- **(소품 담당 쪽지)** 상자 안에 든 것은 빨간 열쇠다.

괄호 친 무대 지시는 연출 선생님이 정한 규칙이라 배우가 꼭 지킨다. 관객의 말은 대답해 줄 질문이다. 주인공 줄은 배우 자신이 앞에서 한 대사다. 소품 담당 쪽지는 "지금 무대에 무엇이 있는지" 알려 주는 정보다. 같은 글자라도 **어느 이름표가 붙었느냐**에 따라 배우가 다르게 받아들인다.

그런데 이 배우는 이상한 버릇이 있다. 한 줄 대답할 때마다 기억이 싹 지워진다. 그래서 다음 줄을 말하려면 대본을 **첫 장부터 다시** 읽어야 한다. 누군가 대본 뒤에 새 줄을 덧붙여 주지 않으면, 방금 무슨 대화를 했는지도 모른다.

{% include figure.html src="/assets/images/term-message-role/resend-history.svg" alt="첫 번째 호출에는 system과 user 메시지 두 줄만 들어간다. 두 번째 호출에는 앞의 두 줄과 assistant 응답, 새 user 메시지까지 네 줄을 처음부터 다시 보낸다. 모델은 앞 호출을 기억하지 않으므로 앱이 이력을 다시 넣어 줘야 '아직 없어요'의 뜻을 안다" caption="그림 1. 모델은 매번 역할표가 붙은 대화 전체를 처음부터 다시 읽는다" %}

실제로는, 채팅 {% include term.html name="API" %}에 보내는 입력이 `{"role": ..., "content": ...}` 꼴 메시지의 **배열**이고, 모델은 이전 호출을 기억하지 않으므로 앱이 매번 대화 이력 전체를 다시 넣어 보낸다.

---

## 2. 왜 필요한가

### 역할 다섯 가지

| 역할 | 누가 쓰나 | 무엇을 담나 |
| --- | --- | --- |
| `system` | 서비스를 만든 쪽 | 말투, 지켜야 할 규칙, 하면 안 되는 일 (흔히 시스템 프롬프트라고 부른다) |
| `developer` | 앱 개발자 | 업무 절차, 쓸 수 있는 도구, 보고 형식. OpenAI 최신 모델에서 쓰는 이름 |
| `user` | 사용자 | 질문, 요청, 사용자가 붙여 넣은 자료 |
| `assistant` | 모델 자신 | 앞에서 모델이 한 답. 이력으로 다시 넣는다 |
| `tool` | 프로그램 | 도구를 실행한 결과 (파일 내용, 검색 결과 등) |

역할이 없으면 모델은 "비밀값을 출력하지 마라"가 서비스의 규칙인지, 사용자의 농담인지, 읽어 온 파일 안의 문장인지 구분할 수 없다. 글자만으로는 셋이 똑같이 생겼기 때문이다.

### 모델은 앞 대화를 기억하지 않는다

```python
messages = [
    {"role": "system",    "content": "한국어로 짧게 답한다."},
    {"role": "user",      "content": "택배 언제 와요?"},
    {"role": "assistant", "content": "주문번호를 알려 주세요."},
    {"role": "user",      "content": "아직 없어요."},
]
```

마지막 줄 "아직 없어요"만 보내면 **무엇이** 없는지 알 수 없다. 앞 세 줄이 함께 가야 "주문번호가 아직 없다"로 읽힌다. 모델은 호출과 호출 사이에 아무것도 저장하지 않는다. 기억하는 것처럼 보이는 건 앱이 이력을 쌓아 두었다가 다음 호출에 다시 붙여 주기 때문이다.

이 방식에는 값이 따른다. 열 번째 질문을 할 때는 앞의 아홉 번 주고받은 말을 모두 다시 실어 보내니, {% include term.html name="토큰" %} 요금이 쌓이고 {% include term.html name="컨텍스트 윈도우" %}의 빈자리도 줄어든다. 또 모델이 앞에서 잘못 말했다면, 그 실수도 고쳐지지 않은 채 다음 호출의 재료가 된다. 어떤 이력을 남기고 무엇을 요약하거나 뺄지 정하는 일이 {% include term.html name="컨텍스트 엔지니어링" %}이다.

### 제공자마다 이름과 자리가 다르다

역할을 나누는 생각은 같지만, 이름과 넣는 자리는 회사마다 다르다.

| 제공자 | 시스템 수준 지시 | 사용자 | 모델 응답 | 도구 결과 |
| --- | --- | --- | --- | --- |
| OpenAI Chat Completions | `developer` (o1 이후 모델에서 `system` 대신), 구형 모델은 `system` | `user` | `assistant` | `tool` (`function`은 더 이상 권장 안 함) |
| Anthropic Messages | 메시지 배열 밖 최상위 `system` 파라미터 | `user` | `assistant` | `assistant`의 `tool_use` 블록 → 다음 `user` 메시지 안 `tool_result` 블록 |
| Google Gemini | 별도 필드 `systemInstruction` | `user` | `model` | `FunctionResponse` 파트 (어느 role에 넣는지는 확인 못 함) |
| Ollama `/api/chat` | `system` | `user` | `assistant` | `tool` (`tool_name` 포함) |

몇 가지 덧붙일 점이 있다.

- **Anthropic**은 도구 결과에 전용 역할을 두지 않고 `user`·`assistant` 구조 안에 블록으로 넣는다. 또 문서 최신판에는 일부 최신 모델에서 대화 중간(`user` 턴 뒤)에 `"role": "system"` 메시지를 넣어 지시를 더할 수 있다고 적혀 있다. 첫 메시지 자리와 `tool_use`·`tool_result` 사이에는 넣을 수 없다. 다만 같은 문서 사이트의 다른 페이지에는 "입력 메시지에 system 역할은 없다"는 옛 문구도 보여, 어느 쪽이 최신인지는 확인 못 함.
- **Gemini**는 모델 응답 역할 이름이 `assistant`가 아니라 `model`이다.
- 같은 회사 안에서도 모델에 따라 달라진다. 그래서 쓰려는 API의 문서를 그때그때 확인해야 한다.

### 누구 말이 먼저인가

OpenAI의 Model Spec은 이것을 "지휘 계통(chain of command)"이라고 부르고 Root > System > Developer > User > Guideline 순으로 권한을 둔다. 여기서 System 단계는 OpenAI만 넣을 수 있다고 적혀 있다. 단계 이름은 문서 판마다 다를 수 있어 원문을 다시 보는 게 좋다. 수업에서는 이를 단순하게 **시스템 → 개발자 → 사용자** 순으로 정리했다.

중요한 건 **도구 결과·문서·웹페이지는 이 순서 어디에도 끼지 않는다**는 점이다. Model Spec도 이런 자료는 기본적으로 권한이 없다고 본다. 그 안에 명령처럼 생긴 문장이 있어도 읽을 거리일 뿐이다. 이걸 노리는 공격이 {% include term.html name="프롬프트 인젝션" %}이다.

> 출처 (2026-10-06 확인): OpenAI OpenAPI 스펙 <https://github.com/openai/openai-openapi> · OpenAI 프롬프트 가이드 <https://developers.openai.com/api/docs/guides/prompt-engineering> · OpenAI Model Spec <https://model-spec.openai.com/2025-12-18.html> · Anthropic Messages API <https://platform.claude.com/docs/en/api/messages> · Anthropic 도구 결과 처리 <https://platform.claude.com/docs/en/agents-and-tools/tool-use/handle-tool-calls> · Anthropic 대화 중간 system 메시지 <https://platform.claude.com/docs/en/build-with-claude/mid-conversation-system-messages> · Gemini API <https://ai.google.dev/api/generate-content> · Ollama API <https://github.com/ollama/ollama/blob/main/docs/api.md> · Claude Agent SDK 시스템 프롬프트 <https://code.claude.com/docs/en/agent-sdk/modifying-system-prompts>

---

## 3. 어디서 만났나

**19회차**에서 "모델이 실제로 읽는 입력"을 펼쳐 볼 때 나왔다. 채팅창에 친 한 문장 말고도 서비스 규칙, 앞 대화, 도구 결과가 역할표를 달고 함께 들어간다는 이야기였고, 이어서 역할 사이의 우선순위와 도구 결과를 데이터로 다루는 법이 붙었다.

실습에서는 Claude Agent SDK의 `system_prompt` 옵션으로 이 역할을 직접 만져 봤다. 공식 문서는 이 옵션을 "처음 주는 지시 묶음"이라고만 설명하고, API의 최상위 `system`에 그대로 대응한다는 문장은 확인하지 못했다.

- **A/B**: `system_prompt`의 말투 지시 한 줄("정중한 상담 톤" ↔ "간결한 기술 문서 톤")만 바꿨는데 인사, 사과, 이모지, 길이가 일관되게 달라졌다.
- **C/D**: 같은 후속 질문 "아직 없어요. 그러면 무엇부터 확인하죠?"를 보냈다. 앞 대화 요약을 **user 입력 안에 자료로 붙인** D는 6번 모두 "주문번호·운송장 번호가 없다"로 알아들었고, 요약이 없는 C는 6번 모두 무엇이 없는지 되물었다. 역할별 배열 대신 요약을 user 칸에 넣는 방식으로도 맥락이 전달됐다.
- **챗봇 실습**: 입력마다 `query()`를 새로 부르는 챗봇을 만들었다. 챗봇이 "정말 삭제해도 될까요?"라고 묻고 내가 "응"이라고 답했지만, 그 "응"은 앞 질문과 이어지지 않은 **새 대화의 첫 줄**로 들어갔다. 챗봇은 무엇을 승인받았는지 몰랐고 폴더는 그대로 남았다.

[19회차 — 모델이 실제로 읽는 것]({{ site.baseurl }}/2026/10/06/prompt-to-harness/)

---

## 4. 헷갈리는 개념

| 이 용어 | 비슷하지만 다른 것 | 차이 |
| --- | --- | --- |
| 메시지 역할 | 역할 프롬프팅("너는 수학 선생님이야") | 역할 프롬프팅은 모델에게 **연기할 캐릭터**를 주는 문장이다. 메시지 역할은 각 메시지가 **누구에게서 왔는지** 붙이는 표시다 |
| `system` 역할 | `user` 역할 | 둘 다 글이지만 `system`은 서비스 규칙, `user`는 사용자 요청이다. 둘이 부딪칠 때 `system` 쪽을 먼저 따르도록 OpenAI 문서는 정해 두었다 (다른 회사의 규칙은 확인 못 함) |
| `assistant` 메시지 | 모델의 기억 | `assistant` 메시지는 앱이 저장했다가 **다시 넣어 주는 기록**이다. 모델 안에 남아 있는 게 아니다 |
| `tool` 결과 | `developer`가 적은 도구 설명 | 도구 설명은 "이런 도구를 쓸 수 있다"는 지시고, 도구 결과는 그 도구가 가져온 **데이터**다 |

---

## 5. 많이들 오해하는 지점

**ㄱ. "챗봇은 내가 앞에서 한 말을 기억한다"**

모델은 호출 하나가 끝나면 아무것도 남기지 않는다. 기억처럼 보이는 건 앱이 이력을 다음 호출에 다시 붙여 준 결과다. 실습 챗봇처럼 매번 새로 부르면서 이력을 붙이지 않으면 "응" 한 글자는 맥락 없는 인사가 된다.

**ㄴ. "`system`에 적으면 모델이 반드시 지킨다"**

`system`은 우선순위가 높은 **부탁**이지 잠금장치가 아니다. 실습에서도 `system_prompt`에 "대화로 묻지 말고 바로 실행하라"고 썼는데 챗봇이 한 번은 대화로 먼저 물었다. 꼭 막아야 하는 행동은 도구 권한이나 승인 같은 코드로 막는다.

**ㄷ. "역할 이름은 어느 회사나 다 똑같다"**

생각은 같지만 이름과 자리가 다르다. OpenAI 최신 모델은 `developer`, Anthropic은 메시지 밖 `system` 파라미터, Gemini는 모델 응답을 `model`이라고 부른다. 같은 회사 안에서도 모델마다 바뀐다.

---

## 6. 관련 용어

{% include term.html name="프롬프트" %} · {% include term.html name="프롬프트 인젝션" %} · {% include term.html name="컨텍스트 엔지니어링" %} · {% include term.html name="토큰" %} · {% include term.html name="AI 에이전트" %}
