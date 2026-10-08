---
layout: post
category: glossary
title: "LangChain"
date: 2026-10-08 +0900
term: "LangChain"
term_en: "LangChain"
group: "개발환경"
oneliner: "여러 회사의 모델·검색기·임베딩·벡터 저장소를 같은 모양의 손잡이로 감싸, 바꿔 끼우며 조립하게 해 주는 파이썬·자바스크립트 프레임워크"
lesson: 21
tags: [개발환경, LangChain, langchain-ollama, ChatOllama, 프레임워크, Ollama, 메시지]
summary: "여러 회사의 모델·검색기·임베딩·벡터 저장소를 같은 모양의 손잡이로 감싸, 바꿔 끼우며 조립하게 해 주는 파이썬·자바스크립트 프레임워크"
related: ["SDK", "Ollama", "API", "메시지 역할", "RAG", "임베딩", "MCP", "하네스", "통제 실험"]
---

## 한 줄 정의

> 여러 회사의 모델·검색기·임베딩·벡터 저장소를 같은 모양의 손잡이로 감싸, 바꿔 끼우며 조립하게 해 주는 파이썬·자바스크립트 프레임워크

---

## 1. 비유로 이해하기

거실에 텔레비전, 에어컨, 선풍기가 있다. 리모컨이 셋이고 생김새가 다 다르다. 전원 버튼이 어떤 건 왼쪽 위, 어떤 건 가운데, 어떤 건 빨간색이다. 기계를 바꿀 때마다 새 리모컨 쓰는 법을 다시 익혀야 한다.

그래서 **만능 리모컨**을 산다. 처음에 "이건 ○○ 회사 텔레비전"이라고 한 번 맞춰 두면, 그다음부터는 어느 기계든 같은 자리의 전원·채널·음량 버튼으로 다룬다. 텔레비전을 다른 회사 것으로 바꿔도 손에 익은 버튼은 그대로다.

다만 만능 리모컨이 텔레비전 화면을 만들어 주지는 않는다. 텔레비전이 꺼져 있거나 고장 나 있으면 버튼을 아무리 눌러도 소용없다. 그리고 어떤 회사 텔레비전에만 있는 특별한 기능은 만능 리모컨에서 이름이 다른 버튼으로 들어가 있거나, 아예 없을 수도 있다.

{% include figure.html src="/assets/images/term-langchain/two-roads.svg" alt="같은 질문이 모델까지 가는 두 길을 위아래로 그렸다. 왼쪽 LangChain 길은 내 코드의 llm.invoke, LangChain의 ChatOllama, ollama 파이썬 패키지를 차례로 지나고, 오른쪽 직접 부르는 길은 내 코드가 JSON 본문을 손으로 조립해 바로 보낸다. 두 길은 Ollama 서버에서 만나고, 답은 그 아래 모델 qwen3.5:2b가 만든다" caption="그림 1. LangChain은 내 코드와 모델 서버 사이에 끼워 넣는 손잡이 층이다" %}

실제로는, LangChain은 모델을 직접 돌리는 프로그램이 아니라 **모델을 부르는 쪽 코드에 쓰는 프레임워크**다. 회사마다 다른 {% include term.html name="SDK" %}·{% include term.html name="API" %} 위에 같은 모양의 클래스와 함수(예: 채팅 모델이면 `invoke`)를 얹어 두어서, 모델·검색기(retriever)·{% include term.html name="임베딩" %}·벡터 저장소를 레고 블록처럼 갈아 끼우며 조립할 수 있게 해 준다. 답을 만드는 일은 여전히 그 뒤의 모델 서버가 한다.

---

## 2. 왜 필요한가

### 같은 일을 세 가지 높이에서 부를 수 있다

21회차 실습에서 내 컴퓨터(WSL2 Ubuntu, CPU)의 {% include term.html name="Ollama" %} 0.40.1 서버에 `qwen3.5:2b`를 띄워 놓고 불렀다. 같은 호출을 세 가지 높이에서 쓸 수 있다.

**① REST로 직접** — 본문을 내가 조립한다. 생성 옵션은 `options` 칸 안에, 추론 끄기는 `think` 칸에 넣는다.

```python
import requests

body = {
    "model": "qwen3.5:2b",
    "messages": [{"role": "user", "content": "우산 챙길까?"}],
    "stream": False,
    "think": False,                     # 추론 끄기
    "options": {"temperature": 0},      # 생성 옵션은 이 칸 안에
}
res = requests.post("http://localhost:11434/api/chat", json=body)
print(res.json()["message"]["content"])
```

**② Ollama 전용 SDK(`ollama` 패키지)로** — 주소와 본문 모양은 패키지가 안다.

```python
import ollama

res = ollama.chat(model="qwen3.5:2b",
                  messages=[{"role": "user", "content": "우산 챙길까?"}],
                  think=False, options={"temperature": 0})
print(res["message"]["content"])
```

**③ LangChain(`langchain-ollama`의 `ChatOllama`)으로** — 실습 코드가 쓴 방식이다.

```python
from langchain_ollama import ChatOllama

llm = ChatOllama(model="qwen3.5:2b", temperature=0, reasoning=False)
resp = llm.invoke("우산 챙길까?")
print(resp.content)
```

③은 ②를 안에서 부른다. 실습 기록에 `langchain-ollama` 1.1.0과 함께 `ollama` 0.6.3이 깔린 것으로 적혀 있는데, 이 패키지가 그 아래층이다(그림 1). 위로 올라갈수록 내가 쓸 줄은 줄고, 가운데에 끼는 층은 늘어난다.

### 같은 뜻, 다른 이름

위 세 코드에서 "추론 끄기"의 이름이 다르다. REST와 `ollama` 패키지는 `think`, `ChatOllama`는 `reasoning`이다. 강의도 이 점을 따로 짚었고, 실습 코드의 주석에도 "REST의 `think:false`에 해당"이라고 적혀 있었다. 온도도 REST에서는 `options` 안에 넣지만 `ChatOllama`에서는 바로 인자로 넘긴다.

층이 하나 끼면 이렇게 **이름과 자리가 바뀐다.** 그래서 실험 기록에는 "추론 끔"만 적지 말고, 어떤 패키지의 어떤 이름으로 껐는지와 그 버전까지 같이 남긴다. 이 이름은 버전에 따라 달라질 수 있으니, 내가 쓰는 버전의 문서에서 확인한다.

### 손잡이 모양이 같으면 바꿔 끼우기 쉽다

LangChain을 쓰는 가장 큰 이유는 **바꿔 끼우기**다. 회사별 연결 꾸러미가 `langchain-○○` 이름으로 따로 나오고, 그 안의 채팅 모델 클래스는 모두 같은 `invoke`로 부른다. 그래서 `ChatOllama`를 다른 회사용 Chat 클래스로 바꿔도, 질문을 넣고 `resp.content`로 답을 꺼내는 줄은 대개 그대로 둘 수 있다.

{% include term.html name="통제 실험" %}을 할 때도 이 점이 쓸모 있었다. 21회차 실습은 질문·모델·온도·호출 경로를 고정하고 **질문 앞에 붙이는 맥락만** 네 가지로 바꿨다. 네 조건이 모두 같은 `llm` 객체의 같은 `invoke`를 지나가니, "부르는 방법이 조건마다 달랐다"는 의심을 하나 덜 수 있다.

### 메시지 역할을 클래스로 쓴다

모델에 보내는 대화는 역할이 붙은 메시지 목록이다({% include term.html name="메시지 역할" %}). LangChain은 이 역할을 클래스로 만들어 두었다.

| 역할 | LangChain 클래스 |
| --- | --- |
| system | `SystemMessage` |
| user | `HumanMessage` |
| assistant | `AIMessage` |
| tool | `ToolMessage` |

```python
from langchain_core.messages import SystemMessage, HumanMessage

msgs = [SystemMessage("한 문장으로 답한다."),
        HumanMessage("우산 챙길까?")]
resp = llm.invoke(msgs)      # 답은 AIMessage로 돌아온다
```

실습 코드는 이 클래스를 쓰지 않고 `llm.invoke(user)`에 문자열 하나만 넘겼다. 문자열을 넘기면 LangChain이 그것을 사람(user) 메시지 하나로 감싸 보낸다. 그래서 실습의 맥락과 질문은 모두 **user 메시지 한 통** 안에 들어갔다.

### 모델 말고도 감싸는 것이 많다

LangChain이 감싸는 대상은 채팅 모델만이 아니다. 문장을 숫자로 바꾸는 임베딩 모델, 그 숫자를 모아 두는 벡터 저장소, 질문과 비슷한 조각을 찾아오는 검색기도 같은 방식으로 묶는다. 이 부품들을 이어 붙이면 {% include term.html name="RAG" %}처럼 "찾아서 넣고 답하기" 흐름을 짤 수 있다. 21회차 강의는 이 부품들로 짠 검색을 에이전트가 부를 수 있는 {% include term.html name="MCP" %} 도구로 내놓는 쓰임새도 짚었다.

---

## 3. 어디서 만났나

이름은 그전에도 두 번 스쳤다. {% include term.html name="하네스" %} 글의 비교표에 "하네스를 만들 때 쓰는 재료(프레임워크)"의 예로 적어 두었고, **19회차**에 메시지 역할 이름을 회사·도구별로 조사할 때 표의 한 줄로 들어갔다. 그때는 `SystemMessage`·`HumanMessage` 같은 이름만 정리했고, 코드로 써 보지는 않았다.

[19회차 — 모델이 실제로 읽는 것]({{ site.baseurl }}/2026/10/06/prompt-to-harness/)

실제로 코드에서 쓴 건 **21회차**다. 같은 반품 질문에 맥락만 네 가지로 바꿔 넣는 실습 코드가 `langchain-ollama`의 `ChatOllama`로 모델을 불렀다. 나는 `uv run --with langchain-ollama python day29_context_test.py`로 실행했다. 이 명령은 프로젝트에 패키지를 따로 설치하지 않고, 실행할 때만 쓰는 환경에 받아 와서 돌린다. 설정은 `temperature=0`, `reasoning=False`였고, 최대 토큰과 seed는 지정하지 않았다. 실습 코드가 토큰 수와 걸린 시간을 저장하지 않아서 그 둘은 기록하지 못했다. 강의에서는 RAG를 직접 짜지 않아도 되게 해 주는 오픈소스 도구 중 하나로도 소개됐다.

[21회차 — 같은 자료, 다른 맥락]({{ site.baseurl }}/2026/10/08/context-select-and-state/)

---

## 4. 헷갈리는 개념

| 이 용어 | 비슷하지만 다른 것 | 차이 |
| --- | --- | --- |
| LangChain | SDK (`ollama` 패키지) | SDK는 **한 서비스 전용** 꾸러미다. LangChain은 여러 회사의 SDK 위에 **같은 모양의 손잡이**를 얹은 틀이다. `ChatOllama`도 안에서는 `ollama` 패키지를 부른다 |
| LangChain | Ollama | Ollama는 모델을 **실제로 돌리는 서버**다. LangChain은 그 서버를 **부르는 쪽 코드**에 쓴다. Ollama 서버가 꺼져 있으면 `ChatOllama`도 답을 받지 못한다 |
| LangChain | 하네스 | LangChain은 하네스를 **조립할 때 쓰는 재료**다. 하네스는 모델을 감싸 실제로 일하게 만든 **완성된 바깥 코드**다 |
| `langchain-ollama` | `langchain_ollama` | 같은 꾸러미다. 설치할 때 이름은 하이픈(`-`), 코드에서 `import`할 때 이름은 밑줄(`_`)이다 |

---

## 5. 많이들 오해하는 지점

**ㄱ. "LangChain이 모델을 돌린다"**

LangChain은 요청을 만들어 보내고 답을 받아 오는 쪽이다. 21회차 실습에서도 답을 만든 건 WSL 안에서 따로 켜 둔 Ollama 서버와 `qwen3.5:2b`였다. 그래서 속도나 답의 질이 아쉬우면 LangChain이 아니라 모델과 서버 쪽부터 본다.

**ㄴ. "손잡이가 같으니 회사를 바꿔도 옵션이 똑같이 먹힌다"**

`invoke`처럼 공통인 부분은 같지만, 회사마다 있는 옵션은 이름과 자리가 다르다. 같은 Ollama 안에서도 추론 끄기가 REST에서는 `think`, `ChatOllama`에서는 `reasoning`이었다. 바꿔 끼운 뒤에는 그 클래스의 문서를 다시 보고, 내가 넣은 옵션이 실제로 전달되는지 확인한다.

**ㄷ. "Ollama를 파이썬에서 쓰려면 LangChain이 있어야 한다"**

아니다. 2장의 ①·②처럼 REST나 `ollama` 패키지만으로도 충분히 부를 수 있다. 모델 하나를 짧게 부를 때는 층이 적은 쪽이 오히려 무슨 일이 일어나는지 보기 쉽다. 여러 회사 모델을 바꿔 가며 쓰거나, 검색·임베딩 같은 부품을 이어 붙일 때 LangChain의 장점이 커진다.

---

## 6. 관련 용어

{% include term.html name="SDK" %} · {% include term.html name="Ollama" %} · {% include term.html name="API" %} · {% include term.html name="메시지 역할" %} · {% include term.html name="RAG" %} · {% include term.html name="임베딩" %} · {% include term.html name="MCP" %} · {% include term.html name="하네스" %} · {% include term.html name="통제 실험" %}
