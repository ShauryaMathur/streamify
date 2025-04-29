// app/page.tsx

import AlbumCard from '@/components/AlbumCard'
import SearchBox from '@/components/SearchBox'
import { fetchAlbums } from '@/lib/api'
import { notFound } from 'next/navigation'

export default async function Home({
  searchParams,
}: {
  // In Next.js 15, searchParams is passed in as a Promise
  searchParams: Promise<Record<string, string>>
}) {
  // Await the Promise before accessing its properties
  const params = await searchParams
  const q = params.q?.trim() ?? ''

  // Fetch filtered albums
  const albums = await fetchAlbums(q)
  if (!albums) notFound()

  return (
    <main className="mx-auto max-w-6xl p-6">
      {/* Server-side search form */}
      <SearchBox defaultValue={q} />

      {/* Results grid */}
      {albums.length === 0 ? (
        <p className="text-center text-gray-500">
          No matches for “{q}”
        </p>
      ) : (
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {albums.map((album) => (
            <AlbumCard key={album.album_id} album={album} />
          ))}
        </div>
      )}
    </main>
  )
}