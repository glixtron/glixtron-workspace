import express from 'express';
import cors from 'cors';

const app = express();
const PORT = 3002;  // Changed from 3001 to 3002

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    service: 'Glixtron API',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
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
  console.log(`✅ Glixtron API running on http://localhost:${PORT}`);
});
