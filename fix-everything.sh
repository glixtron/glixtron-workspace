#!/bin/bash

echo "=== FIXING GLIXTRON WORKSPACE ==="
echo ""

# Kill any stuck processes
echo "1. Stopping any running processes..."
killall node 2>/dev/null
echo "✅ Processes stopped"

echo ""
echo "2. Checking structure..."
if [ ! -d "frontend/marketing" ]; then
    echo "❌ frontend/marketing not found!"
    exit 1
fi

if [ ! -d "backend/api" ]; then
    echo "❌ backend/api not found!"
    exit 1
fi

echo "✅ Structure OK"

echo ""
echo "3. Cleaning up failed npm installs..."
rm -rf frontend/marketing/node_modules backend/api/node_modules
rm -f frontend/marketing/package-lock.json backend/api/package-lock.json

echo ""
echo "4. Creating PROPER package.json files..."

# Frontend package.json
cat > frontend/marketing/package.json << 'FRONTEND_PKG'
{
  "name": "glixtron-marketing",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.0.4",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "tailwindcss": "3.3.0"
  },
  "devDependencies": {
    "@types/node": "20.10.0",
    "@types/react": "18.2.45",
    "@types/react-dom": "18.2.18",
    "autoprefixer": "10.4.14",
    "eslint": "8.55.0",
    "eslint-config-next": "14.0.4",
    "postcss": "8.4.31",
    "typescript": "5.3.0"
  }
}
FRONTEND_PKG

# Backend package.json (SIMPLIFIED - less dependencies)
cat > backend/api/package.json << 'BACKEND_PKG'
{
  "name": "glixtron-api",
  "version": "1.0.0",
  "main": "src/index.ts",
  "scripts": {
    "dev": "ts-node src/index.ts",
    "start": "node dist/index.js"
  },
  "dependencies": {
    "express": "4.18.2",
    "cors": "2.8.5"
  },
  "devDependencies": {
    "@types/express": "4.17.21",
    "@types/cors": "2.8.17",
    "@types/node": "20.10.0",
    "ts-node": "10.9.2",
    "typescript": "5.3.0"
  }
}
BACKEND_PKG

echo "✅ Package.json files created"

echo ""
echo "5. Creating basic backend files..."
cat > backend/api/src/index.ts << 'BACKEND_INDEX'
import express from 'express';
import cors from 'cors';

const app = express();
const PORT = 3001;

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
    endpoints: ['/api/health', '/api']
  });
});

app.listen(PORT, () => {
  console.log(`✅ Glixtron API running on http://localhost:${PORT}`);
});
BACKEND_INDEX

cat > backend/api/tsconfig.json << 'BACKEND_TS'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  }
}
BACKEND_TS

echo ""
echo "6. Installing dependencies (this will take a few minutes)..."
echo "   Installing frontend dependencies..."
cd frontend/marketing
npm install --no-audit --progress=false
echo "✅ Frontend dependencies installed"

echo ""
echo "   Installing backend dependencies..."
cd ../../backend/api
npm install --no-audit --progress=false
echo "✅ Backend dependencies installed"

cd ../..

echo ""
echo "=== SETUP COMPLETE! ==="
echo ""
echo "To start development:"
echo ""
echo "TERMINAL 1 (Frontend):"
echo "cd ~/Desktop/glixtron-workspace/frontend/marketing"
echo "npm run dev"
echo "→ Open http://localhost:3000"
echo ""
echo "TERMINAL 2 (Backend):"
echo "cd ~/Desktop/glixtron-workspace/backend/api"
echo "npm run dev"
echo "→ API at http://localhost:3001"
echo ""
echo "Skip Docker for now - focus on getting these working first!"
