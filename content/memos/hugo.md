---
title: 【Hugo】紛らわしい用語の整理
date: 2022-12-30T15:24:46+09:00
categories: ["メモ", "開発"]
draft: false 

tags: ["Hugo"]
---

紛らわしい用語とか紛らわしい用法とかまとめておく！  
間違っていたらTwitterか何かで教えてください！！！！
# Section, Content Type, Archetype
## Section
- [公式](https://gohugo.io/content-management/sections/)
- ディレクトリ構造によって決められるやつ。  
- content直下のディレクトリか`_index.md`を含むディレクトリはセクション扱いになる
- front matterで上書きできない
- [sectionに関する変数やメソッド](https://gohugo.io/variables/page/#section-variables-and-methods)がある

## Content Type
- [公式](https://gohugo.io/content-management/types/)
- typeが設定されていない場合は所属しているディレクトリになる
- どのテンプレートを使ってレンダリングされるかに使用される

## Archetype
- [公式](https://gohugo.io/content-management/archetypes/)
- `hugo new xxx`したときに、どの`.md`ファイルを使ってファイルを生成するかを決める
- `hugo new posts/hoge.md`ってしたら、`archetype/posts.md`をもとにして`content/posts/hoge.md`が作られる
- `hugo new xxx`で作ったコンテントファイルで`{{ .Site.Xxx }}`みたいに変数は使えないが、`archetype`ディレクトリ内の`.md`ファイルでは使える

# Taxonomy, Term, Value
## Taxonomy
- [公式]()
- ユーザが独自にコンテンツを分類するための仕組み
- コンテンツを分類するために使われる
- `config.yml`内でサイトレベルで設定するもの
- Taxonomyごとのリンクを設定できる（`/categories/` `/tags/`など）
- デフォルトでは、`categories`と`tags`というtaxonomyが設定されている

## Term
- taxonomyの中のkey(categoriesの中の *memo* とかがterm)

## Value
- Termにアサインされたコンテンツ  
  
front matterの中で  
`taxonomy: [term1, term2]`  
ってする。例えば,  
`categories: [memo, development]`  
なので、Valueにあたるのはコンテンツファイル。

# 変数
**変数は大体templete内で使うもの！**
## Site変数
- `.Site.Xxx`の形
- config.yml内で定義されているものと、組み込みで最初からあるもの
- partialテンプレート内では`.Site.Params.Xxx`の形で使う

## Page変数
- `.Xxx`の形
- 抽出される場所は
  - コンテンツファイルのfront matter
  - コンテンツファイルのある場所
  - コンテンツのボディ
  - のいずれか
- front matterで設定した値は`.Params.xxx`でアクセスできる(`.Param "xxx"`でも可)
    - ネストされている場合は`.Param "xxx.yyy"`

## File変数
- `.File.Xxx`の形
- ディレクトリ構造とかに基づいた値

## shortcode変数
- `.Xxx`の形
- 独自のshortcodeを作成する際に使うことが多い（[shortcode template](https://gohugo.io/templates/shortcode-templates/)）
- shortcodeは`.md`ファイル内でhtmlを書かなくて済むようにという思想から作られたものだが、だからと言ってshortcode変数が(`content/`)`.md`ファイル内で使えるというわけではない
  - `content/xxx.md`ファイル内でfront matterで定義された値にアクセスするには、  
  `{ {< param yyy >} }`という形でアクセスする([公式](https://gohugo.io/content-management/shortcodes/#param))