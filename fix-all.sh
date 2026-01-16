#!/bin/bash

echo "=== Fixing All Issues ==="

# 1. Kill all running services
echo "1. Stopping all services..."
pkill -f "next" 2>/dev/null || true
pkill -f "node.*index" 2>/dev/null || true
pkill -f "node.*server" 2>/dev/null || true
sleep 2

# 2. Fix frontend Next.js version
echo "2. Fixing frontend Next.js version..."
cd frontend/marketing
if [ -f "package.json" ]; then
    # Ensure Next.js 14
    npm uninstall next 2>/dev/null || true
    npm install next@14.1.0 --save-exact --no-audit
    npm install react@18.2.0 react-dom@18.2.0 --save-exact --no-audit
fi

# 3. Fix backend port
echo "3. Setting up backend..."
cd ../../backend/api
# Change port to 3002 in JavaScript file
cat > server.js << 'JS'
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

app.listen(PORT, () => {
  console.log(\`✅ Glixtron API running on http://localhost:\${PORT}\`);
});
JS

# Create simple package.json
cat > package.json << 'PKG'
{
  "name": "glixtron-api",
  "version": "1.0.0",
  "scripts": {
    "dev": "node server.js"
  }
}
PKG

cd ../..

echo ""
echo "✅ Fixes applied!"
echo ""
echo "To start:"
echo "  Terminal 1: cd frontend/marketing && ./node_modules/.bin/next dev"
echo "  Terminal 2: cd backend/api && node server.js"
echo ""
echo "Or use: ./start-safe.sh"
