#!/usr/bin/env python3
import http.server
import socketserver
import os
import sys

PORT = 3000

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Serve index.html for all routes (SPA-like behavior)
        if self.path.startswith('/api'):
            # Don't handle API routes - they go to backend
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b'API calls should go to backend on port 3001')
            return
            
        # Default to index.html for all other routes
        if self.path == '/' or '.' not in self.path:
            self.path = '/index.html'
        
        return http.server.SimpleHTTPRequestHandler.do_GET(self)
    
    def end_headers(self):
        # Add CORS headers
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        http.server.SimpleHTTPRequestHandler.end_headers(self)

def main():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    print(f"""
    🌐 Glixtron Frontend Server
    ---------------------------
    Starting server on port {PORT}
    Open: http://localhost:{PORT}
    Serving: {os.getcwd()}
    """)
    
    try:
        with socketserver.TCPServer(("", PORT), Handler) as httpd:
            print("Server started successfully!")
            print("Press Ctrl+C to stop\n")
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n\nServer stopped by user")
        sys.exit(0)
    except Exception as e:
        print(f"Error starting server: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
