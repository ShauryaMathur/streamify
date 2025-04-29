'use client'
import Link from 'next/link'
import { useCart } from '../store/useCart'

export default function CartBadge() {
  const count = useCart(state => state.items.length)
  return (
    <Link href="/checkout" className="relative inline-block p-2">
      🛒
      {count > 0 && (
        <span className="absolute -right-1 -top-1 rounded-full bg-red-600 px-1 text-xs text-white">
          {count}
        </span>
      )}
    </Link>
  )
}
