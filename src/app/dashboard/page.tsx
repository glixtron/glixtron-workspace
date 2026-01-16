import Link from 'next/link'
"use client";

import { useState, useEffect } from 'react';

export default function DashboardPage() {
  const [backendHealth, setBackendHealth] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    checkBackendHealth();
    const interval = setInterval(checkBackendHealth, 10000); // Check every 10 seconds
    return () => clearInterval(interval);
  }, []);

  const checkBackendHealth = async () => {
    try {
      const response = await fetch('http://localhost:3002/api/health');
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const data = await response.json();
      setBackendHealth(data);
      setError(null);
    } catch (err: any) {
      setError(err.message);
      setBackendHealth(null);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="container">
      <h1>Glixtron Dashboard</h1>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '1rem', marginTop: '2rem' }}>
        {/* Backend Status Card */}
        <div style={{ border: '1px solid #ddd', borderRadius: '8px', padding: '1.5rem' }}>
          <h3 style={{ marginTop: 0 }}>Backend API Status</h3>
          
          {loading ? (
            <p>Checking...</p>
          ) : error ? (
            <div style={{ color: 'red' }}>
              <p>❌ Connection Error</p>
              <p>{error}</p>
            </div>
          ) : backendHealth ? (
            <div style={{ color: 'green' }}>
              <p>✅ Healthy</p>
              <div style={{ marginTop: '1rem', background: '#f0f8ff', padding: '1rem', borderRadius: '4px' }}>
                <pre style={{ margin: 0, fontSize: '0.9rem' }}>
                  {JSON.stringify(backendHealth, null, 2)}
                </pre>
              </div>
            </div>
          ) : null}
          
          <button 
            onClick={checkBackendHealth}
            style={{ marginTop: '1rem', padding: '0.5rem 1rem', background: '#0070f3', color: 'white', border: 'none', borderRadius: '4px' }}
          >
            Refresh
          </button>
        </div>

        {/* Quick Actions Card */}
        <div style={{ border: '1px solid #ddd', borderRadius: '8px', padding: '1.5rem' }}>
          <h3 style={{ marginTop: 0 }}>Quick Actions</h3>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
            <a href="/" style={{ padding: '0.5rem', background: '#f0f0f0', borderRadius: '4px', textAlign: 'center' }}>🏠 Home</a>
            <a href="/products" style={{ padding: '0.5rem', background: '#f0f0f0', borderRadius: '4px', textAlign: 'center' }}>📦 Products</a>
            <a href="/about" style={{ padding: '0.5rem', background: '#f0f0f0', borderRadius: '4px', textAlign: 'center' }}>ℹ️ About</a>
          </div>
        </div>
      </div>
    </div>
  )
}
