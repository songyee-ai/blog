---
layout: post
category: glossary
title: "Qdrant"
date: 2026-10-12 +0900
term: "Qdrant"
term_en: "Qdrant"
group: "개발환경"
oneliner: "글이나 그림을 숫자 좌표(벡터)로 바꿔 쌓아 두었다가, 질문과 뜻이 가까운 것부터 골라 주는 오픈소스 벡터 검색 엔진"
lesson: 22
tags: [개발환경, Qdrant, 벡터데이터베이스, mcp-server-qdrant, 컬렉션, fastembed, MCP]
summary: "글이나 그림을 숫자 좌표(벡터)로 바꿔 쌓아 두었다가, 질문과 뜻이 가까운 것부터 골라 주는 오픈소스 벡터 검색 엔진"
related: ["벡터", "임베딩", "RAG", "MCP", "컨텍스트 엔지니어링", "도구 정의서"]
---

## 한 줄 정의

> 글이나 그림을 숫자 좌표(벡터)로 바꿔 쌓아 두었다가, 질문과 뜻이 가까운 것부터 골라 주는 오픈소스 벡터 검색 엔진

---

## 1. 비유로 이해하기

미술 시간에 쓰는 커다란 **크레파스 정리함**이 있다. 이 정리함은 이름표 순서(가나다)로 꽂지 않는다. 빨강 옆에 주홍, 주홍 옆에 주황, 그 옆에 노랑 하는 식으로 **색이 비슷한 것끼리 붙여** 꽂는다. 그래서 친구가 "여름 바다 같은 색 몇 개 줘"라고 하면, 이름에 '바다'가 들어간 크레파스를 찾을 필요가 없다. 파랑 근처로 손을 뻗어 가장 가까운 세 자루를 집으면 된다.

정리함에는 서랍이 여러 칸 있다. 한 칸은 미술 시간용, 한 칸은 집에 가져갈 것. 그리고 정리함 앞에는 심부름하는 친구가 한 명 앉아 있다. 이 친구가 알아듣는 말은 딱 두 가지다. **"이거 넣어 줘"**와 **"이거랑 비슷한 거 찾아 줘."** 다른 친구들은 정리함을 직접 열지 않고, 이 심부름꾼에게 두 가지 말 중 하나로 부탁한다.

{% include figure.html src="/assets/images/term-qdrant/three-layers.svg" alt="세 층을 위에서 아래로 그렸다. 맨 위 에이전트 층(Claude Code 2.1.296, opencode 1.19.0)은 가운데 연결 서버 mcp-server-qdrant 0.8.1에게서 도구 정의 두 개를 받고 호출 요청을 보낸다. 연결 서버는 qdrant-store(문장을 벡터로 바꿔 저장)와 qdrant-find(질문과 가까운 문장 찾기)를 내놓고, 임베딩 모델로 숫자 목록을 만들어 맨 아래 Qdrant 저장소에 넣거나 가까운 순서로 받아 온다. 저장소는 :memory: 설정이라 프로세스가 끝나면 사라지고, 컬렉션 이름은 Claude가 policies, opencode가 memories로 채웠다. 맨 아래 빨간 글씨로, 설정 이름이 서버가 읽는 이름과 다르면 오류 없이 기본값으로 돈다고 적었다" caption="그림 1. 에이전트는 Qdrant를 직접 보지 않고, 연결 서버가 내놓은 도구 두 개로만 다룬다" %}

실제로는, Qdrant는 문장·이미지 같은 자료를 {% include term.html name="임베딩" %} 모델로 숫자 목록({% include term.html name="벡터" %})으로 바꾼 것을 저장해 두고, 질문도 같은 방식으로 바꾼 뒤 **가장 가까운 벡터부터 순서대로** 돌려주는 검색 엔진이다. 크레파스의 '색'이 벡터, 서랍 한 칸이 **컬렉션(collection)**이다. 심부름꾼은 22회차 실습에서 쓴 **mcp-server-qdrant**라는 연결 프로그램이고, 두 가지 말은 이 프로그램이 {% include term.html name="MCP" %} 도구로 내놓는 `qdrant-store`와 `qdrant-find`다.

---

## 2. 왜 필요한가

### 글자가 안 겹쳐도 찾으려고

보통의 찾기는 **같은 글자**를 찾는다. "환불 기한"으로 찾으면 "환불"이나 "기한"이 들어간 문장만 나온다. "돈 돌려받으려면 며칠 안에 말해야 해?"처럼 다르게 물으면 놓친다.

벡터 검색은 **뜻이 가까운지**를 잰다. 문장마다 숫자 수백 개짜리 좌표를 만들어 두고, 질문의 좌표와 거리가 가까운 것을 고른다. 이 계산을 빠르게 하려고 벡터만 전문으로 다루는 저장소가 따로 있고, Qdrant가 그중 하나다. 러스트(Rust)로 만든 오픈소스이고, 내 컴퓨터에 띄워 쓰거나 회사가 운영하는 클라우드로 쓸 수 있다. 21회차 강의는 Qdrant가 뜻 검색과 키워드 검색을 함께 지원한다고 소개했다.

### 저장되는 모양 — 점과 컬렉션

Qdrant에 들어가는 한 건을 **점(point)**이라고 부른다. 점 하나는 대략 이렇게 생겼다.

```text
id      : 1
vector  : [0.021, -0.113, 0.087, … 숫자 수백 개]
payload : 원문 "환불은 구매 후 7일 이내에 가능하다." + 덧붙인 정보
```

`vector`가 좌표, `payload`가 원문과 덧붙인 정보다. 검색은 `vector`로 하고, 사람에게 보여 주는 건 `payload` 쪽이다. 점들을 모아 두는 칸이 컬렉션이다. 한 컬렉션 안의 벡터는 모두 같은 길이여야 하고, 거리를 재는 방식(코사인 등)도 컬렉션을 만들 때 정한다.

### 에이전트가 쓰게 하려면 — 연결 서버

Qdrant 자체는 저장과 검색만 한다. 에이전트가 이걸 쓰려면 누군가가 Qdrant를 **도구 모양으로** 감싸 줘야 한다. mcp-server-qdrant가 그 일을 한다. 이 서버를 에이전트에 등록하면, 모델은 도구 목록에서 두 개를 보게 된다.

| 도구 | 하는 일 | 받는 인자 (실습에서 꺼낸 정의 기준) |
| --- | --- | --- |
| `qdrant-store` | 문장을 받아 벡터로 바꾼 뒤 저장 | `information`(필수), `collection_name`(필수), `metadata`(선택) |
| `qdrant-find` | 질문과 가까운 문장을 찾아 돌려줌 | `query`(필수), `collection_name`(필수) |

실습에서는 따로 설치하지 않고 `uvx mcp-server-qdrant` 한 줄을 에이전트 설정에 적었다. `uvx`는 파이썬 도구 uv에 딸린 명령으로, 패키지를 그 자리에서 받아 쓰고 버리는 환경에서 돌려 준다. 저장 위치는 `QDRANT_URL`을 `:memory:`로 두었다. 이렇게 하면 따로 Qdrant 서버를 띄우지 않고, 연결 서버 프로그램의 메모리 안에 작은 저장소를 만든다. 대신 그 프로그램이 끝나면 저장한 것도 함께 없어진다. 맛보기 실습에는 편하지만, 오래 남길 자료라면 저장 위치를 따로 정해야 한다.

### 설정 이름 하나가 도구 모양을 바꾼다

실습에서 가장 크게 배운 건 여기다. 노드에 적힌 설정을 그대로 옮겨 `.mcp.json`(Claude Code용)과 `opencode.json`(opencode용)을 만들었다.

```text
"env": {
  "QDRANT_URL": ":memory:",
  "QDRANT_COLLECTION": "policies",
  "EMBEDDER_PROVIDER": "fastembed",
  "FASTEMBED_MODEL": "BAAI/bge-small-en-v1.5"
}
```

그런데 설치된 mcp-server-qdrant **0.8.1**은 이 중 세 이름을 읽지 않았다. 서버가 실제로 읽는 이름은 달랐다.

| 설정에 적은 이름 | 0.8.1이 읽는 이름 | 그래서 생긴 일 |
| --- | --- | --- |
| `QDRANT_COLLECTION` | `COLLECTION_NAME` | 컬렉션이 고정되지 않아, 도구 정의에 `collection_name` 인자가 남았다 |
| `EMBEDDER_PROVIDER` | `EMBEDDING_PROVIDER` | 기본값도 fastembed라 결과는 같았다 |
| `FASTEMBED_MODEL` | `EMBEDDING_MODEL` | 적어 둔 bge-small이 아니라 기본 모델 `all-MiniLM-L6-v2`(87MB)가 쓰였다 |

어떤 이름도 오류를 내지 않았다. 서버는 모르는 이름을 **조용히 건너뛰고** 기본값으로 돌았고, 검색 결과도 그럴듯하게 나왔다. 과제를 검토하다가 뒤늦게 확인한 것이라, 처음 남긴 실행 기록의 설정 줄에는 bge-small이 그대로 적혀 있다.

이름을 맞춰 주면 **도구 정의 자체가 바뀐다.** 서버가 내놓는 정의를 꺼내 비교해 보니(`qdrant-tools.json` ↔ `qdrant-tools-fixed.json`), `COLLECTION_NAME=policies`를 주자 `collection_name` 인자가 두 도구에서 아예 사라졌고, `QDRANT_READ_ONLY=true`를 더하자 `qdrant-store` 도구가 목록에서 빠지고 `qdrant-find` 하나만 남았다. 모델이 짐작해서 채울 칸도, 쓰지 말아야 할 도구도 처음부터 안 보이게 되는 것이다. {% include term.html name="도구 정의서" %}에 빈 줄이 있으면 모델이 그 줄을 제 짐작으로 채운다는 이야기를, 남이 만든 도구에서 그대로 본 셈이다.

### 남이 쓴 설명이 내 입력에 들어온다

`qdrant-find`의 설명 문장은 이렇게 끝난다.

```text
Look up memories in Qdrant. Use this tool when you need to:
 - Find memories by their content
 - Access memories for further analysis
 - Get some personal information about the user
```

마지막 줄은 "사용자의 개인 정보를 얻을 때도 쓰라"는 뜻이다. 내가 쓴 문장이 아닌데, 이 서버를 붙이는 순간 모델이 읽는 입력에 들어간다. 설명 전체가 "기억(memories)"을 찾는 도구로 쓰여 있어서, 정책 문서를 찾으려는 내 쓰임과도 결이 다르다. 남이 만든 MCP 서버를 붙이기 전에 **도구 설명부터 꺼내 읽어 보는** 이유다. 도구 설명도 결국 입력의 일부라서, 무엇이 들어오는지는 {% include term.html name="컨텍스트 엔지니어링" %}의 문제이기도 하다.

---

## 3. 어디서 만났나

이름 자체는 10회차 {% include term.html name="임베딩" %}·{% include term.html name="벡터" %} 용어 글에 벡터 데이터베이스의 예로 먼저 나온다. 수업 자료에 나온 건 **21회차**였다. {% include term.html name="RAG" %}를 직접 짜지 않아도 되게 해 주는 오픈소스를 훑을 때, 저장소 쪽의 예로 공식 MCP 서버와 함께 소개됐다.

[21회차 — 같은 자료, 다른 맥락]({{ site.baseurl }}/2026/10/08/context-select-and-state/)

**22회차**에서 직접 붙여 봤다. 직접 짠 함수가 아니라 이미 공개된 MCP 서버를 가져다 붙이는 실습이었다. WSL에 Claude Code 2.1.296과 opencode 1.19.0을 설치하고, 같은 mcp-server-qdrant를 두 에이전트에 각각 등록한 뒤 같은 요청을 넣었다. 세 문장(환불·배송·회원 등급)을 저장하고 "환불 기한이 어떻게 돼?"와 비슷한 문장을 찾아 달라는 요청이었다.

두 에이전트 모두 `qdrant-store`를 세 번, `qdrant-find`를 한 번 불렀고, 1위는 둘 다 환불 문장이었다. 다른 점은 `collection_name`이었다. Claude는 시키지 않았는데도 `ls`·`cat`으로 `.mcp.json`을 읽어 `policies`를 찾아 썼고, opencode의 모델은 도구 설명에 나오는 단어인 `memories`를 넣었다. 한 세션 안에서는 저장과 검색이 같은 이름을 써서 문제가 드러나지 않았다. 도구를 넣는 방식도 달랐다. Claude Code는 MCP 도구 설명을 처음부터 다 싣지 않고 `ToolSearch`로 필요할 때 불러왔고, opencode는 첫 단계 입력이 10,355토큰이었다.

[22회차 — 도구를 준다는 것]({{ site.baseurl }}/2026/10/12/tool-contract-and-harness/)

---

## 4. 헷갈리는 개념

| 이 용어 | 비슷하지만 다른 것 | 차이 |
| --- | --- | --- |
| Qdrant | mcp-server-qdrant | Qdrant는 벡터를 **저장하고 찾는 엔진**이다. mcp-server-qdrant는 그 엔진을 에이전트가 부를 수 있는 **MCP 도구 두 개로 감싼 연결 프로그램**이다 |
| Qdrant | 임베딩 모델 (fastembed 등) | 임베딩 모델은 문장을 **숫자 목록으로 바꾸는** 쪽, Qdrant는 그 숫자를 **쌓아 두고 거리를 재는** 쪽이다. 실습에서는 연결 서버가 fastembed로 바꾼 뒤 Qdrant에 넣었다 |
| Qdrant | RAG | RAG는 "찾아서 입력에 넣고 답하게 하기"라는 **방식**이다. Qdrant는 그중 **찾는 단계**에 쓸 수 있는 부품 하나다 |
| 컬렉션 | 데이터베이스 전체 | 컬렉션은 한 저장소 안의 **서랍 한 칸**이다. 같은 칸의 벡터는 길이와 거리 재는 법이 같아야 한다 |

---

## 5. 많이들 오해하는 지점

**ㄱ. "설정 파일에 적었으니 그 값으로 돌았을 것이다"**

실습이 바로 반례다. `FASTEMBED_MODEL`에 bge-small을 적었지만, 0.8.1은 그 이름을 읽지 않아 기본 모델이 쓰였다. 오류도 경고도 없었다. 설정 이름은 서버 버전에 따라 바뀔 수 있으니, 내가 설치한 버전의 문서나 소스에서 읽는 이름을 확인한다. 더 확실한 방법은 **결과 쪽에서 확인하는 것**이다. 서버가 내놓는 도구 정의를 꺼내 보면, `COLLECTION_NAME`이 먹었는지는 `collection_name` 인자가 사라졌는지로 바로 보인다.

**ㄴ. "한 번 저장했으니 다음에도 찾을 수 있다"**

`:memory:`로 띄운 저장소는 연결 서버 프로그램이 끝나면 함께 사라진다. 또 Claude Code와 opencode는 각자 자기 연결 서버를 따로 띄웠으므로, 한쪽이 저장한 것을 다른 쪽에서 찾을 수 없다. 컬렉션 이름이 `policies`와 `memories`로 달랐던 것까지 겹치면, 저장소를 파일이나 서버로 옮겨 함께 쓰더라도 서로 다른 서랍을 뒤지게 된다.

**ㄷ. "벡터 검색 1위면 뜻이 제일 가깝다는 뜻이다"**

1위는 **그 임베딩 모델이 보기에** 가장 가깝다는 뜻이다. 실습에서 실제로 쓰인 `all-MiniLM-L6-v2`는 영어 위주로 학습된 모델로 알려져 있다. 문장이 세 개뿐이라, 환불 문장이 1위에 오른 이유가 뜻이 가까워서인지, "환불"이라는 같은 글자 덕분인지는 이 결과만으로 가를 수 없다. 저장할 때와 찾을 때 임베딩 모델이 다르면 좌표의 뜻도 달라지니, 모델을 바꿨다면 저장한 자료도 다시 바꿔 넣어야 한다.

---

## 6. 관련 용어

{% include term.html name="벡터" %} · {% include term.html name="임베딩" %} · {% include term.html name="RAG" %} · {% include term.html name="MCP" %} · {% include term.html name="컨텍스트 엔지니어링" %} · {% include term.html name="도구 정의서" %}
