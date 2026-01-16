#!/bin/bash

echo "=== Starting Glixtron Workspace ==="
echo ""

echo "Starting Backend API..."
cd backend/api
node server.js &
BACKEND_PID=$!
echo "Backend PID: $BACKEND_PID"

echo ""
echo "Starting Frontend..."
cd ../../frontend/marketing
python3 serve.py &
FRONTEND_PID=$!
echo "Frontend PID: $FRONTEND_PID"

echo ""
echo "=== Services Started ==="
echo "Frontend: http://localhost:3000"
echo "Backend API: http://localhost:3001"
echo "Health Check: http://localhost:3001/api/health"
echo ""
echo "Press Ctrl+C to stop all services"

# Wait for Ctrl+C
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; echo 'Services stopped'; exit" INT

wait
