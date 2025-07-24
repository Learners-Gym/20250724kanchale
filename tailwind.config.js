/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        'coral': {
          50: '#fef7f7',
          100: '#fdf1f1',
          200: '#fbe6e6',
          300: '#f7d0d0',
          400: '#f1a6a6',
          500: '#ff6b6b',
          600: '#e64545',
          700: '#cc3333',
          800: '#b32626',
          900: '#991f1f',
        },
      }
    },
  },
  plugins: [],
};
