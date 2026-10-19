---
name: typst-slides
description: Typst と Touying で日本語スライドを作成・編集し、Nix flake で PDF をビルドする。Use when the user asks for Typst/Touying slides, Japanese presentation PDFs, flake-based slide environments, or mentions slides.typ, outline.md, flake.nix.
---

# Typst Slides

Typst と Touying で日本語スライドを作り、PDF に出力するためのスキルです。

## 固定バージョン

- Typst 0.15.1
- Touying 0.8.0
- テーマ: `themes.simple`

バージョンは `flake.lock` で固定します。勝手に更新しないでください。

## 新規デッキを作る

この `SKILL.md` と同じディレクトリにある `scripts/scaffold.sh` を使います。

```bash
.opencode/skills/typst-slides/scripts/scaffold.sh ../my-slides
```

スクリプトは次を行います。

- `templates/` を対象ディレクトリへコピー
- `git init`
- Nix が flake を認識できるように `flake.nix` を `git add`
- 必要に応じて最初の PDF ビルド

ビルドまで行う場合:

```bash
.opencode/skills/typst-slides/scripts/scaffold.sh ../my-slides --build
```

作成後:

```bash
cd ../my-slides
nix develop
typst compile slides.typ slides.pdf
```

## 既存デッキを編集する

1. `outline.md` を読み、スライドの枚数と流れを確認する。
2. `slides.typ` を編集する。
3. `nix develop -c typst compile slides.typ slides.pdf` を実行する。
4. エラーがあれば修正して再コンパイルする。
5. PNG を生成し、各ページのはみ出し・重なり・改行を確認する。
6. 問題があれば 2〜5 を繰り返す。
7. 最後に PDF のページ数と内容を確認する。

PNG の生成:

```bash
mkdir -p preview
nix develop -c typst compile --format png --ppi 120 slides.typ "preview/slide-{p}.png"
```

## 編集ルール

- 言語は日本語にする。
- 出力は PDF のみを前提にする。
- Touying は `#import "@preview/touying:0.8.0": *` を使う。
- テーマは `themes.simple` を維持する。
- 内容は `outline.md` を正とし、構成を変える場合は `outline.md` も更新する。
- 1 枚のスライドに詰め込みすぎない。箇条書きは 3〜5 項目までを目安にする。
- 長いコードや長い URL は分割し、文字切れを避ける。
- `#pause` は必要な場合だけ使う。PDF 上ではサブスライドごとにページが増えるため、静的な配布用 PDF では `config-common(handout: true)` を検討する。
- 画像は `assets/` に置き、相対パスで参照する。
- `flake.lock` を理由なく更新しない。

## フォント

日本語フォントは flake で `Noto Sans CJK JP` を用意しています。

```bash
nix develop -c typst fonts | grep "Noto Sans CJK JP"
```

## よくある問題

### `flake.nix` が Git に追跡されていない

初回コミット前は Nix が flake を認識できません。

```bash
git add flake.nix
```

### パッケージ取得をネットワークに依存させたくない

`flake.nix` の `typst.wrapper` で `touying`、`cetz`、`fletcher` を Nix store から読ませています。この構成を維持してください。

### 日付が 1980 年になる

Nix の `SOURCE_DATE_EPOCH` が影響しています。開発シェルで `unset SOURCE_DATE_EPOCH` しています。

## グローバルに使う

全プロジェクトでこのスキルを使う場合:

```bash
mkdir -p ~/.config/opencode/skills
cp -R .opencode/skills/typst-slides ~/.config/opencode/skills/
```

opencode を再起動すると認識されます。
