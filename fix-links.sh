#!/bin/bash

echo "=== Fixing Next.js Link components ==="

# Array of files to fix
files=(
  "src/app/dashboard/page.tsx"
  "src/app/layout.tsx" 
  "src/components/layout/Footer.tsx"
)

for file in "${files[@]}"; do
  echo "Fixing $file..."
  
  # Check if file exists
  if [ ! -f "$file" ]; then
    echo "  ⚠️  File not found, skipping"
    continue
  fi
  
  # Add Link import if missing
  if ! grep -q "import Link from 'next/link'" "$file"; then
    # Find last import line and add after it
    last_import_line=$(grep -n "^import" "$file" | tail -1 | cut -d: -f1)
    if [ -n "$last_import_line" ]; then
      sed -i '' "${last_import_line}a\\
import Link from 'next/link';" "$file"
      echo "  ✅ Added Link import"
    else
      # No imports found, add at top
      sed -i '' "1s/^/import Link from 'next\/link';\\
/" "$file"
      echo "  ✅ Added Link import at top"
    fi
  fi
  
  # Replace <a href="/"> with <Link href="/">
  sed -i '' 's/<a href="\/">\([^<]*\)<\/a>/<Link href="\/">\1<\/Link>/g' "$file"
  echo "  ✅ Updated anchor tags"
done

echo ""
echo "=== Testing build ==="
npm run build

if [ $? -eq 0 ]; then
  echo "✅ Build successful! Ready to deploy."
else
  echo "⚠️  Build still failing. Checking for other issues..."
  npm run lint
fi
