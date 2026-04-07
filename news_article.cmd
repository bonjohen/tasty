@echo off
setlocal EnableExtensions EnableDelayedExpansion

if "%~1"=="" goto usage

set "TOPIC=%~1"
set "BRIEF=%~2"
if "%BRIEF%"=="" set "BRIEF=input\brief.txt"

set "ROOT=%~dp0"
cd /d "%ROOT%"

set "INPUT_DIR=%ROOT%input"
set "OUTPUT_DIR=%ROOT%output"
set "PROMPT_DIR=%ROOT%prompts"
set "LOG_DIR=%ROOT%logs"
set "TMP_DIR=%ROOT%tmp"

if not exist "%INPUT_DIR%" md "%INPUT_DIR%"
if not exist "%OUTPUT_DIR%" md "%OUTPUT_DIR%"
if not exist "%PROMPT_DIR%" md "%PROMPT_DIR%"
if not exist "%LOG_DIR%" md "%LOG_DIR%"
if not exist "%TMP_DIR%" md "%TMP_DIR%"

where claude >nul 2>&1
if errorlevel 1 (
  echo ERROR: claude was not found on PATH.
  exit /b 1
)

claude auth status >nul 2>&1
if errorlevel 1 (
  echo ERROR: Claude is not authenticated. Run: claude auth login
  exit /b 1
)

if not exist "%BRIEF%" (
  >"%INPUT_DIR%\brief_template.txt" (
    echo Summary:
    echo.
    echo Key facts:
    echo -
    echo -
    echo -
    echo.
    echo Source list:
    echo -
    echo -
    echo.
    echo Quotes:
    echo - Name, title: "quote"
    echo.
    echo Cautions / unverified:
    echo -
  )
  echo ERROR: Brief file not found: %BRIEF%
  echo A template was created at: %INPUT_DIR%\brief_template.txt
  exit /b 1
)

set "SLUG=%TOPIC: =-%"
set "SLUG=%SLUG::=-%"
set "SLUG=%SLUG:/=-%"
set "SLUG=%SLUG:\=-%"
set "SLUG=%SLUG:?=-%"
set "SLUG=%SLUG:<=-%"
set "SLUG=%SLUG:>=-%"
set "SLUG=%SLUG:|=-%"
set "SLUG=%SLUG:*=-%"
set "SLUG=%SLUG:"=%"

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "STAMP=%%I"

set "SYSTEM_PROMPT=%PROMPT_DIR%\news_writer_system.txt"
set "PAYLOAD_FILE=%TMP_DIR%\payload_%STAMP%.txt"
set "OUT_FILE=%OUTPUT_DIR%\%STAMP%_%SLUG%.md"
set "LOG_FILE=%LOG_DIR%\%STAMP%_%SLUG%.log"

if not exist "%SYSTEM_PROMPT%" (
  >"%SYSTEM_PROMPT%" (
    echo You are a careful news article writer.
    echo Write in a professional, neutral news style.
    echo Use only the facts provided in the source brief.
    echo Do not invent facts, quotes, dates, names, numbers, or attributions.
    echo If the source brief is incomplete, be conservative and say less.
    echo Prefer short paragraphs and clear concrete language.
    echo The output must be Markdown.
    echo Return only the finished article.
    echo Use this structure:
    echo 1. H1 headline
    echo 2. One-line dek
    echo 3. Article body
    echo 4. Optional "What is still unclear" section only if the brief explicitly contains uncertainty
    echo Do not include process notes, bullet summaries, or analysis outside the article.
  )
)

>"%PAYLOAD_FILE%" (
  echo Topic: %TOPIC%
  echo.
  echo Current date: %date% %time%
  echo.
  echo Instructions:
  echo Write one complete news article based only on the source brief below.
  echo Emphasize what is new, what happened, who is involved, and why it matters.
  echo If there are direct quotes in the brief, you may use them exactly as provided.
  echo If the brief contains uncertain or disputed claims, clearly attribute them and avoid overstating certainty.
  echo.
  echo Source brief begins.
  echo ----------------------------------------
  type "%BRIEF%"
  echo ----------------------------------------
  echo Source brief ends.
)

type "%PAYLOAD_FILE%" | claude --bare -p --output-format text --max-turns 1 --append-system-prompt-file "%SYSTEM_PROMPT%" "Write the article from the supplied topic and source brief. Return only the finished Markdown article." 1>"%OUT_FILE%" 2>"%LOG_FILE%"
if errorlevel 1 (
  echo ERROR: Claude command failed. See log: %LOG_FILE%
  del "%PAYLOAD_FILE%" >nul 2>&1
  exit /b 1
)

del "%PAYLOAD_FILE%" >nul 2>&1

echo Created: %OUT_FILE%
echo Log: %LOG_FILE%
exit /b 0

:usage
echo Usage:
echo   %~n0 "Topic" "path\to\brief.txt"
echo.
echo Example:
echo   %~n0 "OpenAI releases new model" "input\brief.txt"
exit /b 1
