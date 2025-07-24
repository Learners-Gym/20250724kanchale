import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import ErrorBoundary from './components/ErrorBoundary'
import { validateEnvironment, logEnvironmentInfo } from './utils/env-check'

// 環境変数の確認
logEnvironmentInfo();
if (!validateEnvironment()) {
  console.error('Environment validation failed. App may not work correctly.');
}

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <ErrorBoundary>
      <App />
    </ErrorBoundary>
  </StrictMode>,
)