# AGENTS.md

## 目的

このリポジトリは、Typst と Touying で日本語スライドを作り、PDF を出力するためのものです。

## 固定バージョン

- Typst 0.15.1
- Touying 0.8.0
- テーマ: `themes.simple`

バージョンは `flake.lock` で固定されています。`flake.nix` の入力やパッケージバージョンを勝手に更新しないでください。

## セットアップとビルド

```bash
nix develop
typst compile slides.typ slides.pdf
typst watch slides.typ slides.pdf
```

初回コミット前は、Nix が `flake.nix` を認識できるように `git add flake.nix` を実行しておく。

目視確認用の PNG 生成:

```bash
mkdir -p preview
typst compile --format png --ppi 120 slides.typ "preview/slide-{p}.png"
```

フォント確認:

```bash
typst fonts | grep "Noto Sans CJK JP"
```

## ファイル構成

- `README.md`: 利用手順
- `slides.typ`: スライド本体
- `outline.md`: スライドの内容と構成
- `assets/`: 画像などの素材
- `preview/`: 確認用 PNG の出力先（Git 管理外）
- `slides.pdf`: ビルド成果物（Git 管理外）

## スライドを編集するときのルール

- 言語は日本語にする。
- 出力は PDF のみを前提にする。
- Touying は `#import "@preview/touying:0.8.0": *` を使う。
- テーマは `simple` を維持する。
- 内容は `outline.md` を正とする。構成を変える場合は `outline.md` も更新する。
- 1 枚のスライドに詰め込みすぎない。箇条書きは 3〜5 項目までを目安にする。
- 文字切れやはみ出しを避けるため、長いコードや長い URL は分割する。
- アニメーションが必要な場合だけ `#pause` を使う。`#pause` は PDF 上ではサブスライドごとにページが増えるため、配布用の静的 PDF では `config-common(handout: true)` を検討する。
- 数式は Typst の数式構文で書く。
- 画像を追加する場合は `assets/` に置き、相対パスで参照する。

## LLM の作業手順

1. `outline.md` を読んで、スライドの枚数と流れを確認する。
2. `slides.typ` を編集する。
3. `nix develop -c typst compile slides.typ slides.pdf` を実行する。
4. エラーがあれば修正して再コンパイルする。
5. PNG を生成し、各ページのはみ出し・重なり・改行を確認する。
6. 問題があれば `slides.typ` を修正して 3〜5 を繰り返す。
7. 最後に PDF のページ数と内容を確認する。

## 禁止事項

- `flake.lock` を理由なく更新しない。
- Git のコミットを勝手に作らない。
- `slides.pdf` や `preview/` を Git に追加しない。
- Touying の古いバージョンの API を混在させない。
