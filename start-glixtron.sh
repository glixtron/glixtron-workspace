#!/bin/bash

echo ""
echo "╔══════════════════════════════════════╗"
echo "║      🚀 GLIXTRON WORKSPACE          ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Kill existing processes
echo -e "${BLUE}Cleaning up...${NC}"
pkill -f "node.*next" 2>/dev/null || true
pkill -f "node.*server.js" 2>/dev/null || true
sleep 1

echo ""
echo -e "${GREEN}Starting Backend API...${NC}"
cd backend/api
node server.js &
BACKEND_PID=$!
sleep 2

if ps -p $BACKEND_PID > /dev/null; then
    echo -e "  ✅ Running on ${BLUE}http://localhost:3002${NC}"
    echo -e "  📊 Health: ${BLUE}http://localhost:3002/api/health${NC}"
else
    echo -e "  ❌ Failed to start backend"
    exit 1
fi

echo ""
echo -e "${GREEN}Starting Frontend...${NC}"
cd ../../frontend/marketing

if [ -f "node_modules/.bin/next" ]; then
    ./node_modules/.bin/next dev &
    FRONTEND_PID=$!
    sleep 3
    
    if ps -p $FRONTEND_PID > /dev/null; then
        echo -e "  ✅ Running on ${BLUE}http://localhost:3000${NC}"
        echo -e "  🔄 Auto-reload enabled"
    else
        echo -e "  ❌ Failed to start Next.js"
        echo -e "  🐍 Starting Python fallback..."
        python3 -m http.server 3000 &
        FRONTEND_PID=$!
    fi
else
    echo -e "  ⚠️  Next.js not found, using Python server"
    python3 -m http.server 3000 &
    FRONTEND_PID=$!
fi

echo ""
echo "╔══════════════════════════════════════╗"
echo "║          SERVICES READY             ║"
echo "╠══════════════════════════════════════╣"
echo "║ 🌐 Frontend:  http://localhost:3000  ║"
echo "║ ⚙️  Backend:   http://localhost:3002  ║"
echo "║ 📊 Health:    /api/health            ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo -e "${BLUE}Press ${GREEN}Ctrl+C${BLUE} to stop all services${NC}"
echo ""

cleanup() {
    echo ""
    echo -e "${BLUE}Stopping services...${NC}"
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    echo -e "${GREEN}✅ All services stopped${NC}"
    echo ""
    exit 0
}

trap cleanup INT TERM

# Keep running
wait
