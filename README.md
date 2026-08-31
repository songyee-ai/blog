# AI Agent 학습 기록

AI Agent 수업에서 배운 내용을 회차별로 기록하는 블로그입니다. Jekyll + GitHub Pages.

- 사이트: https://songyee-ai.github.io/blog

---

## 새 글 쓰기 — 4단계

### 1단계. 글 파일 만들기

블로그 폴더에서 아래 명령을 실행합니다. 파일을 직접 만들지 말고 **꼭 이 스크립트를 쓰세요.**
템플릿이 그대로 복사되므로 모든 글의 구조가 같게 유지됩니다.

```powershell
cd C:\airrel_work\blog
.\scripts\new-post.ps1 -Title "ReAct 패턴 실습" -Lesson 2 -Tags "ReAct, Tool" -Summary "생각-행동-관찰 루프를 구현했다." -Slug "react-agent"
```

실행하면 두 가지가 만들어집니다.

```
_posts/2026-09-07-react-agent.md        ← 글 파일
assets/images/react-agent/              ← 이 글의 이미지 폴더
```

| 옵션 | 필수 | 설명 |
| --- | --- | --- |
| `-Title` | ✅ | 글 제목 (한글 가능) |
| `-Lesson` | | 수업 회차 번호. 전체 목록 정렬에 사용 |
| `-Tags` | | 쉼표로 구분. 자동으로 YAML 배열로 변환 |
| `-Summary` | | 목록과 본문 맨 위에 보이는 한 줄 요약 |
| `-Slug` | | 파일명·URL용 **영문** 이름. 생략하면 `lesson-N` |
| `-Date` | | `yyyy-MM-dd`. 생략하면 오늘 |

> 제목이 한글이어도 `-Slug`는 영문으로 주세요. URL이 깨지지 않습니다.

### 2단계. 내용 채우기

만들어진 `_posts/....md`를 열어 빈칸을 채웁니다. 섹션은 6개입니다.

1. 한 줄 요약
2. 오늘 배운 것 (핵심 개념 / 왜 필요한가)
3. 실습 / 코드 (코드 + 실행 결과)
4. 그림 / 스크린샷 ← **이미지 없으면 이 섹션을 지우세요**
5. 막혔던 점과 해결 (표)
6. 스스로 확인하기 → 더 알아볼 것 → 참고 자료

`layout`, `author`, `categories`는 `_config.yml`이 자동으로 붙이므로 신경 쓰지 않아도 됩니다.

### 3단계. 이미지 넣기 (있는 경우)

**① 이미지 파일을 1단계에서 만들어진 폴더에 복사합니다.**

```
assets/images/react-agent/loop.png
```

**② 글에 아래 한 줄을 붙여넣고 파일이름만 바꿉니다.** (템플릿 3번 섹션 주석에 예시가 들어 있습니다)

캡션 있는 이미지 — 권장:

```liquid
{% include figure.html src="/assets/images/react-agent/loop.png" alt="ReAct 루프 구조" caption="그림 1. 생각-행동-관찰 루프" %}
```

캡션 없이 간단히:

```markdown
![ReAct 루프 구조]({{ site.baseurl }}/assets/images/react-agent/loop.png)
```

이미지가 너무 크면 `width`를 추가:

```liquid
{% include figure.html src="/assets/images/react-agent/loop.png" alt="설명" width="60%" %}
```

주의할 점:

- `src` 경로는 `/assets/...`로 **슬래시부터** 시작합니다. `/blog`는 자동으로 붙습니다.
- 파일명은 영문·숫자·하이픈으로. 한글이나 공백이 들어가면 링크가 깨집니다.
- `png`, `jpg`, `gif`, `svg`, `webp` 모두 됩니다.
- 스크린샷은 폭 1200px 이하로 줄여서 넣으면 로딩이 빠릅니다.

### 4단계. 발행하기

```bash
cd C:\airrel_work\blog; git add -A; git commit -m "2회차 ReAct 패턴 실습"; git push
```

push하면 GitHub Pages가 자동으로 빌드합니다. **1~2분 뒤** 사이트에 반영됩니다.
빌드 실패 여부는 저장소 [Actions 탭](https://github.com/songyee-ai/blog/actions)에서 확인하세요.

---

## 글 순서를 바꾸고 싶을 때

`_templates/post-template.md` **한 파일만** 고치면 그 이후에 만드는 모든 글에 적용됩니다.
(이미 쓴 글은 바뀌지 않습니다)

## 아직 공개하고 싶지 않은 글

`_posts/` 대신 `_drafts/` 폴더로 옮기면 사이트에 나오지 않습니다. 완성 후 다시 `_posts/`로 옮기세요.

---

## 저장소 구조

```
_config.yml                  사이트 설정 + 포스트 front matter 기본값
_posts/                      발행된 글
_drafts/                     아직 공개하지 않을 글
_templates/post-template.md  ★ 글 템플릿 (여기를 고치면 이후 모든 글이 바뀜)
_includes/figure.html        캡션 있는 이미지용
assets/images/<슬러그>/       글별 이미지
assets/main.scss             이미지·표 스타일
scripts/new-post.ps1         템플릿으로 새 글 생성
index.md / about.md / archive.md
```

## 로컬 미리보기 (선택)

Ruby가 설치되어 있으면 push 전에 확인할 수 있습니다.

```bash
bundle install
bundle exec jekyll serve
```

→ http://localhost:4000/blog

없어도 됩니다. push하면 GitHub Pages가 대신 빌드합니다.
