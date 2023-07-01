---
title: "Hugoのフロントマターの変数の入力をGitフックで強制する" # must
date: 2023-06-27T21:19:47+09:00
categories: ["記事"]
draft: false

showtoc: true
tocopen: true

description: ""
tags: [Hugo, Gitフック]

cover: 
    image: "" # image path/url
    alt: "" # alt text
    caption: "" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
---

Hugoのフロントマターの値の入力を強制させるためにGitフックを使ったのでそのメモです
## Hugoのフロントマターとは

フロントマターはmdファイルの先頭に書くもので、これを使うことで、mdファイルのメタデータを設定することができます。  
[公式Docs](https://gohugo.io/content-management/front-matter/) に書いてある通り、フロントマターの記述方法は、TOML, YAML, JSON, ORG形式の４つのうちどれかを選ぶことができます。  
フロントマターの変数には、定義済みのもの（date, draft, imagesなど）と自分で自由に定義できるものがあります。  
hugoには、Archetypesというmdファイルを作る際のテンプレートのようなものがあり、このArchetypesにフロントマターを設定しておくことで、いちいち最初からフロントマターをちまちま書く必要がなくなります。  
私の場合は、以下のように設定しています。  
- 日報のフロントマター
``` yml
---
title: {{ .Name | time.Format .Site.Params.DateFormat }} # DataFormatで指定した形式の日時がタイトルになる
date: {{ .Date }} # hugo new でmdファイルを作成したときの日時が入る
categories: "日報"
draft: false

score:  # 0 ~ 10 # 自分で定義した変数
---
```

- 記事のフロントマター
```yml
---
title: "" 
date: {{ .Date }}
categories: ["記事"]
draft: false

showtoc: true # 目次を表示するかどうか（使用しているhugoのテーマ"PaperMod"で定義されている変数）
tocopen: true # ページをロードした時に目次を開いた状態にするかどうか（使用しているhugoのテーマ"PaperMod"で定義されている変数）

description: ""
tags: []

cover: 
    image: "" # image path/url
    alt: "" # alt text
    caption: "" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
---
```

## フロントマターで定義した変数に値を設定することをGitフックを使って強制する
フロントマターにはさまざまな変数を設定することができます。  
しかしそれらの値の設定の強制をすることは、hugoではサポートしていないっぽいです（私の調べた限りでは。もし方法があれば教えてください）。  
piyopanman.devの日報では、その日1日の評価を0から10の間で評価するためにscoreという変数を設定しています。  
scoreごとに日報一覧表示させたときに表示する色を変え、視覚的にその日どれくらい頑張ったかをわかりやすくする、ということをしています。
具体的には、0~4だと青、5~7だと緑、8~9だとピンク、10だと赤、という感じです。  
{{< figure src="/images/articles/hugo-front-matter-git-hook-02.png" >}}
そのため、scoreには必ず0から10の範囲の数字を設定する必要があります。  
しかし前述した通り、hugoでは変数の値の設定を強制することは機能として提供していないため、たびたびscoreを設定しないまま日報を公開してしまうことがありました。
そこで、Gitフックを使って、コミットする前にscoreに値が設定されているかどうかをチェックし、されていなかったらコミットを中止するような仕組みを作ることにしました。  
書いたフックスクリプトは次のとおりです。  
```sh:pre-commit
#!/bin/bash

score_regex='^score: (10|[0-9])'

# daily-reports以下のmdファイルにscoreを0-10で指定していることをチェックする
is_can_commit=true
for file in $(git diff --name-only --cached | grep 'content/daily-reports/.*\.md$'); do
    line=$(awk 'NR==7' "$file")
    if [[ !("$line" =~ $score_regex) ]]; then
	      is_can_commit=false
        echo "$file にscoreが0-10で指定されていないよ"
    fi
done

if ! $is_can_commit; then
  echo "日報のmdファイルにscoreを指定してからコミットしてください"
  exit 1
fi
```

- ステージングに追加された変更されたファイルのうち（`git diff --name-only --cached`）
- `content/daily-reports/`ディレクトリ以下のmdファイルの（`grep 'content/daily-reports/.*\.md$'`）
- ７行目が（`line=$(awk 'NR==7' "$file")`）
- `score`で始まり、0〜10のいずれかでおわる（`"$line" =~ $score_regex`）
ことをチェックし、もしそうなっていないファイルがあれば、scoreが0から10で指定されていない旨を出力し、コミットを中止します。  
以下は、実際にscoreを設定せずにコミットしようとしたときの出力です。  
{{< figure src="/images/articles/hugo-front-matter-git-hook-01.png" >}}
シェルスクリプトはほとんど書いたことがないので良くない書き方をしてる部分が多いかもしれません。  
お気づきの点がありましたらコメントなどでご指摘いただけると幸いです🙏

## Gitフックをgit管理する
デフォルトだと、Gitフックのフックスプリプトは`.git/hooks`以下に定義されており、Git管理することができません。
しかし、（個人ブログから必要ないかもしれないけど）GitフックもGit管理したかったので以下のことをしました。
- `.githooks`ディレクトリを作る
- `.githooks`ディレクトリのなかに`pre-commit`を作成し、上で紹介したフックスクリプトを記述する
- `git config --local core.hooksPath .githooks`でフックスクリプトの場所を`.githooks`以下であると設定する
これでGit管理できるようになりました。

## 終わり
やったこととしては以上です。何かお気づきの点がありましたらぜひ教えてください。
最後までお読みいただきありがとうございました。