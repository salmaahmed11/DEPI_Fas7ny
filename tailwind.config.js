export default {
  content: ['./index.html', './src/**/*.{vue,js}'],
  theme: {
    extend: {
      fontFamily: {
        cairo: ['Cairo', 'sans-serif'],
      },
      colors: {
        primary: '#C9A84C',
        secondary: '#1A3C5E',
        tertiary: '#C94B4B',
        neutral: '#FAFAF8',
      }
    }
  },
  plugins: [],
}