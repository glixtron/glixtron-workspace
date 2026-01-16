"use client";

export default function ProductsPage() {
  const products = [
    { id: 1, name: 'Enterprise Suite', price: 'Custom', description: 'Complete business solution' },
    { id: 2, name: 'Cloud Platform', price: '$499/month', description: 'Scalable cloud infrastructure' },
    { id: 3, name: 'AI Analytics', price: '$299/month', description: 'Intelligent data analysis' },
  ];

  return (
    <div className="container">
      <h1>Our Products</h1>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '1rem' }}>
        {products.map((product) => (
          <div key={product.id} style={{ border: '1px solid #ddd', borderRadius: '8px', padding: '1rem' }}>
            <h3 style={{ marginTop: 0 }}>{product.name}</h3>
            <p>{product.description}</p>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <strong>{product.price}</strong>
              <button 
                onClick={() => alert(`Selected: ${product.name}`)}
                style={{ padding: '0.5rem 1rem', background: '#0070f3', color: 'white', border: 'none', borderRadius: '4px' }}
              >
                Learn More
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
