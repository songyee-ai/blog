# AI Agent 학습 기록

AI Agent 수업에서 배운 내용을 회차별로 기록하는 블로그입니다.
Jekyll + GitHub Pages로 만들어졌습니다.

- 배포 주소: https://songyee-ai.github.io/blog

## 새 글 쓰기

템플릿을 직접 복사하지 말고 **스크립트를 사용하세요.** 구조가 항상 같게 유지됩니다.

```powershell
.\scripts\new-post.ps1 -Title "제목" -Lesson 3 -Tags "태그1, 태그2" -Summary "한 줄 요약" -Slug "english-slug"
```

| 옵션 | 필수 | 설명 |
| --- | --- | --- |
| `-Title` | ✅ | 글 제목 (한글 가능) |
| `-Lesson` | | 수업 회차 번호. 목록 정렬에 사용 |
| `-Tags` | | 쉼표로 구분. 자동으로 YAML 배열로 변환 |
| `-Summary` | | 목록과 본문 맨 위에 보이는 한 줄 요약 |
| `-Slug` | | 파일명·URL에 쓰는 영문 슬러그. 생략하면 `lesson-N` |
| `-Date` | | `yyyy-MM-dd`. 생략하면 오늘 |

`_posts/YYYY-MM-DD-slug.md`가 생성됩니다. 내용을 채우고 커밋하면 배포됩니다.

## 글 구조

모든 포스트는 `_templates/post-template.md`의 6개 섹션을 따릅니다.

1. 한 줄 요약
2. 오늘 배운 것 (핵심 개념 / 왜 필요한가)
3. 실습 / 코드 (코드 + 실행 결과)
4. 막혔던 점과 해결 (표)
5. 스스로 확인하기 (체크리스트)
6. 더 알아볼 것 · 참고 자료

레이아웃·작성자·카테고리는 `_config.yml`의 `defaults`에서 자동으로 붙습니다.
개별 글에서 front matter로 덮어쓸 수 있습니다.

## 저장소 구조

```
_config.yml                  사이트 설정 + 포스트 front matter 기본값
_posts/                      발행된 글
_drafts/                     아직 공개하지 않을 글
_templates/post-template.md  ★ 글 템플릿 (여기를 고치면 이후 모든 글이 바뀜)
scripts/new-post.ps1         템플릿으로 새 글 생성
index.md / about.md / archive.md
```

## 로컬 미리보기 (선택)

Ruby가 설치되어 있으면:

```bash
bundle install
bundle exec jekyll serve
```

→ http://localhost:4000/blog

없어도 됩니다. GitHub에 push하면 GitHub Pages가 대신 빌드합니다.
