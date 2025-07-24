// 環境変数の存在確認ユーティリティ
export const validateEnvironment = () => {
  const requiredEnvVars = [
    'VITE_SUPABASE_URL',
    'VITE_SUPABASE_ANON_KEY'
  ];

  const missingVars = requiredEnvVars.filter(
    varName => !import.meta.env[varName]
  );

  if (missingVars.length > 0) {
    console.error('❌ Missing environment variables:', missingVars);
    console.error('📝 Please check your .env file or deployment settings');
    return false;
  }

  console.log('✅ All environment variables are loaded correctly');
  return true;
};

// 開発環境でのデバッグ情報表示
export const logEnvironmentInfo = () => {
  if (import.meta.env.DEV) {
    console.log('🔧 Environment Info:');
    console.log('Mode:', import.meta.env.MODE);
    console.log('Base URL:', import.meta.env.BASE_URL);
    console.log('Supabase URL:', import.meta.env.VITE_SUPABASE_URL ? '✅ Set' : '❌ Missing');
    console.log('Supabase Key:', import.meta.env.VITE_SUPABASE_ANON_KEY ? '✅ Set' : '❌ Missing');
  }
};