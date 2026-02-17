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
