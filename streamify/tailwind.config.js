module.exports = {
  content: ['./app/**/*.{ts,tsx}', './components/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        brand: {
          DEFAULT: '#6366F1', // indigo-500
          fg: '#ffffff'
        }
      },
      boxShadow: {
        card: '0 2px 6px rgba(0,0,0,0.06)'
      }
    }
  },
  plugins: [require('tailwindcss-animate')]
}
