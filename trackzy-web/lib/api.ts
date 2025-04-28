import { supabase } from './supabase';

export interface AlbumTree {
    album_id:   number
    album:      string
    artist:     string
    tracks: {
      track_id: number
      name:     string
      seconds:  number
      price:    number
    }[]
  }
  

export async function fetchAlbums(search: string) {
    // empty string ⇒ no filter
    const base = supabase.from('v_album_tree').select('*').order('artist')
  
    const { data, error } =
      search.trim() === ''
        ? await base
        : await base.or(
            `album.ilike.%${search}%,artist.ilike.%${search}%`
          ) // ↙ case-insensitive
  
    if (error) throw error
    return data
  }

  export async function checkout(items: number[]) {
    // p_items is an array of {track_id,qty}
    const payload = items.map((id) => ({ track_id: id, qty: 1 }))
    // return the full response object
    return supabase.rpc('f_checkout', {
      p_customer: 1,
      p_items: payload,
    })
  }

  export type MonthlySale = { month: string; revenue: number }
export type TopTrack    = { track_id: number; name: string; units_sold: number }

export async function fetchSalesByMonth(): Promise<MonthlySale[]> {
  const { data, error } = await supabase.rpc('f_sales_by_month')
  if (error) throw error
  return data!
}

export async function fetchTopTracks(): Promise<TopTrack[]> {
  const { data, error } = await supabase.rpc('f_top_tracks_sales')
  if (error) throw error
  return data!
}
