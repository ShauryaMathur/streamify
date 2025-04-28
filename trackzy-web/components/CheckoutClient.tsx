// components/CheckoutClient.tsx
'use client'

import { checkout } from '@/lib/api'
import { useCart } from '@/store/useCart'
import { useRouter } from 'next/navigation'

export default function CheckoutClient() {
  const cart   = useCart()
  const clear  = useCart(s => s.clear)
  const router = useRouter()

  const total = cart.items.reduce((sum, i) => sum + i.price, 0).toFixed(2)

  async function handlePay() {
    if (cart.items.length === 0) return
    try {
      const { error } = await checkout(cart.items.map(i => i.track_id))
      if (error) throw error
      clear()
      router.push('/success')
    } catch (err: any) {
      alert('Payment failed: ' + err.message)
    }
  }

  return (
    <main className="mx-auto max-w-md space-y-6 p-6 bg-white rounded-lg shadow">
      <h1 className="text-2xl font-semibold">Your Cart</h1>

      {cart.items.length === 0 ? (
        <p className="text-gray-500">Your cart is empty.</p>
      ) : (
        <>
          <ul className="space-y-2">
            {cart.items.map(item => (
              <li
                key={item.track_id}
                className="flex justify-between border-b pb-2 last:border-b-0"
              >
                <span>{item.name}</span>
                <span>${item.price.toFixed(2)}</span>
              </li>
            ))}
          </ul>

          <div className="flex justify-between text-lg font-medium">
            <span>Total</span>
            <span>${total}</span>
          </div>

          <button
            onClick={handlePay}
            disabled={cart.items.length === 0}
            className="w-full rounded bg-indigo-600 py-2 text-white disabled:opacity-50"
          >
            Pay
          </button>
        </>
      )}
    </main>
  )
}