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

## クラスに対するアクセス制御レベル
クラスに対するアクセス制御のレベルとしては２つのみです。(⚠️メンバに対しては４つある)  
以下にまとめます。  
| 名前 | 指定方法 | アクセス許可の範囲 |
| :---: | :---: | :---: |
| package private | 何も書かない | 自分と同じパッケージに属するクラス |
| public | public | どこからでも |  

なので、クラスを宣言するときは、publicをつけるか何もつけないかの2択になります。
クラスだけでなく、列挙型である`enum`を宣言するときも同じです。  
`private class Hoge`　とかやってjavacすると、
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
入れ子構造にして複数クラスを宣言する方法は３つあります。またクラスの内部に宣言されたクラスのことをインナークラスと呼びます。  
なので、インナークラスの種類が３つとも言えます。
- メンバクラス（staticあり、staticなし）
- ローカルクラス
- 匿名クラス  

インナークラスはあまり登場頻度が高くないらしいので特徴をちょろっと箇条書きしておくにとどめておきます。

#### メンバクラスの特徴
- クラスブロックの内部で宣言される
- staticありで宣言した場合
  - 外部クラスのstaticなメンバにのみアクセスできる
  - 利用するときは、 `Outer.Inner oi = new Outer.Inner();`
- staticなしで宣言した場合
  - 外部クラスのstaticでないメンバにもアクセスできる
  - 外部クラスのインスタンスを生成してからでないと利用できない
  - 利用するときは `Outer o = new Outer; Outer.Inner i = o.new Inner();`

#### ローカルクラスの特徴
- クラスの中のメソッドの中で宣言される(そのメソッド内でのみ利用可能)
- 利用するときは(宣言されたメソッド内で)`Inner i = new Inner();`

#### 匿名クラスの特徴
- 文の中で（式の一部として）宣言(と利用)される
- 利用するときは`Object o = new Object() { ... }`


## 終わり
以上です。基礎から勉強し直すと色々曖昧だった部分が浮き彫りになって良いですね。  
何か誤りがあれば[Twitter](https://twitter.com/hiyoko_coder)か何かでこっそり教えてもらえると嬉しいです🙇‍♂️