#!/usr/bin/env node

import fs from 'fs';
import path from 'path';

const DIST_DIR = './dist';
const REQUIRED_FILES = [
  'index.html',
  'assets'
];

console.log('🔍 ビルド検証を開始します...');

// dist ディレクトリの存在確認
if (!fs.existsSync(DIST_DIR)) {
  console.error('❌ dist ディレクトリが存在しません');
  process.exit(1);
}

// 必要なファイルの確認
let allFilesExist = true;
REQUIRED_FILES.forEach(file => {
  const filePath = path.join(DIST_DIR, file);
  if (!fs.existsSync(filePath)) {
    console.error(`❌ 必要なファイルが見つかりません: ${file}`);
    allFilesExist = false;
  } else {
    console.log(`✅ ${file} - OK`);
  }
});

// index.html の内容確認
const indexPath = path.join(DIST_DIR, 'index.html');
if (fs.existsSync(indexPath)) {
  const indexContent = fs.readFileSync(indexPath, 'utf-8');
  
  // 必要な要素の確認
  const checks = [
    { name: 'root div', pattern: /<div id="root">/ },
    { name: 'script tag', pattern: /<script[^>]*src[^>]*>/ },
    { name: 'CSS link', pattern: /<link[^>]*stylesheet[^>]*>/ }
  ];
  
  checks.forEach(check => {
    if (check.pattern.test(indexContent)) {
      console.log(`✅ ${check.name} - OK`);
    } else {
      console.warn(`⚠️ ${check.name} - 見つかりません`);
    }
  });
}

// ファイルサイズの確認
const stats = fs.statSync(indexPath);
console.log(`📊 index.html サイズ: ${stats.size} bytes`);

if (allFilesExist) {
  console.log('✅ ビルド検証完了 - 問題なし');
} else {
  console.error('❌ ビルド検証失敗');
  process.exit(1);
}