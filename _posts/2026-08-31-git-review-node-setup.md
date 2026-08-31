---
layout: post
title: "Git·GitHub 복습과 바이브 코딩 작업대 만들기"
date: 2026-08-31 +0900
lesson: 2
categories: ["AI Agent 수업"]
tags: ["Git", "GitHub", "PowerShell", "Node.js", "npm", "Claude Code"]
summary: "Git·GitHub 용어를 퀴즈로 점검하고, 블로그 배포와 바이브 코딩을 위한 작업대(PowerShell·Node.js·npm)를 세웠다."
---

## 한 줄 요약

> Git·GitHub 용어를 퀴즈로 점검하고, 블로그 배포와 바이브 코딩을 위한 작업대(PowerShell·Node.js·npm)를 세웠다.

---

## 1. 오늘 배운 것

### 핵심 개념

**Git과 GitHub는 다른 것이다.**
Git은 내 컴퓨터에서 변경 이력을 관리하는 도구, GitHub는 그 저장소를 인터넷에 올려 공유하는 서비스다.
"Git 명령"과 "GitHub 기능"이 섞여 헷갈렸는데, 어디서 실행되는 일인지로 구분하면 정리된다.

| 용어 | 무엇을 하는가 | 어디서 일어나는가 |
| --- | --- | --- |
| `commit` | 변경 사항을 하나의 기록으로 확정 | 내 컴퓨터 |
| `push` | 내 기록을 원격 저장소로 올림 | 로컬 → GitHub |
| `pull` | 원격의 변경을 내 컴퓨터로 가져와 합침 | GitHub → 로컬 |
| `diff` | 두 상태의 **차이**를 줄 단위로 보여줌 | 주로 로컬, PR 화면에서도 확인 |
| `fork` | 남의 저장소를 내 계정으로 복사 | GitHub 안에서 |
| `PR` (Pull Request) | "이 변경을 합쳐 달라"는 제안을 보냄 | GitHub 기능 |

여기서 가장 크게 잡힌 감각은 **`push`는 파일 전송이 아니라 커밋(기록)의 이동**이라는 점이다.
그래서 커밋하지 않은 변경은 아무리 push해도 올라가지 않는다.

**작업대는 3개 층으로 쌓인다.**
바이브 코딩을 하려면 "명령을 입력할 곳 → 코드를 실행할 것 → 남의 코드를 가져올 것"이 순서대로 필요하다.

- **PowerShell** — 명령을 입력하는 셸(shell). 설치도, 실행도 결국 여기서 한다.
- **Node.js** — JavaScript를 브라우저 밖에서 실행해 주는 런타임. 개발 도구 대부분이 이걸 전제로 동작한다.
- **npm** — Node.js와 함께 설치되는 패키지 관리자. 남이 만든 코드를 명령 한 줄로 가져온다.

### 왜 필요한가

블로그가 GitHub Pages로 배포되니, 글을 쓰는 일이 곧 `commit → push`다.
용어를 모르면 글 하나 올릴 때마다 막힌다.

그리고 바이브 코딩은 "AI가 알아서 해 주는 것"이 아니라 **AI가 내 컴퓨터에서 명령을 실행하는 것**이다.
그 명령이 실행되는 바닥(셸)과 실행 환경(런타임)이 없으면 시작 자체가 안 된다.
오늘 설치한 것들은 기능이 아니라 **전제 조건**이었다.

---

## 2. 실습 / 코드

### 2-1. Git 기본 흐름 되짚기

글을 하나 올릴 때 실제로 쓰는 순서.

```powershell
git status                              # 지금 무엇이 바뀌었는지 확인
git add .                               # 기록할 변경을 담는다 (스테이징)
git commit -m "post: 2회차 학습 기록 추가"  # 담은 것을 하나의 기록으로 확정
git push origin main                    # 확정한 기록을 GitHub로 올린다
```

`diff`는 단계에 따라 보는 대상이 달라진다.

```powershell
git diff            # 아직 add하지 않은 변경
git diff --staged   # add했지만 아직 commit하지 않은 변경
```

### 2-2. Node.js와 npm 설치 — 명령을 직접 쓰지 않고 맡겼다

PowerShell 문법을 몰라서, 이미 설치돼 있던 Claude Code에 한글로 그대로 요청했다.

```text
> node.js랑 npm 설치해줘. 설치가 끝나면 버전도 확인해줘.
```

Claude Code가 설치를 진행하고, 이어서 검증 명령까지 실행해 결과를 보여줬다.

**실행 결과**

```
> node -v
v22.x.x

> npm -v
10.x.x
```

두 명령이 버전 문자열을 돌려주면 설치 성공이다.
`node -v`의 `-v`는 "버전을 알려 달라"는 옵션이고, 이렇게 **버전 확인은 설치 검증의 표준 방법**이다.

---

## 3. 그림 / 스크린샷

{% include figure.html src="/assets/images/git-review-node-setup/git-flow.svg" alt="Git의 로컬 3단계와 원격 저장소, fork와 Pull Request 흐름도" caption="그림 1. 오늘 배운 용어를 '무엇이 어디로 옮겨지는가'로 정리한 그림" %}

용어를 외우려 하지 않고 **화살표의 방향**으로 기억하기로 했다.
`add`와 `commit`은 내 컴퓨터 안에서만 움직이고, `push`와 `pull`만 인터넷을 건넌다.

---

## 4. 막혔던 점과 해결

| 막힌 지점 | 원인 | 해결 방법 |
| --- | --- | --- |
| PowerShell 명령이 무엇을 하는 명령인지 읽히지 않음 | 셸 사용 경험이 없어 명령의 구조(명령어 + 옵션 + 인자)를 몰랐다 | 우선 Claude Code에 한글로 요청해 진행하고, 실행된 명령을 나중에 한 줄씩 되짚어 읽었다. 근본 해결은 PowerShell 기초 학습으로 넘김 |
| 수업 노트의 설치 안내가 이해되지 않음 | 노트가 셸을 다룰 수 있다는 전제로 쓰여 있어 중간 단계가 생략돼 있었다 | 모르는 단어를 먼저 분리해서 "이건 무엇을 하는 도구인가"부터 확인한 뒤 안내를 다시 읽었다 |
| 도구 이름을 계속 "클라우드 코드"로 적음 | 발음이 비슷해 클라우드(cloud)로 잘못 기억 | **Claude Code**(클로드 코드)가 맞다. 클라우드 서비스가 아니라 내 컴퓨터에서 돌아가는 도구라는 점까지 함께 정리 |

**남은 숙제**: 지금은 명령을 맡기고 결과만 확인하는 단계다.
에이전트가 실행한 명령을 읽고 이상한지 판단할 수 있어야 진짜로 쓸 수 있다.

---

## 5. 스스로 확인하기

- [ ] `push`, `pull`, `diff`, `fork`, `PR`을 각각 한 문장으로 설명할 수 있는가?
- [ ] `fork`와 `clone`의 차이를 말할 수 있는가?
- [ ] 커밋하지 않은 변경이 push되지 않는 이유를 설명할 수 있는가?
- [ ] Node.js와 npm이 각각 무슨 역할인지 구분할 수 있는가?
- [ ] 설치가 잘 됐는지 확인하는 명령을 문서 없이 입력할 수 있는가?

---

## 6. 더 알아볼 것

- **PowerShell 기초** — 최우선. 명령 구조, 경로 이동(`cd`, `ls`), 파이프라인(`|`), 실행 정책(Execution Policy)
- Claude Code가 실행한 명령 로그를 직접 읽고 무슨 일이 일어났는지 설명해 보기
- `npm init`과 `package.json`의 구조 — 프로젝트 폴더는 무엇으로 구성되는가
- Git 브랜치와 merge conflict — 아직 안 겪었지만 반드시 만날 주제

---

## 참고 자료

- [Pro Git (한국어)](https://git-scm.com/book/ko/v2)
- [GitHub Docs — Pull Request](https://docs.github.com/pull-requests)
- [PowerShell 공식 문서](https://learn.microsoft.com/powershell/)
- [Node.js 공식 사이트](https://nodejs.org/)
- [npm 공식 문서](https://docs.npmjs.com/)
- [Claude Code 문서](https://docs.claude.com/en/docs/claude-code/overview)
