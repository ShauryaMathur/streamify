// app/layout.tsx (SERVER)
import Navbar from '@/components/Navbar'
import Providers from '@/components/Providers'
import '@/styles/global.css'
import { ReactNode } from 'react'

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body className="flex min-h-screen flex-col bg-indigo-50">
        <Providers>
          <Navbar />
          <main className="flex-1">{children}</main>
        </Providers>
      </body>
    </html>
  )
}