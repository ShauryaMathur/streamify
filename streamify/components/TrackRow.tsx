// components/TrackRow.tsx
'use client'

import { CartItem, useCart } from '@/store/useCart'

export default function TrackRow({ track }: { track: any }) {
  const add    = useCart(state => state.add)
  const remove = useCart(state => state.remove)
  const count  = useCart(state =>
    state.items.filter(item => item.track_id === track.track_id).length
  )

  // stopPropagation so clicking the buttons won’t collapse the AlbumCard
  const stop = (e: React.MouseEvent) => e.stopPropagation()

  return (
    <li className="flex items-center justify-between rounded px-2 py-1 hover:bg-gray-50">
      <span>{track.name}</span>

      {count > 0 ? (
        <div className="flex items-center space-x-1">
          <button
            onClick={e => { stop(e); remove(track.track_id) }}
            className="w-6 rounded bg-gray-200 text-center text-sm hover:bg-gray-300"
          >
            −
          </button>
          <span className="w-5 text-center text-sm">{count}</span>
          <button
            onClick={e => {
              stop(e)
              add({
                track_id: track.track_id,
                name:     track.name,
                price:    track.price,
              } as CartItem)
            }}
            className="w-6 rounded bg-gray-200 text-center text-sm hover:bg-gray-300"
          >
            +
          </button>
        </div>
      ) : (
        <button
          onClick={e => {
            stop(e)
            add({
              track_id: track.track_id,
              name:     track.name,
              price:    track.price,
            } as CartItem)
          }}
          className="rounded-full bg-indigo-600 px-3 py-0.5 text-xs font-medium text-white
                     hover:bg-indigo-700 active:scale-95 transition"
        >
          Add + 
        </button>
      )}
    </li>
  )
}
