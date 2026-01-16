const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3002;

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    service: 'Glixtron API',
    timestamp: new Date().toISOString()
  });
});

app.get('/api', (req, res) => {
  res.json({ 
    message: 'Welcome to Glixtron API',
    endpoints: [
      { path: '/api/health', method: 'GET', description: 'Health check' },
      { path: '/api', method: 'GET', description: 'API information' }
    ]
  });
});

app.listen(PORT, () => {
  console.log('✅ Glixtron API running on http://localhost:' + PORT);
});
