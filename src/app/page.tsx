"use client";  // This makes it a Client Component

import { useState } from 'react';

export default function Home() {
  const [message, setMessage] = useState('Click the button!');

  const handleClick = () => {
    setMessage('Glixtron is working! 🎉');
    setTimeout(() => setMessage('Click again!'), 2000);
  };

  return (
    <div style={{ padding: '2rem' }}>
      <h1>Welcome to Glixtron</h1>
      <p>Your workspace is running perfectly! 🚀</p>
      
      <div style={{ marginTop: '2rem' }}>
        <h2>Services Status:</h2>
        <ul>
          <li>✅ Frontend: http://localhost:3000</li>
          <li>✅ Backend API: http://localhost:3002/api/health</li>
        </ul>
      </div>
      
      <div style={{ marginTop: '2rem', padding: '1rem', background: '#f0f8ff', borderRadius: '8px' }}>
        <h3>Test Interactivity:</h3>
        <p>{message}</p>
        <button 
          onClick={handleClick}
          style={{ 
            marginTop: '1rem', 
            padding: '0.5rem 1rem', 
            background: '#0070f3', 
            color: 'white', 
            border: 'none', 
            borderRadius: '4px',
            cursor: 'pointer'
          }}
        >
          Test Button
        </button>
      </div>
      
      <div style={{ marginTop: '2rem' }}>
        <h3>Next Steps:</h3>
        <ol>
          <li>Create pages in <code>src/app/</code></li>
          <li>Add components in <code>src/components/</code></li>
          <li>Style with Tailwind CSS</li>
        </ol>
      </div>
    </div>
  )
}
