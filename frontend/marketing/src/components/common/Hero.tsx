interface HeroProps {
  title: string
  subtitle: string
  ctaText: string
  ctaLink: string
}

export default function Hero({ title, subtitle, ctaText, ctaLink }: HeroProps) {
  return (
    <div className="text-center py-16 md:py-24 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl mb-12">
      <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
        {title}
      </h1>
      <p className="text-xl text-gray-600 max-w-2xl mx-auto mb-10">
        {subtitle}
      </p>
      <a
        href={ctaLink}
        className="inline-block bg-blue-600 text-white text-lg font-semibold px-8 py-4 rounded-lg hover:bg-blue-700 transition-colors shadow-lg"
      >
        {ctaText}
      </a>
    </div>
  )
}
