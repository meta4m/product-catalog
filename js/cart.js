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
