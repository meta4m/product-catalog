export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const hostname = url.hostname;

    // Extract subdomain
    const subdomain = hostname.split('.')[0];

    // Lookup tenant
    const tenantQuery = await env.stores_db
      .prepare("SELECT * FROM tenants WHERE subdomain = ?")
      .bind(subdomain)
      .all();

    if (!tenantQuery.results.length) {
      return new Response("Tenant not found", { status: 404 });
    }

    const tenant = tenantQuery.results[0];
    request.tenant = tenant;

    // Routing
    if (url.pathname === "/api/products") return getProducts(request, env);
    if (url.pathname === "/api/orders" && request.method === "POST") return createOrder(request, env);

    return new Response("Not Found", { status: 404 });
  }
};

async function getProducts(request, env) {
  const tenantId = request.tenant.id;

  const productsQuery = await env.stores_db
    .prepare("SELECT * FROM products WHERE tenant_id = ?")
    .bind(tenantId)
    .all();

  return new Response(JSON.stringify(productsQuery.results), {
    headers: { "Content-Type": "application/json" }
  });
}

async function createOrder(request, env) {
  const tenantId = request.tenant.id;
  const data = await request.json();

  const orderId = crypto.randomUUID();
  const { items, total, customer_name, customer_phone } = data;

  await env.stores_db
    .prepare(
      "INSERT INTO orders (id, tenant_id, items, total, customer_name, customer_phone, status) VALUES (?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(orderId, tenantId, JSON.stringify(items), total, customer_name, customer_phone, "pending")
    .run();

  const summary = `OrderID: ${orderId}, Total: ${total}`;
  const waLink = `https://wa.me/${request.tenant.whatsapp}?text=${encodeURIComponent(summary)}`;

  return new Response(JSON.stringify({ redirect: waLink }), {
    headers: { "Content-Type": "application/json" }
  });
}

