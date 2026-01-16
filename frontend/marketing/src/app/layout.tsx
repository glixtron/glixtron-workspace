export const metadata = {
  title: 'Glixtron - Modern Solutions',
  description: 'Next-generation technology solutions',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body style={{ margin: 0, fontFamily: 'Arial, sans-serif', minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
        <header style={{ padding: '1rem 2rem', background: '#0070f3', color: 'white', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <h1 style={{ margin: 0 }}>Glixtron</h1>
          <nav>
            <a href="/" style={{ color: 'white', marginLeft: '1rem', textDecoration: 'none' }}>Home</a>
            <a href="/products" style={{ color: 'white', marginLeft: '1rem', textDecoration: 'none' }}>Products</a>
            <a href="/about" style={{ color: 'white', marginLeft: '1rem', textDecoration: 'none' }}>About</a>
          </nav>
        </header>
        
        <main style={{ flex: 1, padding: '2rem' }}>
          {children}
        </main>
        
        <footer style={{ padding: '1rem', background: '#f0f0f0', textAlign: 'center' }}>
          <p style={{ margin: 0 }}>© 2024 Glixtron. All rights reserved.</p>
          <p style={{ margin: '0.5rem 0 0 0', fontSize: '0.9rem', color: '#666' }}>
            Backend API: <a href="http://localhost:3002/api/health" target="_blank">http://localhost:3002/api/health</a>
          </p>
        </footer>
      </body>
    </html>
  )
}
