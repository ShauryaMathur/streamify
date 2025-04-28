'use client'
import { create } from 'zustand'

export interface CartItem {
  track_id: number
  name: string
  price: number
}

interface CartState {
  items: CartItem[]
  add(item: CartItem): void
  remove(id: number): void
  clear(): void
}

export const useCart = create<CartState>(set => ({
  items: [],
  add: i => set(s => ({ items: [...s.items, i] })),
  remove: id => set(s => ({ items: s.items.filter(x => x.track_id !== id) })),
  clear: () => set({ items: [] })
}))
