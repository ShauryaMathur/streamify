// hooks/use-products.ts
import { fetchAlbums, type AlbumTree } from '@/lib/api'
import { useQuery } from '@tanstack/react-query'

export const useProducts = (search: string) => {
  return useQuery<
    AlbumTree[],                // TQueryFnData
    Error,                      // TError
    AlbumTree[],                // TData
    ['albums', string]          // TQueryKey
  >({
    queryKey: ['albums', search],                  // TS now knows this is ['albums', string]
    queryFn: ({ queryKey }) => {
      const [, q] = queryKey
      return fetchAlbums(q)                        // q is correctly typed as string
    },
    staleTime: 5 * 60_000,        // 5m cache
    refetchOnWindowFocus: false,  // UX: don't refetch when refocusing
  })
}
