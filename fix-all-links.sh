#!/bin/bash

echo "=== Fixing ALL Next.js Link components ==="

files=(
  "src/app/dashboard/page.tsx"
  "src/app/layout.tsx" 
  "src/components/layout/Footer.tsx"
)

for file in "${files[@]}"; do
  echo ""
  echo "🔧 Fixing: $file"
  
  if [ ! -f "$file" ]; then
    echo "  ⚠️  File not found"
    continue
  fi
  
  # 1. Add Link import if missing
  if ! grep -q "import Link from 'next/link'" "$file"; then
    echo "  ➕ Adding Link import..."
    
    # Try to find React import
    if grep -q "import React" "$file"; then
      sed -i '' '/import React/ a\
import Link from '\''next/link'\'';' "$file"
    elif grep -q "^import" "$file"; then
      # Add after last import
      last_import=$(grep -n "^import" "$file" | tail -1 | cut -d: -f1)
      sed -i '' "${last_import}a\\
import Link from 'next/link';" "$file"
    else
      # Add at top
      sed -i '' "1s/^/import Link from 'next\/link';\\
/" "$file"
    fi
  fi
  
  # 2. Fix ALL anchor tags (various patterns)
  echo "  🔄 Converting anchor tags to Link..."
  
  # Pattern 1: <a href="/">Home</a>
  sed -i '' 's|<a href="/">\([^<]*\)</a>|<Link href="/">\1</Link>|g' "$file"
  
  # Pattern 2: <a href="#">Something</a>  
  sed -i '' 's|<a href="#">\([^<]*\)</a>|<Link href="#">\1</Link>|g' "$file"
  
  # Pattern 3: <a href="">Something</a>
  sed -i '' 's|<a href="">\([^<]*\)</a>|<Link href="">\1</Link>|g' "$file"
  
  # Pattern 4: <a href="..."> with any href
  sed -i '' 's|<a href="\([^"]*\)">\([^<]*\)</a>|<Link href="\1">\2</Link>|g' "$file"
  
  echo "  ✅ File updated"
done

echo ""
echo "=== Clean up lockfiles ==="
if [ -f ../../package-lock.json ]; then
  echo "Removing duplicate package-lock.json from root..."
  rm ../../package-lock.json
fi

echo ""
echo "=== Testing build ==="
npm run build
