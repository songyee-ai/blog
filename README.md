# AI Agent 학습 기록

AI Agent 수업에서 배운 내용을 기록하는 블로그입니다. Jekyll + GitHub Pages.

- 사이트: https://songyee-ai.github.io/blog

## 글의 세 종류

| 종류 | `-Type` | 목록 페이지 | 성격 |
| --- | --- | --- | --- |
| 강의 리뷰 | `review` | `/review/` | 회차별 수업 기록 |
| 용어 정리 | `glossary` | `/glossary/` | 용어 1개 = 글 1개 |
| 작업물 | `build` | `/build/` | 만든 것 + 제작 과정 |

> **카테고리는 형식, 태그는 주제.** 카테고리는 위 3개로 고정입니다.
> Git·PATH·LLM 같은 주제 분류는 전부 `tags`로 넣으세요.

---

## 새 글 쓰기 — 4단계

### 1단계. 글 파일 만들기

블로그 폴더에서 아래 명령을 실행합니다. 파일을 직접 만들지 말고 **꼭 이 스크립트를 쓰세요.**
템플릿이 그대로 복사되므로 모든 글의 구조가 같게 유지됩니다.

**강의 리뷰**

```powershell
cd C:\airrel_work\blog
.\scripts\new-post.ps1 -Type review -Title "MCP로 도구 연결하기" -Lesson 5 -Tags "MCP, Tool" -Summary "..." -Slug "mcp-tools"
```

**용어 정리**

```powershell
.\scripts\new-post.ps1 -Type glossary -Title "프로세스와 스레드" -Term "프로세스" -TermEn "Process" -Group "운영체제" -Lesson 3 -Summary "실행 중인 프로그램 하나." -Slug "term-process"
```

**작업물**

```powershell
.\scripts\new-post.ps1 -Type build -Title "AI로 만든 반응속도 게임" -Lesson 4 -Tags "JavaScript, Claude Code" -Summary "..." -Slug "reaction-game"
```

실행하면 두 가지가 만들어집니다.

```
_posts/<종류>/2026-09-07-<슬러그>.md    ← 글 파일
assets/images/<슬러그>/                 ← 이 글의 이미지 폴더
```

#### 공통 옵션

| 옵션 | 필수 | 설명 |
| --- | --- | --- |
| `-Type` | | `review`(기본) / `glossary` / `build` |
| `-Title` | ✅ | 글 제목 (한글 가능) |
| `-Lesson` | | 수업 회차 번호. 리뷰 목록 정렬에 사용 |
| `-Tags` | | 쉼표로 구분. 자동으로 YAML 배열로 변환 |
| `-Summary` | | 목록과 본문 맨 위에 보이는 한 줄 요약 |
| `-Slug` | | 파일명·URL용 **영문** 이름 |
| `-Date` | | `yyyy-MM-dd`. 생략하면 오늘 |

#### 용어 정리 전용 옵션

| 옵션 | 설명 |
| --- | --- |
| `-Term` | 용어 이름. 생략하면 `-Title` 값을 씁니다 |
| `-TermEn` | 영문 표기. 사전 표에서 작게 표시됩니다 |
| `-Group` | 분야. 사전에서 이 값으로 묶입니다 (개발환경 / 운영체제 / Git / LLM / 에이전트 / 웹) |

> `-Slug`를 생략하고 제목이 한글이면 타입별 대체값(`lesson-N` / `term-N` / `build-N`)이 붙습니다.
> 같은 이름이 있으면 `term-2`, `term-3`으로 자동 증가합니다. **한글 슬러그는 URL이 깨지므로 쓰지 않습니다.**

### 2단계. 내용 채우기

만들어진 파일을 열어 빈칸을 채웁니다. `layout`, `author`, `category`는 자동으로 붙습니다.

종류별 front matter 필드:

| 종류 | 필드 | 설명 |
| --- | --- | --- |
| 공통 | `title` `date` `lesson` `tags` `summary` | |
| 용어 | `term` | 사전 표에 나오는 용어 이름 |
| | `term_en` | 영문 표기. 없으면 빈 문자열 |
| | `group` | 분야. 사전에서 묶는 기준 |
| | `oneliner` | 사전 표의 한 줄 정의 |
| | `related` | 관련 용어 이름 배열. 예: `["스레드", "CPU"]` |
| 작업물 | `demo_url` | 체험 주소. 비우면 버튼이 안 나옵니다 |
| | `repo_url` | 코드 저장소 주소 |
| | `thumbnail` | 카드 썸네일. **파일이 실제로 있을 때만** 표시됩니다 |
| | `stack` | 사용 기술 배열. 예: `["HTML", "JavaScript"]` |
| | `status` | `완성` / `진행중` |

### 3단계. 이미지 넣기 (있는 경우)

**① 이미지 파일을 1단계에서 만들어진 폴더에 복사합니다.**

```
assets/images/reaction-game/screen.png
```

**② 글에 아래 한 줄을 붙여넣고 파일이름만 바꿉니다.**

캡션 있는 이미지 — 권장:

```liquid
{% include figure.html src="/assets/images/reaction-game/screen.png" alt="완성 화면" caption="그림 1. 완성 화면" %}
```

캡션 없이 간단히:

```markdown
![완성 화면]({{ site.baseurl }}/assets/images/reaction-game/screen.png)
```

이미지가 너무 크면 `width`를 추가:

```liquid
{% include figure.html src="/assets/images/reaction-game/screen.png" alt="설명" width="60%" %}
```

주의할 점:

- `src` 경로는 `/assets/...`로 **슬래시부터** 시작합니다. `/blog`는 자동으로 붙습니다.
- 파일명은 영문·숫자·하이픈으로. 한글이나 공백이 들어가면 링크가 깨집니다.
- `png`, `jpg`, `gif`, `svg`, `webp` 모두 됩니다.
- 스크린샷은 폭 1200px 이하로 줄여서 넣으면 로딩이 빠릅니다.
- 도식(SVG)은 **배경을 투명(`fill="none"`)으로** 맞춥니다.

### 4단계. 발행하기

```bash
cd C:\airrel_work\blog; git add -A; git commit -m "5회차 MCP로 도구 연결하기"; git push
```

push하면 GitHub Pages가 자동으로 빌드합니다. **1~2분 뒤** 사이트에 반영됩니다.
빌드 실패 여부는 저장소 [Actions 탭](https://github.com/songyee-ai/blog/actions)에서 확인하세요.

---

## 용어끼리 연결하기

리뷰 글이나 작업물 글에서 용어를 언급할 때 이렇게 쓰면 용어 글로 링크가 걸립니다.

```liquid
{% include term.html name="프로세스" %}
```

**용어 글이 아직 없어도 안전합니다.** 글이 없으면 링크 없이 텍스트만 나옵니다.
나중에 그 용어 글을 만들면 자동으로 링크가 붙습니다.

## 글 순서를 바꾸고 싶을 때

`_templates/` 안의 해당 템플릿 **한 파일만** 고치면 그 이후에 만드는 모든 글에 적용됩니다.
(이미 쓴 글은 바뀌지 않습니다)

## 아직 공개하고 싶지 않은 글

`_posts/` 대신 `_drafts/` 폴더로 옮기면 사이트에 나오지 않습니다. 완성 후 다시 옮기세요.

---

## 저장소 구조

```
_config.yml                     사이트 설정 + 폴더별 category 기본값
_posts/review/                  강의 리뷰
_posts/glossary/                용어 정리
_posts/build/                   작업물
_drafts/                        아직 공개하지 않을 글
_templates/review-template.md   ★ 리뷰 글 템플릿
_templates/glossary-template.md ★ 용어 글 템플릿
_templates/build-template.md    ★ 작업물 글 템플릿
_includes/figure.html           캡션 있는 이미지
_includes/term.html             용어 상호 링크
assets/images/<슬러그>/          글별 이미지
assets/main.scss                커스텀 스타일
scripts/new-post.ps1            템플릿으로 새 글 생성
index.md                        홈 (큐레이션)
review.md / glossary.md / build.md / archive.md / about.md
```

> `_posts/` **아래** 하위 폴더 이름은 Jekyll이 카테고리로 인식하지 않습니다.
> 폴더는 파일 정리용이고, 카테고리는 front matter의 `category` 값이 진실입니다.

## 로컬 미리보기 (선택)

Ruby가 설치되어 있으면 push 전에 확인할 수 있습니다.

```bash
bundle install
bundle exec jekyll serve
```

→ http://localhost:4000/blog

없어도 됩니다. push하면 GitHub Pages가 대신 빌드합니다.

---

## 문제가 생겼을 때

### `이 시스템에서 스크립트를 실행할 수 없으므로 ...` (UnauthorizedAccess)

Windows가 기본적으로 `.ps1` 실행을 막고 있어서 나는 오류입니다. 한 번만 아래를 실행하면 됩니다.
관리자 권한은 필요 없고, 내 계정에만 적용됩니다.

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

정책을 바꾸지 않고 이번만 실행하려면:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\new-post.ps1 -Type review -Title "제목" -Lesson 5 -Slug "slug"
```

### 스크립트 안내 메시지의 한글이 깨져 보일 때

`scripts/new-post.ps1`은 **BOM 있는 UTF-8**로 저장해야 합니다.
Windows PowerShell 5.1은 BOM이 없으면 `.ps1`을 ANSI(CP949)로 읽어 한글이 깨집니다.
반대로 `_posts/`의 글 파일은 **BOM 없는 UTF-8**이어야 합니다 (Jekyll이 BOM을 처리하지 못함).
스크립트가 이 두 규칙을 알아서 지키므로, 글 파일을 다른 편집기로 저장할 때만 주의하세요.

### 용어 사전에 글이 안 보일 때

front matter의 `category: glossary`와 `term` 값이 있는지 확인하세요.
사전 표는 `term` 기준으로 정렬되므로 `term`이 없으면 `title`로 대체됩니다.

### 글을 push했는데 사이트에 안 보일 때

1. [Actions 탭](https://github.com/songyee-ai/blog/actions)에서 빌드 실패 여부 확인
2. 파일이 `_posts/<종류>/`에 있고 이름이 `YYYY-MM-DD-슬러그.md` 형식인지 확인
3. front matter의 `---` 두 줄이 그대로 있는지 확인
4. 브라우저 강력 새로고침 (`Ctrl+Shift+R`) — 캐시 때문일 수 있습니다
