---
layout: post
category: glossary
title: "ComfyUI"
date: 2026-09-16 +0900
term: "ComfyUI"
term_en: "ComfyUI"
group: "개발환경"
oneliner: "블록(노드)을 선으로 이어 이미지 생성 과정을 조립하는 도구"
lesson: 14
tags: [개발환경, ComfyUI, 노드, 이미지생성, FLUX, ControlNet, 커스텀노드]
summary: "블록(노드)을 선으로 이어 이미지 생성 과정을 조립하는 도구"
related: ["확산 모델", "시드", "프롬프트", "VRAM", "양자화", "API", "파라미터", "Ollama"]
---

## 한 줄 정의

> 블록(노드)을 선으로 이어 이미지 생성 과정을 조립하는 도구

---

## 1. 비유로 이해하기

마당에 수도관 장난감을 늘어놓았다고 해 보자. 관 조각마다 하는 일이 하나씩 있다.

- 수도꼭지 블록은 물을 **내보낸다.**
- 거름망 블록은 물을 **걸러 낸다.**
- 물감 블록은 물에 **색을 탄다.**
- 마지막 컵 블록이 물을 **받는다.**

블록끼리 관으로 이으면 물이 흐르는 길이 생긴다. 순서를 바꾸거나 블록 하나를 갈아 끼우면 컵에 담기는 물이 달라진다. 레고처럼 **끼우고 빼면서** 길을 만드는 놀이다.

{% include figure.html src="/assets/images/term-comfyui/node-graph.svg" alt="ComfyUI 화면처럼 블록 여섯 개가 선으로 이어져 있다. UnetLoaderGGUF가 생성 모델을, CLIPTextEncode가 프롬프트를, VAEEncode와 ReferenceLatent가 참조 그림을 KSampler로 보내고, KSampler가 만든 결과를 VAEDecode가 이미지로 풀어낸다" caption="그림 1. 내 과제에서 쓴 노드 연결. 블록 하나가 한 가지 일을 하고, 선이 결과를 다음 블록으로 넘긴다" %}

그래서 실제로는 이렇다. ComfyUI에서 블록은 **노드**, 관은 **선**, 흐르는 물은 **데이터**(모델, 프롬프트를 바꾼 숫자, 압축된 그림)다. 모델 불러오기 → 프롬프트 읽기 → 그림 계산 → 이미지로 풀기, 이 단계가 전부 따로 떨어진 노드라서 **원하는 단계만 갈아 끼울 수 있다.** 화면에 그린 이 연결도를 **워크플로**라고 부르고, 파일(JSON)로 저장해 남에게 건넬 수도 있다.

---

## 2. 왜 필요한가

### 이미지 생성은 한 덩어리가 아니다

그림 한 장이 나오기까지 여러 부품이 돈다. 이 부품을 코드로 엮을지, 노드로 엮을지의 차이가 곧 ComfyUI와 diffusers의 차이다.

| | ComfyUI | diffusers |
| --- | --- | --- |
| 정체 | 노드를 잇는 **프로그램** | Python **코드 라이브러리** |
| 조립 방법 | 화면에서 선을 끌어 잇는다 | 파이프라인 클래스를 불러 코드로 짠다 |
| 강점 | 부품 교체가 쉽고, 커뮤니티 노드가 많다 | 코드 안에 바로 넣기 쉽다 |
| 메모리 | 메모리를 아끼는 최적화가 들어 있다 | 공식 방법 그대로면 더 많이 쓴다 |

### 윈도우에서 로컬로 돌리는 현실적인 길

12회차에 쓴 Ollama는 2026년 7월 기준 이미지 생성이 **macOS에서만** 실험으로 열려 있다. Windows와 Linux에서 FLUX.2-klein-4B를 내 컴퓨터로 돌리려면 ComfyUI가 가장 현실적이다. 대신 NVIDIA GPU와 CUDA 환경이 필요하고, 자원이 꽤 든다.

| 항목 | 4B 모델 기준 |
| --- | --- |
| 내려받을 파일 | 약 **12GB** |
| VRAM — ComfyUI 최적화 | 약 **8.4GB** |
| VRAM — diffusers 공식 방법 | 약 **13GB** |
| 권장 그래픽카드 | RTX 4070 **12GB**급 이상 |
| 8GB 카드 | 실패하거나 매우 느릴 수 있다 |

같은 모델인데 VRAM이 5GB 가까이 차이 난다. ComfyUI 쪽이 메모리를 아껴 쓰도록 다듬어져 있어서, 12GB 카드에서도 여유가 남는다.

### ControlNet 같은 부품을 끼우기 좋다

포즈·윤곽선·깊이를 고정하는 **ControlNet**은 보통 ComfyUI 노드로 조립한다. "포즈 추출 노드 → 조건 노드 → 계산 노드"처럼 끼워 넣으면 된다. 기본에 없는 노드는 **커스텀 노드** 묶음을 설치해서 쓴다. 과제에서 쓴 `OpenposePreprocessor`가 그런 노드로, `comfyui_controlnet_aux` 묶음에 들어 있다.

### 화면 없이도 쓸 수 있다

ComfyUI는 뒤에서 서버로 돈다. 그래서 웹 화면을 안 열고 **HTTP API**로 워크플로(JSON)를 보내도 그림이 나온다. 과제 노트북은 이 방식만 썼다. 콜랩에서 서버를 띄우고, 노드 목록을 코드로 적어 보냈다.

| 노드 | 하는 일 |
| --- | --- |
| `UnetLoaderGGUF` | 양자화된 GGUF 모델 파일을 불러온다 |
| `CLIPTextEncode` | 프롬프트를 모델이 읽는 숫자로 바꾼다 |
| `VAEEncode` | 참조 그림을 작은 공간으로 압축한다 |
| `ReferenceLatent` | 압축한 그림을 "참고하라"는 조건으로 붙인다 |
| `KSampler` | 시드·스텝·cfg대로 잡음을 걷어 그림을 만든다 |
| `VAEDecode` | 결과를 사람이 보는 이미지로 푼다 |

---

## 3. 어디서 만났나

**14회차** 이미지 생성 수업에서 ControlNet을 조립하는 도구로, 그리고 Windows·Linux 사용자가 FLUX.2를 로컬로 돌리는 길로 소개됐다. 12회차에서 VRAM 크기로 모델을 고르던 계산이 여기서도 그대로 쓰였다.

과제는 콜랩 무료 T4 위에서 ComfyUI를 **웹 화면 없이 HTTP API로만** 돌려 캐릭터에게 원하는 포즈를 입히는 도구였다. 모델은 FLUX.2-klein-4B의 GGUF Q4(2.6GB)를 썼다.

처음엔 `Node 'OpenposePreprocessor' not found` 오류가 났다. 예제 노트북의 설치 셀을 그대로 가져다 써서 `comfyui_controlnet_aux` 설치가 빠져 있었다. 커스텀 노드를 설치한 뒤 **서버를 재시작하자** 해결됐다.

[14회차 — 없던 그림을 만든다는 것]({{ site.baseurl }}/2026/09/16/image-generation/) · [작업물 — 원하는 포즈로 이미지 만들기]({{ site.baseurl }}/2026/09/16/pose-image-tool/) · [12회차 — 내 노트북에 LLM 들이기]({{ site.baseurl }}/2026/09/14/local-llm-ollama/)

---

## 4. 헷갈리는 개념

| 이 용어 | 비슷하지만 다른 것 | 차이 |
| --- | --- | --- |
| ComfyUI | 확산 모델(FLUX 등) | 모델은 그림을 만드는 **두뇌**, ComfyUI는 그 두뇌를 부품과 이어 돌리는 **작업대** |
| ComfyUI | diffusers | 둘 다 모델을 돌린다. ComfyUI는 노드를 잇는 프로그램, diffusers는 Python 코드 라이브러리 |
| ComfyUI의 노드 | 수업 회차를 부르는 "노드" | ComfyUI 노드는 화면 속 **블록 하나**. 이름만 같다 |
| 기본 노드 | 커스텀 노드 | 기본 노드는 설치하면 들어 있고, 커스텀 노드는 따로 받아 넣어야 한다 |

---

## 5. 많이들 오해하는 지점

**ㄱ. "커스텀 노드 폴더에 넣기만 하면 바로 뜬다"**

ComfyUI는 **서버가 켜질 때** 노드 목록을 읽는다. 서버가 돌고 있는 중에 설치하면 목록에 없어서 `not found` 오류가 난다. 설치했으면 서버를 다시 켠다. 내가 과제에서 그대로 겪었다.

**ㄴ. "ComfyUI는 화면에서 마우스로만 쓰는 도구다"**

화면은 겉모습이고 속은 서버다. 워크플로를 JSON으로 만들어 HTTP로 보내면 화면을 한 번도 안 열고도 그림이 나온다. 콜랩처럼 화면 띄우기가 번거로운 곳에서 특히 쓸 만하다.

**ㄷ. "ComfyUI만 깔면 어떤 컴퓨터에서든 돌아간다"**

ComfyUI는 작업대일 뿐, 계산은 그래픽카드가 한다. FLUX.2-klein-4B도 VRAM 8GB 남짓이 필요하고, 8GB 카드는 버거울 수 있다. 내장 그래픽 노트북이라면 콜랩 같은 원격 GPU로 가는 편이 빠르다.

---

## 6. 관련 용어

{% include term.html name="확산 모델" %} · {% include term.html name="시드" %} · {% include term.html name="프롬프트" %} · {% include term.html name="VRAM" %} · {% include term.html name="양자화" %} · {% include term.html name="API" %} · {% include term.html name="파라미터" %} · {% include term.html name="Ollama" %}
