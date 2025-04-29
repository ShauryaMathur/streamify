'use client'
import TrackRow from '@/components/TrackRow'
import { ChevronDown } from 'lucide-react'
import { useState } from 'react'

export default function AlbumCard({ album }: { album: any }) {
  const [open, setOpen] = useState(false)

  return (
    <div
      onClick={() => setOpen(o => !o)}
      className="group cursor-pointer rounded-2xl bg-white p-4 shadow-card transition
                 hover:-translate-y-1 hover:shadow-lg"
    >
      <div className="flex items-start justify-between gap-1">
        <div>
          <h3 className="font-semibold">{album.album}</h3>
          <p className="text-sm text-gray-500">{album.artist}</p>
        </div>
        <ChevronDown
          size={18}
          className={`mt-1 shrink-0 transition-transform group-hover:text-brand ${
            open ? 'rotate-180 text-brand' : ''
          }`}
        />
      </div>

      {open && (
        <ul className="mt-3 space-y-1">
          {album.tracks.map((t: any) => (
            <TrackRow key={t.track_id} track={t} />
          ))}
        </ul>
      )}
    </div>
  )
}
