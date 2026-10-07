---
layout: post
category: glossary
title: "Hugging Face"
date: 2026-10-07 +0900
term: "Hugging Face"
term_en: "Hugging Face"
group: "개발환경"
oneliner: "공개 AI 모델과 데이터셋이 모여 있는 큰 저장소이자, 그 모델을 코드로 불러 쓰게 해 주는 Transformers 라이브러리를 만든 회사"
lesson: 20
tags: [개발환경, HuggingFace, 허깅페이스, Transformers, 모델허브, 채팅템플릿, 오픈모델]
summary: "공개 AI 모델과 데이터셋이 모여 있는 큰 저장소이자, 그 모델을 코드로 불러 쓰게 해 주는 Transformers 라이브러리를 만든 회사"
related: ["Ollama", "트랜스포머", "메시지 역할", "토큰", "양자화", "LLM", "DPO"]
---

## 한 줄 정의

> 공개 AI 모델과 데이터셋이 모여 있는 큰 저장소이자, 그 모델을 코드로 불러 쓰게 해 주는 Transformers 라이브러리를 만든 회사

---

## 1. 비유로 이해하기

동네에 아주 큰 **공공 도서관**이 있다고 해 보자.

- 서가에는 여러 출판사가 맡겨 둔 **책**이 꽂혀 있다. 책마다 앞장에 "누가 썼고, 무엇에 좋고, 빌려 갈 때 지킬 규칙"이 적힌 안내문이 붙어 있다.
- 다른 칸에는 숙제할 때 쓰는 **자료집**(문제 모음, 사진 모음)이 있다.
- 한쪽 **전시실**에서는 책을 빌리지 않고도 내용을 바로 체험해 볼 수 있다.
- 입구에는 어느 출판사 책이든 같은 방법으로 펼쳐 주는 **만능 독서대**가 있다.

Hugging Face가 이 도서관이다. 책은 **모델**, 자료집은 **데이터셋**, 전시실은 **Spaces**(브라우저에서 돌려 보는 데모), 만능 독서대는 **Transformers 라이브러리**다. 책 앞장의 안내문은 **모델 카드**에 해당한다.

그런데 이 도서관에는 함정이 하나 있다. 책에게 편지를 보내 질문하려면 **봉투 쓰는 법**을 지켜야 하는데, 그 법이 출판사마다 다르다. 어떤 책은 받는 사람을 맨 위에, 어떤 책은 맨 아래에 쓰라고 한다. 내용이 똑같은 편지라도 봉투를 엉뚱하게 쓰면, 그 책은 누가 보낸 무슨 편지인지 헷갈려 엉뚱한 답장을 쓴다.

{% include figure.html src="/assets/images/term-hugging-face/same-chat-two-wrappers.svg" alt="가운데 위에 system과 user 두 줄짜리 메시지 목록이 있다. 채팅 템플릿을 씌우면 왼쪽 ChatML 계열 예시에서는 im_start와 im_end 표시로, 오른쪽 Llama 3 계열 예시에서는 start_header_id와 eot_id 표시로 감싼 서로 다른 글자열이 된다. 모델이 학습 때 본 포장과 다르면 내용이 같아도 낯선 입력이 된다" caption="그림 1. 같은 메시지 목록도 모델마다 다른 모양의 글자열로 포장된다 (예시 형태)" %}

실제로는, 이 봉투 쓰는 법이 **채팅 템플릿**(chat template)이다. 앱이 넘기는 `system`·`user`·`assistant` {% include term.html name="메시지 역할" %} 목록을, 모델이 학습 때 보았던 특수 {% include term.html name="토큰" %}과 순서로 감싼 긴 글자열로 바꿔 주는 규칙이다. Hugging Face는 모델마다 이 규칙을 tokenizer 설정 안에 함께 실어 두고, Transformers가 그것을 읽어 알맞게 포장해 준다.

---

## 2. 왜 필요한가

### 모델을 "찾고, 받고, 확인하는" 한 곳

공개 모델을 쓰려면 먼저 어디선가 가중치 파일을 받아야 한다. Hugging Face Hub에는 회사·연구실·개인이 올린 모델이 저장소 단위로 모여 있다. 모델 주소는 `만든 곳/모델 이름` 꼴이다.

```text
Qwen/Qwen3-0.6B
meta-llama/Llama-3.1-8B-Instruct
```

저장소 첫 화면의 **모델 카드**에서 크기, 잘하는 일, 학습 방법, **라이선스**를 확인한다. 일부 모델은 라이선스에 동의해야 내려받을 수 있다.

### 코드 몇 줄로 불러 쓰기 — Transformers

Transformers는 서로 구조가 다른 모델을 **같은 손짓**으로 불러오게 해 준다. 이름만 바꾸면 다른 모델이 된다.

```python
from transformers import AutoTokenizer, AutoModelForCausalLM

name = "Qwen/Qwen3-0.6B"
tok = AutoTokenizer.from_pretrained(name)
model = AutoModelForCausalLM.from_pretrained(name)
```

이름에 쓰인 Transformers는 라이브러리 이름이지만, 그 바탕은 {% include term.html name="트랜스포머" %} 구조의 모델들이다.

### 채팅 템플릿은 직접 손으로 쓰지 않는다

채팅 모델에게 질문할 때 `"system: …\nuser: …"`처럼 역할 이름을 평범한 글자로 흉내 내면, 모델이 학습 때 본 모양과 달라진다. Transformers에서는 메시지 목록을 그대로 넘기고 `apply_chat_template`에게 포장을 맡긴다.

```python
messages = [
    {"role": "system", "content": "짧게 답한다."},
    {"role": "user",   "content": "우산 챙길까?"},
]
text = tok.apply_chat_template(
    messages,
    tokenize=False,
    add_generation_prompt=True,  # 끝에 "이제 assistant 차례" 표시를 붙인다
)
print(text)   # 이 모델 전용 특수 토큰으로 감싼 글자열이 나온다
```

같은 `messages`를 다른 모델의 tokenizer에 넘기면 다른 글자열이 나온다(그림 1). 그래서 모델을 바꿀 때 프롬프트 문장만 옮겨 붙이면 안 되고, **그 모델의 tokenizer와 템플릿으로** 다시 포장해야 한다. 모델에 따라 `system` 역할을 받지 않는 템플릿도 있으니 모델 카드에서 확인한다.

### Ollama와 무엇이 다른가

{% include term.html name="Ollama" %}도 모델을 받아 돌려 주지만, 하는 일의 층이 다르다.

| | Hugging Face | Ollama |
| --- | --- | --- |
| 비유 | 모든 출판사 책이 모인 도서관 + 만능 독서대 | 고른 책을 바로 틀어 주는 게임기 |
| 모델 출처 | 원본 저장소 그대로 (여러 파일 형식) | 실행용으로 묶어 둔 진열장 모델 (Hub의 GGUF 파일을 받아 오기도 한다) |
| 쓰는 방법 | 파이썬 코드로 불러와 직접 다룬다 | 명령 한 줄 또는 HTTP API |
| 채팅 템플릿 | `apply_chat_template`를 **내가 부른다** | 모델 안에 들어 있는 템플릿을 Ollama가 **알아서 씌운다** |
| 잘 맞는 일 | 모델 비교, 미세조정, 연구 | 내 컴퓨터에서 바로 대화·서비스 연결 |

Ollama의 `/api/chat`에 메시지 목록을 보내면, 포장은 보이지 않는 곳에서 끝난다. Hugging Face에서는 그 포장 단계가 코드에 드러난다. 편리함과 손에 쥐는 정도가 다를 뿐, 둘 다 "모델마다 정해진 봉투"를 써야 한다는 점은 같다.

---

## 3. 어디서 만났나

**20회차**에서 "대화 형식도 학습된 것"이라는 이야기를 할 때 나왔다. 모델이 지시를 따르는 힘은 문장 내용만이 아니라 학습 때 본 대화 포장과도 묶여 있고, 모델마다 역할을 감싸는 토큰이 다르다는 설명의 근거로 Hugging Face의 채팅 템플릿 문서가 소개됐다. 그래서 모델이나 템플릿을 바꾸면 이전에 통과한 사례도 다시 재 봐야 한다는 결론으로 이어졌다.

스텝 2 실습은 코랩에 설치한 Ollama로 `qwen3.5:2b`를 불러 `/api/chat`에 user 메시지 하나를 보내는 방식이었다. Hugging Face의 Transformers나 `apply_chat_template`를 직접 쓰지는 않았고, 템플릿은 Ollama가 대신 씌웠다.

예전 회차에도 이름은 몇 번 스쳤다. 14회차 리뷰에는 이미지 모델을 브라우저에서 돌려 보는 Hugging Face 데모(Spaces)가, {% include term.html name="양자화" %} 글에는 Hugging Face에 올라온 `.gguf` 파일 이름 읽는 법이 나온다.

[20회차 — 지시를 설계하고 재는 법]({{ site.baseurl }}/2026/10/07/instruction-anatomy/)

---

## 4. 헷갈리는 개념

| 이 용어 | 비슷하지만 다른 것 | 차이 |
| --- | --- | --- |
| Hugging Face (Hub) | GitHub | GitHub는 주로 **코드**를 모은다. Hub는 **모델 가중치·데이터셋**처럼 큰 파일을 버전 관리하며 모은다 |
| Transformers (라이브러리) | 트랜스포머 (모델 구조) | 라이브러리는 모델을 불러 쓰는 **도구 이름**이다. 트랜스포머는 어텐션으로 만든 **신경망 구조 이름**이다 |
| 채팅 템플릿 | 메시지 역할 | 역할은 메시지마다 붙인 **이름표**(system·user…)다. 템플릿은 그 이름표 붙은 목록을 모델 전용 **토큰 열로 바꾸는 규칙**이다 |
| Hugging Face | Ollama | Hugging Face는 모델을 **모아 두고 코드로 다루게** 해 준다. Ollama는 모델을 **내 컴퓨터에서 바로 돌려** 준다 |

---

## 5. 많이들 오해하는 지점

**ㄱ. "Hugging Face에 있는 모델은 Hugging Face가 만든 것이다"**

대부분은 다른 회사·연구실·개인이 **올려 둔** 것이다. 그래서 같은 Hub 안에서도 모델마다 품질, 학습 방법, 라이선스가 제각각이다. 내려받기 전에 모델 카드의 만든 곳과 라이선스를 본다. 누구나 받을 수 있다고 해서 아무 용도로나 써도 된다는 뜻은 아니다.

**ㄴ. "프롬프트 문장만 같으면 어느 모델에서나 똑같이 읽힌다"**

모델이 실제로 읽는 건 템플릿으로 포장된 토큰 열이다. 역할 이름을 평문으로 흉내 내거나 다른 모델의 특수 토큰을 섞으면, 글 내용은 같아도 모델에게는 처음 보는 모양이 된다. Hugging Face 문서에도 템플릿을 틀리게 쓰면 답의 질이 눈에 띄게 나빠질 수 있다는 주의가 적혀 있다.

**ㄷ. "`apply_chat_template`가 알아서 해 주니 신경 쓸 게 없다"**

포장은 맡겨도 되지만, **어느 모델의 tokenizer로 포장했는지**는 내가 맞춰야 한다. A 모델의 tokenizer로 만든 글자열을 B 모델에 넣으면 그림 1의 두 봉투를 바꿔 쓴 꼴이 된다. 또 `add_generation_prompt`를 빼먹으면 "이제 네 차례" 표시가 없어 모델이 답 대신 질문 글을 이어 쓰는 일이 생길 수 있다.

---

## 6. 관련 용어

{% include term.html name="Ollama" %} · {% include term.html name="트랜스포머" %} · {% include term.html name="메시지 역할" %} · {% include term.html name="토큰" %} · {% include term.html name="양자화" %} · {% include term.html name="LLM" %} · {% include term.html name="DPO" %}
