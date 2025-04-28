// components/Navbar.tsx
'use client'

import Link from 'next/link'
import CartBadge from './CartBadge'

export default function Navbar() {
  return (
    <header className="sticky top-0 z-30 flex h-14 items-center justify-between bg-white/70 px-6 shadow">
      
      {/* Brand on the left */}
      <Link href="/" className="text-xl font-extrabold text-indigo-600">
        Streamify
      </Link>

      {/* Center (optional search could go here) */}
      <div />

      {/* Actions on the right */}
      <div className="flex items-center space-x-4">
        <Link
          href="/dashboard"
          className="text-sm font-medium text-gray-600 hover:text-indigo-600"
        >
          Dashboard
        </Link>
        <CartBadge />
      </div>
    </header>
  )
}