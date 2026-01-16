#!/bin/bash

echo "=== Safe Start for Glixtron ==="
echo ""

# Kill any existing processes on our ports
echo "Cleaning up ports..."
kill -9 $(lsof -ti:3000,3001,3002) 2>/dev/null || true
sleep 2

echo ""
echo "Starting Backend on port 3002..."
cd backend/api
node src/index.js &
BACKEND_PID=$!
echo "Backend PID: $BACKEND_PID"
echo "API: http://localhost:3002/api/health"

echo ""
echo "Starting Frontend on port 3000..."
cd ../../frontend/marketing
# Use direct node instead of npx to avoid auto-install
node node_modules/.bin/next dev &
FRONTEND_PID=$!
echo "Frontend PID: $FRONTEND_PID"
echo "Website: http://localhost:3000"

echo ""
echo "=== Services Running ==="
echo "1. Frontend: http://localhost:3000"
echo "2. Backend API: http://localhost:3002/api/health"
echo ""
echo "Press Ctrl+C to stop all services"

cleanup() {
    echo ""
    echo "Stopping services..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    echo "Services stopped"
    exit 0
}

trap cleanup INT TERM

# Keep script running
wait
