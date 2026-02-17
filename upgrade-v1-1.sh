
#!/usr/bin/env bash

BASE="/home/iu/projects/product-catalog"

echo "Upgrading to v1.1..."

mkdir -p "$BASE"/{data,assets/images,css,js}

########################################
# STYLES.CSS
########################################
cat > "$BASE/css/styles.css" << 'EOF'
body {
  font-family: system-ui, -apple-system, sans-serif;
  margin: 0;
  background: #f7f7f7;
  color: #111;
}

.container {
  max-width: 1100px;
  margin: auto;
  padding: 20px;
}

h1, h2 {
  margin-bottom: 20px;
}

.grid {
  display: grid;
  gap: 20px;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
}

.card {
  background: #fff;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  transition: transform 0.2s ease;
}

.card:hover {
  transform: translateY(-4px);
}

.card img {
  width: 100%;
  aspect-ratio: 1/1;
  object-fit: cover;
}

.card-content {
  padding: 15px;
}

button {
  background: #111;
  color: #fff;
  border: none;
  padding: 12px 18px;
  cursor: pointer;
  border-radius: 6px;
}

button:hover {
  opacity: 0.9;
}

.gallery {
  display: flex;
  gap: 10px;
}

.gallery img {
  width: 70px;
  cursor: pointer;
  border-radius: 6px;
}

.main-image {
  width: 100%;
  border-radius: 10px;
  margin-bottom: 15px;
}
EOF

########################################
# INDEX.HTML
########################################
cat > "$BASE/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Jewelz</title>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
  <div class="container">
    <h1>Collections</h1>
    <div id="collections" class="grid"></div>
  </div>
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
  <div class="container">
    <h1>Products</h1>
    <div id="products" class="grid"></div>
  </div>
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
  <div class="container" id="product-detail"></div>
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
  <div class="container">
    <h1>Your Cart</h1>
    <div id="cart-items"></div>
    <h3>Contact Info</h3>
    <input id="name" placeholder="Your Name"><br><br>
    <input id="phone" placeholder="Phone Number"><br><br>
    <button onclick="checkout()">Checkout via WhatsApp</button>
  </div>
  <script src="js/cart.js"></script>
</body>
</html>
EOF

########################################
# DATA
########################################
cat > "$BASE/data/collections.json" << 'EOF'
[
  { "id": 1, "name": "Necklaces" },
  { "id": 2, "name": "Bracelets" }
]
EOF

cat > "$BASE/data/products.json" << 'EOF'
[
  {
    "id": 1,
    "collectionId": 1,
    "name": "Gold Necklace",
    "price": 120,
    "description": "Elegant handcrafted gold necklace.",
    "images": ["assets/images/sample1.jpg"]
  },
  {
    "id": 2,
    "collectionId": 2,
    "name": "Diamond Bracelet",
    "price": 250,
    "description": "Premium diamond bracelet.",
    "images": ["assets/images/sample2.jpg"]
  }
]
EOF

########################################
# JS FILES
########################################
cat > "$BASE/js/main.js" << 'EOF'
fetch("data/collections.json")
  .then(res => res.json())
  .then(data => {
    const container = document.getElementById("collections");
    data.forEach(c => {
      container.innerHTML += `
        <div class="card">
          <div class="card-content">
            <a href="collection.html?id=${c.id}">
              <h2>${c.name}</h2>
            </a>
          </div>
        </div>`;
    });
  });
EOF

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
            <img src="${p.images[0]}" alt="">
            <div class="card-content">
              <h3>${p.name}</h3>
              <p>$${p.price}</p>
              <a href="product.html?id=${p.id}">
                <button>View</button>
              </a>
            </div>
          </div>`;
      });
  });
EOF

cat > "$BASE/js/product.js" << 'EOF'
const params = new URLSearchParams(window.location.search);
const id = params.get("id");
let product;

fetch("data/products.json")
  .then(res => res.json())
  .then(data => {
    product = data.find(p => p.id == id);
    const container = document.getElementById("product-detail");

    container.innerHTML = `
      <img src="${product.images[0]}" class="main-image">
      <h2>${product.name}</h2>
      <p>${product.description}</p>
      <h3>$${product.price}</h3>
      <button onclick="addToCart()">Add to Cart</button>
    `;
  });

function addToCart() {
  let cart = JSON.parse(localStorage.getItem("cart")) || [];
  const existing = cart.find(p => p.id == product.id);
  if (existing) {
    existing.qty += 1;
  } else {
    product.qty = 1;
    cart.push(product);
  }
  localStorage.setItem("cart", JSON.stringify(cart));
  alert("Added to cart");
}
EOF

cat > "$BASE/js/cart.js" << 'EOF'
let cart = JSON.parse(localStorage.getItem("cart")) || [];
const container = document.getElementById("cart-items");

cart.forEach(p => {
  container.innerHTML += `
    <div>
      ${p.name} x${p.qty} - $${p.price * p.qty}
    </div>`;
});

function checkout() {
  const name = document.getElementById("name").value;
  const phone = document.getElementById("phone").value;

  if (!name || !phone) {
    alert("Please enter contact details");
    return;
  }

  let message = `Order from ${name} (${phone})%0A`;
  cart.forEach(p => {
    message += `${p.name} x${p.qty} - $${p.price * p.qty}%0A`;
  });

  window.open(`https://wa.me/1234567890?text=${message}`, "_blank");
}
EOF

echo "v1.1 upgrade complete."

