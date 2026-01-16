#!/bin/bash

echo "=== Starting Glixtron ==="
echo ""

# Kill any existing processes
echo "Cleaning up..."
pkill -f "node.*next" 2>/dev/null || true
pkill -f "node.*server.js" 2>/dev/null || true
sleep 2

echo "Starting Backend..."
cd backend/api
if [ ! -f "server.js" ]; then
    echo "❌ Backend server.js not found!"
    exit 1
fi

if [ ! -d "node_modules/express" ]; then
    echo "⚠️  Express not found, installing..."
    npm install express@4.18.2 cors@2.8.5 --no-audit --progress=false 2>/dev/null || echo "Installation might fail"
fi

node server.js &
BACKEND_PID=$!
sleep 3

# Check if backend started
if ps -p $BACKEND_PID > /dev/null; then
    echo "✅ Backend running (PID: $BACKEND_PID)"
    echo "   API: http://localhost:3002/api/health"
else
    echo "❌ Backend failed to start"
fi

echo ""
echo "Starting Frontend..."
cd ../../frontend/marketing

# Check if Next.js is installed
if [ ! -f "node_modules/.bin/next" ]; then
    echo "⚠️  Next.js not found, installing..."
    npm install next@14.1.0 --no-audit --progress=false 2>/dev/null || echo "Installation might fail"
    npm install react@18.2.0 react-dom@18.2.0 --no-audit --progress=false 2>/dev/null || echo "Installation might fail"
fi

if [ -f "node_modules/.bin/next" ]; then
    ./node_modules/.bin/next dev &
    FRONTEND_PID=$!
    sleep 3
    
    if ps -p $FRONTEND_PID > /dev/null; then
        echo "✅ Frontend running (PID: $FRONTEND_PID)"
        echo "   Website: http://localhost:3000"
    else
        echo "❌ Frontend failed to start"
    fi
else
    echo "❌ Next.js still not available"
    echo "   Trying alternative: Simple HTTP server..."
    python3 -m http.server 3000 &
    FRONTEND_PID=$!
    echo "   Simple server on http://localhost:3000"
fi

echo ""
echo "=== Services ==="
echo "Frontend: http://localhost:3000"
echo "Backend:  http://localhost:3002/api/health"
echo ""
echo "Press Ctrl+C to stop"

cleanup() {
    echo ""
    echo "Stopping services..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    exit 0
}

trap cleanup INT TERM

wait
