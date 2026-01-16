#!/bin/bash

echo "Creating frontend README..."
cat > frontend/README.md << 'INNEREOF'
# Glixtron Frontend

This is the frontend repository for Glixtron marketing website.

## Setup

1. Install dependencies:
\`\`\`bash
cd marketing
npm install
\`\`\`

2. Run development server:
\`\`\`bash
npm run dev
\`\`\`

3. Open http://localhost:3000

## Project Structure

- /marketing - Main Next.js application
- /docs - Documentation
- /scripts - Build and utility scripts
INNEREOF

echo "README created successfully!"
