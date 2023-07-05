---
title: Javaのクラスのアクセス制御と複数クラスの宣言
date: 2023-01-05T23:11:28+09:00
categories: ["記事"]
draft: false

showtoc: true
tocopen: true

description: ""
tags: ["Java", "開発"]
cover: 
    image: "" # image path/url
    alt: "" # alt text
    caption: "" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
---

Javaを基礎から復習していて、クラスについて理解が曖昧だった部分があったのでまとめておくぞい！

## Javaのアクセス修飾子
以下の４つがあります。  
| 名前 | 指定方法 | アクセス許可の範囲 |
| :---: | :---: | :---: |
| public | public | どこからでも |  
| protected | protected | 自分と同じパッケージか自分のサブクラス
| package private | 何も書かない | 自分と同じパッケージに属するクラス |
| private | private | 自分のクラスのみ |

メンバにはこの４つのアクセス修飾子を指定することができます。  
（メンバは、クラスを構成する変数やメソッドなどのこと）

## トップレベルクラスに対するアクセス制御レベル
トップレベルクラスとは、ネストされていない一番外側のクラスのことです。反対はインナークラスになります。  
トップレベルクラスに対するアクセス制御のレベルとしてはpublicかprotected２つのみです。
なので、クラスを宣言するときは、publicをつけるか何もつけないかの2択になります。
クラスだけでなく、列挙型である`enum`を宣言するときも同じです。  
トップレベルクラスについて`private class Hoge`　とかやってjavacすると、
> 修飾子privateをここで使用することはできません  

って言って怒られます。

## １つのファイルに複数のクラスを宣言する
1つのファイルに複数のクラスを宣言するとき、大きく分けて２つ方法があります。
- 入れ子構造にせずに宣言する
- 入れ子構造にして宣言する  

まず入れ子構造にせずに宣言する方から。
### 入れ子構造にせずに宣言する
Javaのクラス宣言のルールとして、
- １つのファイルに１つのpublicクラス
- ファイル名 = publicクラス名  

がある。  
なので、これを守っていれば１つのファイルに複数のクラスを宣言することができます。  

いくつか例を見ます。  

①以下のようなpublic classが１つ、package private class が複数ある`Hoge.java`はOKです。javacすると、`Hoge.class`, `Fuga.class`, `Piyo.class`ができます。

```java:Hoge.java
public class Hoge {} // public class

class Fuga {} // package private class 

class Piyo {} // package private class
```
  
  
②以下のようなpublic class が１つのファイルに複数あるファイルはNGです。  
> クラス Fugaはpublicであり、ファイルFuga.javaで宣言する必要があります  

とエラーが出ます。  
publicなenumとpublicなclassを１つのファイルに同居させるのもNGです。 
```java:
public class Hoge {} // public class

public class Fuga {} // ⚠️public class２つめ！

class Piyo {} // package private class
```


③以下のようなpublic classが１つもなく、package private class が複数あるファイルは…**OKです！**  
しかも、ファイル名は自由に決められます！`Hoge.java`でも`Fuga.java`でも`Yakiniku.java`でもOKです！  
ただこのケースはあまり一般的ではないと思います！！
```java
class Hoge {} // package private class

class Fuga {} // package private class

class Piyo {} // package private class
```

### 入れ子構造にして宣言する
入れ子構造にして複数クラスを宣言する方法は３つあります。またクラスの内部に宣言されたクラスのことを**インナークラス(内部クラス)**と呼びます。  
なので、インナークラスの種類が３つとも言えます。  
また、使用できるアクセス修飾子に関して、冒頭に説明したトップレベルクラスと違う注意が必要です。これについてもそれぞれのインナークラスの特徴のところで説明をします。
- メンバクラス（非static）
- ローカルクラス
- 匿名クラス  

インナークラスはあまり登場頻度が高くないらしいので特徴をちょろっと箇条書きしておくにとどめておきます。

#### メンバクラスの特徴
- クラスブロックの内部で宣言される
- 非static
  - 外部クラスのstaticでないメンバにもアクセスできる
  - 外部クラスのインスタンスを生成してからでないと利用できない
  - 利用するときは `Outer o = new Outer; Outer.Inner i = o.new Inner();`
- static
  - 外部クラスのstaticなメンバにのみアクセスできる
  - 利用するときは、 `Outer.Inner oi = new Outer.Inner();`  
  - staticなメンバクラスは、インナークラスに含まれません（[参考](https://docs.oracle.com/javase/specs/jls/se20/html/jls-8.html#jls-8.1.3)）。しかし、「入れ子構造にして宣言するクラス」の一種ではあるため、紹介することにしました
- アクセス修飾子について
  - ４つ全てを使うことができる
  - 「メンバクラス」という名前の通り、メンバ変数やメンバメソッドと同じような扱いであるため

#### ローカルクラスの特徴
- クラスの中のメソッドの中で宣言される(そのメソッド内でのみ利用可能)
- 利用するときは(宣言されたメソッド内で)`Inner i = new Inner();`
- アクセス修飾子
  - 何もつけない
  - その「メソッド」内でのみ使われるクラスなので、どのクラスからとかどのパッケージからとかを指定する必要はないため
  - 一般に、アクセス修飾子を何もつけない=package privateとなるが、ローカルクラスにのみ限定していうと、そういう意味ではない。ローカルクラスの寿命は定義されたメソッド内のみであるため、package privateという概念は適用されない
  - ちなみに、ローカルクラスに何らかのアクセス修飾子をつけてjavacすると` エラー: 式の開始が不正です`と怒られる

#### 匿名クラスの特徴
- 文の中で（式の一部として）宣言(と利用)される
- 利用するときは`Object o = new Object() { ... }`
- アクセス修飾子
  - そもそもクラスの宣言をしないので、何も指定しない


## 終わり
以上です。基礎から勉強し直すと色々曖昧だった部分が浮き彫りになって良いですね。  
何か誤りがあれば[Twitter](https://twitter.com/hiyoko_coder)か何かでこっそり教えてもらえると嬉しいです🙇‍♂️

## 参考
- すっきりわかるJava入門実践編第５章
- プロになるJava第14章
- [Java Language Specification Chapater8. Classes](https://docs.oracle.com/javase/specs/jls/se20/html/jls-8.html#jls-8.1.3)