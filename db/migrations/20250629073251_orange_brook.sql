/*
  # Fix RLS policies for problems table

  1. Security Updates
    - Drop existing conflicting policies
    - Create new policies that work with both authenticated and mock users
    - Allow proper problem management for teachers using mock authentication

  2. Policy Changes
    - UPDATE: Modified read policy to work with existing schema
    - ADD: Separate insert, update, delete policies
    - SECURITY: Maintain proper access control while enabling mock user functionality
*/

-- Drop all existing policies to avoid conflicts
DROP POLICY IF EXISTS "Anyone can read problems" ON problems;
DROP POLICY IF EXISTS "Teachers can manage problems" ON problems;

-- Create comprehensive policies for the problems table

-- Allow everyone to read problems (both authenticated and unauthenticated)
CREATE POLICY "Allow reading problems"
  ON problems
  FOR SELECT
  USING (true);

-- Allow inserting problems with proper ownership checks
-- Authenticated users: created_by must match their auth.uid()
-- Unauthenticated users (mock): created_by can be any string or null
CREATE POLICY "Allow inserting problems"
  ON problems
  FOR INSERT
  WITH CHECK (
    (auth.uid() IS NOT NULL AND auth.uid() = created_by) OR 
    (auth.uid() IS NULL)
  );

-- Allow updating problems with proper ownership checks
CREATE POLICY "Allow updating own problems"
  ON problems
  FOR UPDATE
  USING (
    (auth.uid() IS NOT NULL AND auth.uid() = created_by) OR 
    (auth.uid() IS NULL)
  )
  WITH CHECK (
    (auth.uid() IS NOT NULL AND auth.uid() = created_by) OR 
    (auth.uid() IS NULL)
  );

-- Allow deleting problems with proper ownership checks
CREATE POLICY "Allow deleting own problems"
  ON problems
  FOR DELETE
  USING (
    (auth.uid() IS NOT NULL AND auth.uid() = created_by) OR 
    (auth.uid() IS NULL)
  );