#import "@preview/touying:0.8.0": *
#import themes.simple: *

#set text(font: ("Noto Sans CJK JP", "Noto Sans CJK SC", "DejaVu Sans"))

#let today = datetime.today().display("[year]年[month]月[day]日")

#show: simple-theme.with(
  aspect-ratio: "16-9",
  footer: [Typst / Touying],
)

#title-slide[
  = Typst でスライド
  #v(1em)
  日本語プレゼンテーションの最小構成
  #v(1em)
  #text(cjk-latin-spacing: none)[#today]
]

= はじめに

== このスライドについて

- Typst + Touying で作成
- Nix flake で環境を固定
- 出力は PDF のみ

#pause

まずは最小構成を確認します。

== なぜ Typst？

- コンパイルが速い
- 数式・コード・図を同じソースで書ける
- テキストベースで差分管理しやすい

= 開発フロー

== 基本コマンド

```bash
nix develop
typst compile slides.typ slides.pdf
typst watch slides.typ slides.pdf
```

== LLM に任せる場合

+ 内容を `outline.md` に分離する
+ 生成後に必ずコンパイルする
+ PNG を確認してレイアウトを修正する

= まとめ

== まとめ

- Typst はスライド作成に向いている
- Touying で構造的なスライドを書ける
- Nix でバージョンとフォントを固定できる
