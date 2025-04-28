// components/SearchBox.tsx — SERVER component

export default function SearchBox({ defaultValue = '' }: { defaultValue?: string }) {
  return (
    <form method="get" className="mb-6 flex justify-center">
      <input
        name="q"
        defaultValue={defaultValue}
        type="search"
        placeholder="Search album or artist…"
        className="w-full max-w-md rounded-full border py-2 px-4"
      />
      <button
        type="submit"
        className="ml-2 rounded-full bg-indigo-600 px-4 py-1 text-white"
      >
        Search
      </button>
    </form>
  )
}