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
