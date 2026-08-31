<#
.SYNOPSIS
    템플릿(_templates/post-template.md)을 그대로 복사해 새 포스트를 만듭니다.

.EXAMPLE
    .\scripts\new-post.ps1 -Title "ReAct 패턴으로 에이전트 만들기" -Lesson 3 -Tags "ReAct, LangChain, Tool" -Summary "생각-행동-관찰 루프로 도구를 쓰는 에이전트를 구현했다." -Slug "react-agent"
#>
param(
    [Parameter(Mandatory = $true)][string]$Title,
    [int]$Lesson = 0,
    [string]$Tags = "",
    [string]$Summary = "",
    [string]$Slug = "",
    [string]$Date = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$template = Join-Path $root "_templates\post-template.md"

if (-not (Test-Path $template)) { throw "템플릿을 찾을 수 없습니다: $template" }

# 날짜: 미지정 시 오늘
if ([string]::IsNullOrWhiteSpace($Date)) { $Date = (Get-Date).ToString("yyyy-MM-dd") }
if ($Date -notmatch '^\d{4}-\d{2}-\d{2}$') { throw "Date 형식은 yyyy-MM-dd 입니다: $Date" }

# 슬러그: 미지정 시 제목에서 생성 (한글은 그대로 두면 URL이 깨지므로 lesson 번호로 대체)
if ([string]::IsNullOrWhiteSpace($Slug)) {
    $Slug = $Title.ToLower() -replace '[^a-z0-9가-힣\s-]', '' -replace '\s+', '-'
    if ($Slug -match '[가-힣]') {
        $Slug = if ($Lesson -gt 0) { "lesson-$Lesson" } else { "post" }
    }
}

# 태그를 YAML 배열 형태로: a, b -> "a", "b"
$tagList = if ([string]::IsNullOrWhiteSpace($Tags)) { '' } else {
    ($Tags -split ',' | ForEach-Object { '"' + $_.Trim() + '"' }) -join ', '
}

$target = Join-Path $root ("_posts\{0}-{1}.md" -f $Date, $Slug)
if (Test-Path $target) { throw "이미 같은 파일이 있습니다: $target" }

$body = Get-Content $template -Raw -Encoding UTF8
$body = $body.Replace('{{TITLE}}',   $Title)
$body = $body.Replace('{{DATE}}',    $Date)
$body = $body.Replace('{{LESSON}}',  [string]$Lesson)
$body = $body.Replace('{{TAGS}}',    $tagList)
$body = $body.Replace('{{SUMMARY}}', $Summary)
$body = $body.Replace('{{SLUG}}',    $Slug)

# BOM 없는 UTF-8로 저장 (Jekyll이 BOM을 싫어합니다)
[System.IO.File]::WriteAllText($target, $body, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "새 글을 만들었습니다:" -ForegroundColor Green
Write-Host "  $target"

# 이미지 폴더 미리 생성
$imgDir = Join-Path $root ("assets\images\{0}" -f $Slug)
if (-not (Test-Path $imgDir)) {
    New-Item -ItemType Directory -Path $imgDir -Force | Out-Null
    New-Item -ItemType File -Path (Join-Path $imgDir ".gitkeep") -Force | Out-Null
}
Write-Host "이미지는 이 폴더에 넣으세요:" -ForegroundColor Cyan
Write-Host "  $imgDir"
