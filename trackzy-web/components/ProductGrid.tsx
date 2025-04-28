// components/ProductGrid.tsx (Client Component)
'use client'
import AlbumCard from '@/components/AlbumCard'
import { useProducts } from '@/hooks/use-products'
import { useSearchParams } from 'next/navigation'

export default function ProductGrid() {
  const params = useSearchParams()
  const q = params.get('q') ?? ''
  const { data: albums = [], isLoading } = useProducts(q)

  if (isLoading) return <p>Loading…</p>

  return (
    <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
      {albums.map((a) => (
        <AlbumCard key={a.album_id} album={a} />
      ))}
    </div>
  )
}