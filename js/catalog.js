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
