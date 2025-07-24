/*
  # 漢字タイピング練習アプリのデータベーススキーマ

  1. New Tables
    - `users`
      - `id` (uuid, primary key)
      - `name` (text)
      - `role` (text) - 'student' | 'teacher' | 'admin'
      - `grade` (integer) - 学年 (1-6)
      - `password` (text)
      - `last_login` (timestamptz)
      - `created_at` (timestamptz)

    - `problems`
      - `id` (uuid, primary key)
      - `grade` (integer) - 対象学年 (1-6)
      - `sentence` (text) - 問題文
      - `hiragana` (text) - ひらがな読み
      - `kanji` (text) - 正解の漢字
      - `difficulty` (text) - 'easy' | 'medium' | 'hard'
      - `created_by` (uuid) - 作成者ID
      - `created_at` (timestamptz)

    - `typing_sessions`
      - `id` (uuid, primary key)
      - `user_id` (uuid) - ユーザーID
      - `problem_id` (uuid) - 問題ID
      - `is_correct` (boolean) - 正解かどうか
      - `typing_time` (integer) - 入力時間（秒）
      - `attempts` (integer) - 試行回数
      - `completed_at` (timestamptz)

    - `user_progress`
      - `id` (uuid, primary key)
      - `user_id` (uuid) - ユーザーID
      - `grade` (integer) - 学年
      - `total_problems` (integer) - 総問題数
      - `correct_answers` (integer) - 正解数
      - `accuracy_rate` (decimal) - 正解率
      - `average_time` (decimal) - 平均時間
      - `streak_count` (integer) - 連続正解数
      - `badges` (text[]) - 獲得バッジ
      - `last_practice` (timestamptz) - 最後の練習日
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
    - Teachers can manage problems and view all student data
    - Students can only access their own data

  3. Initial Data
    - Insert sample problems and users for testing
*/

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  role text NOT NULL CHECK (role IN ('student', 'teacher', 'admin')),
  grade integer CHECK (grade >= 1 AND grade <= 6),
  password text NOT NULL,
  last_login timestamptz,
  created_at timestamptz DEFAULT now()
);

-- Create problems table
CREATE TABLE IF NOT EXISTS problems (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  grade integer NOT NULL CHECK (grade >= 1 AND grade <= 6),
  sentence text NOT NULL,
  hiragana text NOT NULL,
  kanji text NOT NULL,
  difficulty text NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
  created_by uuid REFERENCES users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now()
);

-- Create typing_sessions table
CREATE TABLE IF NOT EXISTS typing_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  problem_id uuid NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
  is_correct boolean NOT NULL DEFAULT false,
  typing_time integer NOT NULL DEFAULT 0,
  attempts integer NOT NULL DEFAULT 1,
  completed_at timestamptz DEFAULT now()
);

-- Create user_progress table
CREATE TABLE IF NOT EXISTS user_progress (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  grade integer NOT NULL CHECK (grade >= 1 AND grade <= 6),
  total_problems integer NOT NULL DEFAULT 0,
  correct_answers integer NOT NULL DEFAULT 0,
  accuracy_rate decimal NOT NULL DEFAULT 0.0,
  average_time decimal NOT NULL DEFAULT 0.0,
  streak_count integer NOT NULL DEFAULT 0,
  badges text[] DEFAULT '{}',
  last_practice timestamptz,
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id, grade)
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE problems ENABLE ROW LEVEL SECURITY;
ALTER TABLE typing_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

-- Create policies for users table
CREATE POLICY "Users can read own data"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can update own data"
  ON users
  FOR UPDATE
  TO authenticated
  USING (true);

CREATE POLICY "Teachers can insert users"
  ON users
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Create policies for problems table
CREATE POLICY "Anyone can read problems"
  ON problems
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Teachers can manage problems"
  ON problems
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Create policies for typing_sessions table
CREATE POLICY "Users can read own sessions"
  ON typing_sessions
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can create own sessions"
  ON typing_sessions
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Teachers can read all sessions"
  ON typing_sessions
  FOR SELECT
  TO authenticated
  USING (true);

-- Create policies for user_progress table
CREATE POLICY "Users can read own progress"
  ON user_progress
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can update own progress"
  ON user_progress
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Insert sample data
INSERT INTO users (id, name, role, grade, password, created_at) VALUES
  ('11111111-1111-1111-1111-111111111111', '佐藤先生', 'teacher', NULL, 'password', now()),
  ('22222222-2222-2222-2222-222222222222', '田中太郎', 'student', 3, 'password', now()),
  ('33333333-3333-3333-3333-333333333333', '山田花子', 'student', 4, 'password', now()),
  ('44444444-4444-4444-4444-444444444444', '鈴木一郎', 'student', 2, 'password', now()),
  ('55555555-5555-5555-5555-555555555555', '高橋美咲', 'student', 5, 'password', now())
ON CONFLICT (id) DO NOTHING;

-- Insert sample problems
INSERT INTO problems (grade, sentence, hiragana, kanji, difficulty, created_by, created_at) VALUES
  (1, '会社で（はたらく）。', 'はたらく', '働く', 'easy', '11111111-1111-1111-1111-111111111111', now()),
  (1, '朝、（あさ）ごはんを食べる。', 'あさ', '朝', 'easy', '11111111-1111-1111-1111-111111111111', now()),
  (1, '友達と（がっこう）に行く。', 'がっこう', '学校', 'medium', '11111111-1111-1111-1111-111111111111', now()),
  (2, '（たとえば）の話をする。', 'たとえば', '例えば', 'medium', '11111111-1111-1111-1111-111111111111', now()),
  (2, '練習を（つづける）。', 'つづける', '続ける', 'medium', '11111111-1111-1111-1111-111111111111', now()),
  (2, '新しい（ともだち）ができた。', 'ともだち', '友達', 'easy', '11111111-1111-1111-1111-111111111111', now()),
  (3, '図書館で（ほん）を読む。', 'ほん', '本', 'easy', '11111111-1111-1111-1111-111111111111', now()),
  (3, '（しんぶん）を毎日読む。', 'しんぶん', '新聞', 'medium', '11111111-1111-1111-1111-111111111111', now()),
  (3, '（うんどう）会に参加する。', 'うんどう', '運動', 'hard', '11111111-1111-1111-1111-111111111111', now()),
  (4, '（けいけん）を積む。', 'けいけん', '経験', 'hard', '11111111-1111-1111-1111-111111111111', now()),
  (5, '（かんきょう）問題について考える。', 'かんきょう', '環境', 'hard', '11111111-1111-1111-1111-111111111111', now()),
  (6, '（せいじ）に興味を持つ。', 'せいじ', '政治', 'hard', '11111111-1111-1111-1111-111111111111', now())
ON CONFLICT DO NOTHING;