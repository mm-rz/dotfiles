# dotfiles

新しい環境では、リポジトリを clone した直後に POSIX `sh` のインストーラーを実行する。

```sh
./install.sh --dry-run --profile server
./install.sh --profile server
```

インストール単位には依存関係があり、必要なものは自動的に先に実行される。たとえば
`cli` は `rust`、`build`、`base` をこの順序関係で先に導入する。処理済みのコマンドや正しいリンクは可能な限り
スキップされ、既存のリンク先は `.bak`（既にあれば日時付き）へ退避される。

## 環境プロファイル

- `minimal`: 基本パッケージ、zsh と最小限のリンク
- `server`: CLI ツール、Neovim とその設定を追加（デフォルト）
- `developer`: 開発用パッケージを追加
- `desktop`: フォント、Wayland デスクトップとその設定を追加

環境変数でも選べるため、ホスト固有の起動スクリプトなどから設定できる。

```sh
DOTFILES_PROFILE=desktop DOTFILES_SKIP=fonts ./install.sh
./install.sh --only cli,links-core
./install.sh --list
```

現在、OS パッケージの導入は `apt-get` 環境を対象としている。インストーラー自身が必要と
するものは OS 標準の POSIX `sh` と、このリポジトリの取得に使う `git` だけである。
