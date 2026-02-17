
#!/usr/bin/env bash

BASE="/home/iu/projects/product-catalog"

echo "Creating full product catalog at $BASE"
mkdir -p "$BASE"/{data,assets/images,assets/icons,css,js}

########################################
# INDEX.HTML
########################################
cat > "$BASE/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Product Catalog</title>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
  <h1>Product Catalog</h1>
  <div id="collections"></div>
  <script src="js/main.js"></script>
</body>
</html>
EOF

########################################
# COLLECTION.HTML
########################################
cat > "$BASE/collection.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Collection</title>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
  <h1>Collection</h1>
  <div id="products"></div>
  <script src="js/catalog.js"></script>
</body>
</html>
EOF

########################################
# PRODUCT.HTML
########################################
cat > "$BASE/product.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Product</title>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
  <div id="product-detail"></div>
  <button onclick="addToCart()">Add to Cart</button>
  <script src="js/product.js"></script>
</body>
</html>
EOF

########################################
# CART.HTML
########################################
cat > "$BASE/cart.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Cart</title>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
  <h1>Your Cart</h1>
  <div id="cart-items"></div>
  <button onclick="checkout()">Checkout via WhatsApp</button>
  <script src="js/cart.js"></script>
</body>
</html>
EOF

########################################
# STYLES.CSS
########################################
cat > "$BASE/css/styles.css" << 'EOF'
body { font-family: Arial, sans-serif; padding: 20px; }
h1 { margin-bottom: 20px; }
.card { border: 1px solid #ddd; padding: 10px; margin: 10px 0; }
button { padding: 8px 12px; cursor: pointer; }
EOF

########################################
# COLLECTIONS.JSON
########################################
cat > "$BASE/data/collections.json" << 'EOF'
[
  { "id": 1, "name": "Necklaces" },
  { "id": 2, "name": "Bracelets" }
]
EOF

########################################
# PRODUCTS.JSON
########################################
cat > "$BASE/data/products.json" << 'EOF'
[
  { "id": 1, "collectionId": 1, "name": "Gold Necklace", "price": 120 },
  { "id": 2, "collectionId": 1, "name": "Silver Necklace", "price": 80 },
  { "id": 3, "collectionId": 2, "name": "Diamond Bracelet", "price": 250 }
]
EOF

########################################
# MAIN.JS
########################################
cat > "$BASE/js/main.js" << 'EOF'
fetch("data/collections.json")
  .then(res => res.json())
  .then(data => {
    const container = document.getElementById("collections");
    data.forEach(c => {
      container.innerHTML += `
        <div class="card">
          <a href="collection.html?id=${c.id}">${c.name}</a>
        </div>`;
    });
  });
EOF

########################################
# CATALOG.JS
########################################
cat > "$BASE/js/catalog.js" << 'EOF'
const params = new URLSearchParams(window.location.search);
const id = params.get("id");

fetch("data/products.json")
  .then(res => res.json())
  .then(data => {
    const container = document.getElementById("products");
    data.filter(p => p.collectionId == id)
      .forEach(p => {
        container.innerHTML += `
          <div class="card">
            <a href="product.html?id=${p.id}">
              ${p.name} - $${p.price}
            </a>
          </div>`;
      });
  });
EOF

########################################
# PRODUCT.JS
########################################
cat > "$BASE/js/product.js" << 'EOF'
const params = new URLSearchParams(window.location.search);
const id = params.get("id");

let product;

fetch("data/products.json")
  .then(res => res.json())
  .then(data => {
    product = data.find(p => p.id == id);
    document.getElementById("product-detail").innerHTML = `
      <h2>${product.name}</h2>
      <p>Price: $${product.price}</p>
    `;
  });

function addToCart() {
  let cart = JSON.parse(localStorage.getItem("cart")) || [];
  cart.push(product);
  localStorage.setItem("cart", JSON.stringify(cart));
  alert("Added to cart");
}
EOF

########################################
# CART.JS
########################################
cat > "$BASE/js/cart.js" << 'EOF'
let cart = JSON.parse(localStorage.getItem("cart")) || [];
const container = document.getElementById("cart-items");

cart.forEach(p => {
  container.innerHTML += `
    <div class="card">
      ${p.name} - $${p.price}
    </div>`;
});

function checkout() {
  let message = "Order:%0A";
  cart.forEach(p => {
    message += `${p.name} - $${p.price}%0A`;
  });
  window.open(`https://wa.me/1234567890?text=${message}`, "_blank");
}
EOF

########################################
# README
########################################
cat > "$BASE/README.md" << 'EOF'
# Product Catalog v1.0

Static product catalog ready for Cloudflare Pages deployment.
Uses:
- HTML
- CSS
- Vanilla JS
- LocalStorage cart
- WhatsApp checkout
EOF

echo "Complete project generated."

