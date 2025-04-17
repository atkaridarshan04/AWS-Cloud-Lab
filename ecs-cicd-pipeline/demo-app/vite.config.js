import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: true, // allow all IPs
    port: 5173,
    allowedHosts: 'all'
  }
})
