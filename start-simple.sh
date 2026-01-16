#!/bin/bash

echo "=== Simple Glixtron Setup ==="
echo ""

# Create simple HTML frontend
mkdir -p simple-frontend
cat > simple-frontend/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Glixtron</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        header { background: #0070f3; color: white; padding: 1rem; }
        main { padding: 2rem; }
        footer { background: #f0f0f0; padding: 1rem; text-align: center; }
    </style>
</head>
<body>
    <header>
        <h1>Glixtron</h1>
    </header>
    <main>
        <h2>Welcome to Glixtron</h2>
        <p>Simple static version running.</p>
        <p>Backend API: <span id="api-status">Checking...</span></p>
        <button onclick="testAPI()">Test API</button>
        <pre id="result"></pre>
    </main>
    <footer>
        <p>© 2024 Glixtron</p>
    </footer>
    <script>
        async function testAPI() {
            try {
                const response = await fetch('http://localhost:3002/api/health');
                const data = await response.json();
                document.getElementById('result').innerHTML = JSON.stringify(data, null, 2);
                document.getElementById('api-status').innerHTML = '✅ Connected';
                document.getElementById('api-status').style.color = 'green';
            } catch (error) {
                document.getElementById('result').innerHTML = 'Error: ' + error.message;
                document.getElementById('api-status').innerHTML = '❌ Not connected';
                document.getElementById('api-status').style.color = 'red';
            }
        }
        
        // Test API on load
        testAPI();
    </script>
</body>
</html>
HTML

echo "Starting Backend..."
cd backend/api
node server.js &
BACKEND_PID=$!
sleep 2

echo "Starting Simple Frontend..."
cd ../..
python3 -m http.server 3000 --directory simple-frontend &
FRONTEND_PID=$!

echo ""
echo "✅ Services Running:"
echo "Frontend: http://localhost:3000"
echo "Backend:  http://localhost:3002/api/health"
echo ""
echo "Press Ctrl+C to stop"

trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; echo 'Services stopped'; exit" INT
wait
