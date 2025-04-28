// app/dashboard/page.tsx
'use client'

import DashboardContent from '@/components/DashboardContent'

export default function DashboardPage() {
  return (
    <div className="mx-auto max-w-6xl p-6 space-y-8">
      <h1 className="text-2xl font-semibold">📊 Sales Dashboard</h1>
      <DashboardContent />
    </div>
  )
}
