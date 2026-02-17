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
