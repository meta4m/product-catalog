#!/bin/bash

BASE_DIR="$HOME/projects/product-catalog"

echo "Upgrading product-catalog to v1.1 structure..."

cd "$BASE_DIR" || exit 1

# Backup old static structure
mkdir -p legacy-v1.0
echo "Archiving old root HTML/CSS/JSON into legacy-v1.0..."
mv *.html legacy-v1.0/ 2>/dev/null
mv *.css legacy-v1.0/ 2>/dev/null
mv *.json legacy-v1.0/ 2>/dev/null
mv assets legacy-v1.0/ 2>/dev/null

# Create new structure
mkdir -p workers/routes
mkdir -p workers/utils
mkdir -p frontend/css
mkdir -p frontend/js
mkdir -p frontend/assets
mkdir -p admin/css
mkdir -p admin/js
mkdir -p utils

# Core files
touch package.json
touch wrangler.toml
touch README.md

# Worker files
touch workers/index.js
touch workers/routes/public.js
touch workers/routes/admin.js
touch workers/utils/db.js
touch workers/utils/r2.js
touch workers/utils/auth.js
touch workers/middleware.js

# Frontend files
touch frontend/index.html
touch frontend/product.html
touch frontend/cart.html
touch frontend/wishlist.html
touch frontend/css/styles.css
touch frontend/js/main.js
touch frontend/js/swipe.js
touch frontend/js/cart.js

# Admin files
touch admin/index.html
touch admin/products.html
touch admin/orders.html
touch admin/settings.html
touch admin/css/admin.css
touch admin/js/admin.js
touch admin/js/products.js
touch admin/js/orders.js
touch admin/js/settings.js

# Shared utils
touch utils/constants.js

echo "v1.1 folder structure created successfully."
echo "Old v1.0 files preserved in legacy-v1.0/"

