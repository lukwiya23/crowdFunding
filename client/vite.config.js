import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react({
     // Add this line
     include: "**/*.jsx"
  })],
  define: {
    global: "globalThis",
    "process.env": {},
  },
});