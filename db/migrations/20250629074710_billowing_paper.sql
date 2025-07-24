/*
  # Add practice settings table

  1. New Table
    - `practice_settings`
      - `id` (uuid, primary key)
      - `problem_display_time` (integer) - 1問あたりの表示時間（秒）
      - `total_session_time` (integer) - 1セットあたりの時間（秒）
      - `created_by` (uuid) - 設定作成者ID
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on practice_settings table
    - Add policies for authenticated users

  3. Initial Data
    - Insert default settings
*/

-- Create practice_settings table
CREATE TABLE IF NOT EXISTS practice_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  problem_display_time integer NOT NULL DEFAULT 8,
  total_session_time integer NOT NULL DEFAULT 100,
  created_by uuid REFERENCES users(id) ON DELETE CASCADE,
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE practice_settings ENABLE ROW LEVEL SECURITY;

-- Create policies for practice_settings table
CREATE POLICY "Anyone can read practice settings"
  ON practice_settings
  FOR SELECT
  USING (true);

CREATE POLICY "Teachers can manage practice settings"
  ON practice_settings
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Insert default settings
INSERT INTO practice_settings (problem_display_time, total_session_time, created_by, updated_at) VALUES
  (8, 100, '11111111-1111-1111-1111-111111111111', now())
ON CONFLICT DO NOTHING;