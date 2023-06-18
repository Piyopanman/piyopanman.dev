#!/bin/bash

score_regex='^score: (10|[0-9])'

# daily-reports以下のmdファイルにscoreを0-10で指定していることをチェックする
is_can_commit=true
for file in content/daily-reports/*.md; do
    line=$(awk 'NR==7' "$file")
    if [[ !("$line" =~ $score_regex) ]]; then
	    is_can_commit=false
        echo "$file にscoreが0-10で指定されていないよ"
    fi
done

if ! $is_can_commit; then
  echo "fatal: 日報のmdファイルにscoreを指定してからコミットしてください"
  exit 1
fi