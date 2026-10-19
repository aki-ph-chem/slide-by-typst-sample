# slide_by_typst

Typst と Touying で日本語スライドを作り、PDF を出力するリポジトリです。

## 必要なもの

- Nix（flakes を有効化済みであること）
- Git

Typst やフォントは `flake.nix` で固定されているため、個別のインストールは不要です。

## セットアップ

```bash
git add flake.nix
nix develop
```

初回コミット前は、Nix が `flake.nix` を認識できるように `git add` が必要です。

## ビルド

```bash
# PDF を生成
typst compile slides.typ slides.pdf

# ファイル変更を監視して自動ビルド
typst watch slides.typ slides.pdf
```

出力先は `slides.pdf` です。

## プレビュー

目視確認用に PNG を生成できます。

```bash
mkdir -p preview
typst compile --format png --ppi 120 slides.typ "preview/slide-{p}.png"
```

PDF を直接確認する場合は、任意の PDF ビューアを使用してください。発表用には `pdfpc` も利用できます。

```bash
pdfpc slides.pdf
```

## ファイル構成

```text
.
├── flake.nix       # 開発環境
├── flake.lock      # バージョン固定
├── slides.typ      # スライド本体
├── outline.md      # 内容と構成
├── AGENTS.md       # LLM 向けの作業ルール
├── README.md       # 利用手順
├── .opencode/
│   └── skills/typst-slides/  # 他プロジェクトでも使えるスキル
├── assets/         # 画像などの素材（必要時に作成）
├── preview/        # 確認用 PNG（Git 管理外）
└── slides.pdf      # ビルド成果物（Git 管理外）
```

## スライドの編集

- 内容は `outline.md` を正とし、構成を変えた場合は `outline.md` も更新します。
- テーマは `themes.simple` です。
- 言語は日本語、出力は PDF のみを前提としています。
- 画像を追加する場合は `assets/` に置き、`slides.typ` から相対パスで参照します。
- `#pause` を使うと PDF 上ではサブスライドごとにページが増えます。静的な配布用 PDF にする場合は `config-common(handout: true)` を検討してください。

## バージョン

- Typst 0.15.1
- Touying 0.8.0

バージョンは `flake.lock` で固定されています。更新する場合は `flake.nix` と `slides.typ` の API 互換性を確認してください。

## LLM に編集を任せる場合

`AGENTS.md` にビルド手順とルールをまとめています。LLM には次の流れで作業させると安定します。

1. `outline.md` を読む
2. `slides.typ` を編集する
3. `nix develop -c typst compile slides.typ slides.pdf` を実行する
4. PNG を生成して、はみ出しや改行を確認する
5. 問題があれば修正して再ビルドする

## スキルとして再利用する

このリポジトリのレシピは `.opencode/skills/typst-slides/` にスキルとしてまとめています。

- `SKILL.md`: 作業手順とルール
- `templates/`: 新しいデッキ用のファイル一式
- `scripts/scaffold.sh`: テンプレートを別ディレクトリへ展開するスクリプト

新しいデッキを作る場合:

```bash
.opencode/skills/typst-slides/scripts/scaffold.sh ../my-slides
```

ビルドまで行う場合:

```bash
.opencode/skills/typst-slides/scripts/scaffold.sh ../my-slides --build
```

全プロジェクトで使う場合は、スキルをグローバル配置へコピーします。

```bash
mkdir -p ~/.config/opencode/skills
cp -R .opencode/skills/typst-slides ~/.config/opencode/skills/
```

コピー後は opencode を再起動してください。
