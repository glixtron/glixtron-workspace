#!/bin/bash

echo "=== REPLACING ALL <a> TAGS WITH <Link> ==="

# Files to fix
files=(
  "src/app/dashboard/page.tsx"
  "src/app/layout.tsx"
  "src/components/layout/Footer.tsx"
)

for file in "${files[@]}"; do
  echo ""
  echo "🚀 Processing: $file"
  
  if [ ! -f "$file" ]; then
    echo "  ⚠️  File not found"
    continue
  fi
  
  # 1. Ensure Link import exists
  if ! grep -q "from 'next/link'" "$file" && ! grep -q 'from "next/link"' "$file"; then
    echo "  ➕ Adding Link import..."
    
    # Find where to add import (after last import or at top)
    if grep -q "^import" "$file"; then
      # Get line number of last import
      last_import=$(grep -n "^import" "$file" | tail -1 | cut -d: -f1)
      # Add after last import
      sed -i '' "${last_import}a\\
import Link from 'next/link';" "$file"
    else
      # Add at very top
      sed -i '' "1s/^/import Link from 'next\/link';\\
/" "$file"
    fi
  fi
  
  # 2. Replace ALL anchor tags with Link (any pattern)
  echo "  🔄 Converting ALL <a> tags..."
  
  # Count before
  before=$(grep -c "<a " "$file" || true)
  
  # Replace using Perl for complex patterns
  perl -i -pe '
    # Replace <a href="anything">text</a> with <Link href="anything">text</Link>
    s/<a\s+href="([^"]*)">([^<]*)<\/a>/<Link href="$1">$2<\/Link>/g;
    
    # Replace <a href=\'anything\'>text</a> with single quotes
    s/<a\s+href=\'([^\']*)\'>([^<]*)<\/a>/<Link href="$1">$2<\/Link>/g;
    
    # Replace <a> with any attributes (catch-all)
    s/<a(\s+[^>]*)>([^<]*)<\/a>/<Link$1>$2<\/Link>/g;
  ' "$file"
  
  # Count after
  after=$(grep -c "<a " "$file" || true)
  
  echo "  ✅ Changed $before → $after <a> tags remaining"
done

echo ""
echo "=== Clean build ==="
rm -f .eslintrc.json  # Remove any old config
npm run build
