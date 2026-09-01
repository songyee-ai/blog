<#
.SYNOPSIS
    템플릿을 복사해 새 글을 만듭니다. 글 종류(-Type)에 따라 템플릿과 저장 폴더가 달라집니다.

.DESCRIPTION
    review   → _templates/review-template.md   → _posts/review/
    glossary → _templates/glossary-template.md → _posts/glossary/
    build    → _templates/build-template.md    → _posts/build/

.EXAMPLE
    .\scripts\new-post.ps1 -Type review -Title "MCP로 도구 연결하기" -Lesson 5 -Tags "MCP, Tool" -Summary "..." -Slug "mcp-tools"

.EXAMPLE
    .\scripts\new-post.ps1 -Type glossary -Title "프로세스와 스레드" -Term "프로세스" -TermEn "Process" -Group "운영체제" -Lesson 3 -Summary "실행 중인 프로그램 하나." -Slug "term-process"

.EXAMPLE
    .\scripts\new-post.ps1 -Type build -Title "AI로 만든 반응속도 게임" -Lesson 4 -Tags "JavaScript, Claude Code" -Summary "..." -Slug "reaction-game"
#>
param(
    [ValidateSet("review", "glossary", "build")]
    [string]$Type = "review",

    [Parameter(Mandatory = $true)][string]$Title,
    [int]$Lesson = 0,
    [string]$Tags = "",
    [string]$Summary = "",
    [string]$Slug = "",
    [string]$Date = "",

    # -Type glossary 전용
    [string]$Term = "",
    [string]$TermEn = "",
    [string]$Group = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

# ── 종류별 템플릿 / 저장 폴더 ──────────────────────────────────
$template = Join-Path $root ("_templates\{0}-template.md" -f $Type)
$postDir  = Join-Path $root ("_posts\{0}" -f $Type)
$typeLabel = switch ($Type) {
    "review"   { "강의 리뷰" }
    "glossary" { "용어 정리" }
    "build"    { "작업물" }
}

if (-not (Test-Path $template)) { throw "템플릿을 찾을 수 없습니다: $template" }
if (-not (Test-Path $postDir)) { New-Item -ItemType Directory -Path $postDir -Force | Out-Null }

# ── 날짜 ───────────────────────────────────────────────────────
if ([string]::IsNullOrWhiteSpace($Date)) { $Date = (Get-Date).ToString("yyyy-MM-dd") }
if ($Date -notmatch '^\d{4}-\d{2}-\d{2}$') { throw "Date 형식은 yyyy-MM-dd 입니다: $Date" }

# ── glossary: -Term 이 비어 있으면 -Title 을 쓴다 ──────────────
if ($Type -eq "glossary" -and [string]::IsNullOrWhiteSpace($Term)) { $Term = $Title }

# ── 슬러그 ─────────────────────────────────────────────────────
# 한글 슬러그는 URL이 깨지므로 금지. 한글 제목이면 타입별 대체값을 쓴다.
if ([string]::IsNullOrWhiteSpace($Slug)) {
    $Slug = $Title.ToLower() -replace '[^a-z0-9가-힣\s-]', '' -replace '\s+', '-'

    if ($Slug -match '[가-힣]' -or [string]::IsNullOrWhiteSpace($Slug)) {
        $base = switch ($Type) {
            "review"   { if ($Lesson -gt 0) { "lesson-$Lesson" } else { "review" } }
            "glossary" { "term" }
            "build"    { "build" }
        }
        # 같은 이름이 이미 있으면 -2, -3 ... 으로 증가
        $Slug = $base
        $n = 1
        while (Get-ChildItem -Path $postDir -Filter "*-$Slug.md" -ErrorAction SilentlyContinue) {
            $n++
            $Slug = "$base-$n"
        }
    }
}

# ── 태그를 YAML 배열로: "a, b" → "a", "b" ──────────────────────
$tagList = if ([string]::IsNullOrWhiteSpace($Tags)) { '' } else {
    ($Tags -split ',' | ForEach-Object { '"' + $_.Trim() + '"' }) -join ', '
}

$target = Join-Path $postDir ("{0}-{1}.md" -f $Date, $Slug)
if (Test-Path $target) { throw "이미 같은 파일이 있습니다: $target" }

# ── 치환 ───────────────────────────────────────────────────────
$body = Get-Content $template -Raw -Encoding UTF8
$body = $body.Replace('{{TITLE}}',   $Title)
$body = $body.Replace('{{DATE}}',    $Date)
$body = $body.Replace('{{LESSON}}',  [string]$Lesson)
$body = $body.Replace('{{TAGS}}',    $tagList)
$body = $body.Replace('{{SUMMARY}}', $Summary)
$body = $body.Replace('{{SLUG}}',    $Slug)
$body = $body.Replace('{{TERM}}',    $Term)
$body = $body.Replace('{{TERM_EN}}', $TermEn)
$body = $body.Replace('{{GROUP}}',   $Group)

# BOM 없는 UTF-8로 저장 (Jekyll이 BOM을 처리하지 못합니다)
[System.IO.File]::WriteAllText($target, $body, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Host ("새 글을 만들었습니다  [{0}]" -f $typeLabel) -ForegroundColor Green
Write-Host "  $target"

# ── 이미지 폴더 미리 생성 ──────────────────────────────────────
$imgDir = Join-Path $root ("assets\images\{0}" -f $Slug)
if (-not (Test-Path $imgDir)) {
    New-Item -ItemType Directory -Path $imgDir -Force | Out-Null
    New-Item -ItemType File -Path (Join-Path $imgDir ".gitkeep") -Force | Out-Null
}
Write-Host "이미지는 이 폴더에 넣으세요:" -ForegroundColor Cyan
Write-Host "  $imgDir"
Write-Host ""
