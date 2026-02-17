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
