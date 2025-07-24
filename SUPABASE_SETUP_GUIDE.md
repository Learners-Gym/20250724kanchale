# 🚀 新しいSupabaseプロジェクト設定ガイド

## 📋 手順1: Supabaseプロジェクト作成

1. **Supabase Dashboardにアクセス**
   - https://supabase.com/dashboard にアクセス
   - GoogleアカウントまたはGitHubでログイン

2. **新しいプロジェクトを作成**
   - "New Project" ボタンをクリック
   - Organization を選択（個人の場合は自分のアカウント）
   - プロジェクト情報を入力：
     ```
     Name: kanji-typing-practice
     Database Password: [安全なパスワードを設定]
     Region: Northeast Asia (Tokyo) [日本の場合]
     Pricing Plan: Free tier
     ```
   - "Create new project" をクリック

3. **プロジェクトの初期化を待つ**
   - 約2-3分でプロジェクトが作成されます

## 📋 手順2: データベーススキーマの設定

1. **SQL Editorにアクセス**
   - 左サイドバーの "SQL Editor" をクリック

2. **初期スキーマを実行**
   - `supabase/migrations/20250106000000_initial_setup.sql` ファイルの内容をコピー
   - SQL Editorに貼り付け
   - "Run" ボタンをクリックして実行

3. **実行結果を確認**
   - 成功メッセージ "=== Supabase Initial Setup Completed Successfully ===" が表示されることを確認

## 📋 手順3: 環境変数の設定

1. **API設定を取得**
   - 左サイドバーの "Settings" → "API" をクリック
   - 以下の情報をコピー：
     - Project URL
     - anon public key

2. **環境変数ファイルを作成**
   - プロジェクトルートで `.env.example` を `.env` にコピー
   - 取得した情報を以下のように設定：
   ```bash
   VITE_SUPABASE_URL=https://your-project-id.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-key-here
   ```

## 📋 手順4: 動作確認

1. **テーブル作成の確認**
   - Table Editor で以下のテーブルが作成されていることを確認：
     - `students` (学生管理)
     - `problems` (問題管理)
     - `review_problems` (復習問題)
     - `typing_sessions` (練習履歴)
     - `user_progress` (学習進捗)
     - `practice_settings` (練習設定)

2. **サンプルデータの確認**
   - `students` テーブルに8名の学生データ
   - `problems` テーブルに15問の問題データ
   - デフォルトの練習設定データ

## 📋 手順5: アプリケーションテスト

1. **開発サーバーを起動**
   ```bash
   npm run dev
   ```

2. **ログインテスト**
   - 以下のアカウントでログインできることを確認：
     - 先生: `admin`
     - 小1生: `1A-01`
     - 小2生: `2B-02`
     - 体験生: `Taiken01`

3. **機能テスト**
   - 学生ダッシュボード表示
   - 問題練習機能
   - 復習マーク機能
   - 教師ダッシュボード表示

## 🔧 作成済み機能

### ✅ 学生管理システム
- パスコードによるログイン
- 学習進捗追跡
- 出席率・スコア管理

### ✅ 問題管理システム
- 学年別問題分類
- 難易度設定
- Excel インポート/エクスポート

### ✅ 復習システム
- 復習マーク機能
- 復習問題の優先出題
- 問題フィルタリング

### ✅ 分析機能
- 学生統計ビュー
- 学習データ分析
- 進捗レポート

## 🚨 トラブルシューティング

### データベース接続エラー
- `.env` ファイルの URL と Key が正しいか確認
- Supabase プロジェクトが正常に起動しているか確認

### RLS (Row Level Security) エラー
- 現在の設定では全テーブルに permissive policy を適用済み
- カスタム認証システムに対応した設定

### マイグレーションエラー
- SQL Editor で手動実行する場合は、コード全体を一度に実行
- エラーが発生した場合は、テーブルを削除してから再実行

## 📞 サポート

設定で問題が発生した場合は、以下の情報をお知らせください：
1. Supabase プロジェクトID
2. エラーメッセージ
3. 実行しようとした操作

これで新しいSupabaseプロジェクトの設定は完了です！🎉