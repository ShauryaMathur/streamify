'use client'

import { fetchSalesByMonth, fetchTopTracks } from '@/lib/api'
import { useQuery } from '@tanstack/react-query'
import {
    Bar,
    BarChart,
    CartesianGrid,
    Line,
    LineChart,
    ResponsiveContainer,
    Tooltip,
    XAxis,
    YAxis
} from 'recharts'

export default function DashboardContent() {
  // useQuery now only accepts one object argument in v5
  const {
    data: monthly = [],
    isLoading: loadingM,
    isError: errorM
  } = useQuery({
    queryKey: ['salesByMonth'],
    queryFn: fetchSalesByMonth
  })

  const {
    data: topTracks = [],
    isLoading: loadingT,
    isError: errorT
  } = useQuery({
    queryKey: ['topTracks'],
    queryFn: fetchTopTracks
  })

  if (loadingM || loadingT) return <p>Loading charts…</p>
  if (errorM || errorT) return <p className="text-red-600">Failed to load data.</p>

  return (
    <div className="space-y-12">
      {/* Revenue Line Chart */}
      <div className="bg-white p-4 shadow rounded-lg">
        <h2 className="mb-2 text-lg font-medium">Revenue Over Time</h2>
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={monthly}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="month" />
            <YAxis />
            <Tooltip formatter={v => `$${v}`} />
            <Line
              type="monotone"
              dataKey="revenue"
              stroke="#6366F1"
              strokeWidth={2}
            />
          </LineChart>
        </ResponsiveContainer>
      </div>

      {/* Top Tracks Bar Chart */}
      <div className="bg-white p-4 shadow rounded-lg">
        <h2 className="mb-2 text-lg font-medium">
          Top 10 Tracks by Units Sold
        </h2>
        <ResponsiveContainer width="100%" height={300}>
  <BarChart
    data={topTracks}
    layout="vertical"
    margin={{ top: 20, right: 30, left: 150, bottom: 20 }}  // ← give extra left-hand room
  >
    <CartesianGrid strokeDasharray="3 3" />
    <XAxis type="number" />
    <YAxis
      type="category"
      dataKey="name"
      width={150}                // ← make the axis wide enough
      interval={0}               // ← render every label, no skipping
      tick={{ fontSize: 12 }}    // ← optional styling
    />
    <Tooltip />
    <Bar dataKey="units_sold" fill="#6366F1" />
  </BarChart>
</ResponsiveContainer>
      </div>
    </div>
  )
}
