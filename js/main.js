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
