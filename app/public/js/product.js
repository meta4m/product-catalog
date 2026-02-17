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
