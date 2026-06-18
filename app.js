(function () {
  const state = {
    data: structuredClone(window.BRAVA_SEED),
    activeBanner: 0,
    filters: {
      category: getQueryParam("categoria") || "todos",
      search: "",
      highlight: false
    }
  };

  document.addEventListener("DOMContentLoaded", () => {
    init().catch((error) => console.error("Não foi possível iniciar o site.", error));
  });

  async function init() {
    state.data = await loadData();
    renderSharedLayout();
    bindMobileMenu();

    const page = document.body.dataset.page;
    if (page === "home") renderHome();
    if (page === "catalog") renderCatalog();
    if (page === "contact") renderContact();

    renderProductModal();
  }

  async function loadData() {
    const fallback = structuredClone(window.BRAVA_SEED);
    const client = window.bravaSupabase;
    if (!client) return fallback;

    try {
      const [companyResult, categoriesResult, productsResult, bannersResult] = await Promise.all([
        client.from("company_settings").select("*").eq("id", true).maybeSingle(),
        client.from("categories").select("*").eq("is_active", true).order("sort_order"),
        client.from("products").select("*").eq("active", true).order("sort_order"),
        client.from("banners").select("*").eq("is_active", true).order("sort_order")
      ]);

      const failed = [companyResult, categoriesResult, productsResult, bannersResult].find((result) => result.error);
      if (failed) throw failed.error;

      const categories = (categoriesResult.data || []).map((row) => ({
        id: row.slug,
        dbId: row.id,
        name: row.name,
        description: row.description || "",
        image: row.image_url || "assets/cleaning-bottles.jpg"
      }));
      const categoryByDbId = new Map(categories.map((category) => [category.dbId, category.id]));
      const products = (productsResult.data || []).map((row) => ({
        id: row.slug,
        dbId: row.id,
        name: row.name,
        code: row.code || "",
        price: row.price_label || "",
        categoryId: categoryByDbId.get(row.category_id) || "",
        image: row.image_url || "assets/cleaning-bottles.jpg",
        description: row.description || "",
        featured: Boolean(row.featured),
        active: row.active !== false
      }));
      const banners = (bannersResult.data || []).map((row) => ({
        id: row.id,
        title: row.title,
        subtitle: row.subtitle || "",
        text: row.body || "",
        cta: row.cta_label || "Chamar no WhatsApp",
        ctaUrl: row.cta_url || "",
        image: row.image_url || "assets/hero-cleaning.jpg"
      }));

      return {
        company: mapCompany(companyResult.data, fallback.company),
        categories: categories.length ? categories : fallback.categories,
        products: products.length ? products : fallback.products,
        banners: banners.length ? banners : fallback.banners
      };
    } catch (error) {
      console.warn("Supabase indisponível; usando dados locais.", error);
      return fallback;
    }
  }

  function mapCompany(row, fallback) {
    if (!row) return fallback;
    return {
      ...fallback,
      name: row.name || fallback.name,
      shortName: row.short_name || fallback.shortName,
      slogan: row.slogan || fallback.slogan,
      description: row.description || fallback.description,
      logo: row.logo_url || fallback.logo,
      whatsapp: row.whatsapp || fallback.whatsapp,
      whatsappDisplay: row.whatsapp_display || fallback.whatsappDisplay,
      whatsappLegacyLink: row.whatsapp_legacy_link || fallback.whatsappLegacyLink,
      phone: row.phone || fallback.phone,
      email: row.email || fallback.email,
      instagram: row.instagram_url || fallback.instagram,
      address: row.address || fallback.address,
      mapsUrl: row.maps_url || fallback.mapsUrl,
      mapsEmbed: row.maps_embed || fallback.mapsEmbed,
      cnpj: row.cnpj || fallback.cnpj,
      hours: row.hours || fallback.hours
    };
  }

  function renderSharedLayout() {
    const header = document.querySelector("[data-header]");
    const footer = document.querySelector("[data-footer]");
    const current = document.body.dataset.page;

    if (header) {
      header.innerHTML = `
        <div class="site-header">
          <div class="container header-row">
            <a class="brand" href="index.html" aria-label="${escapeHtml(state.data.company.name)}">
              <img src="${escapeHtml(state.data.company.logo)}" alt="${escapeHtml(state.data.company.name)}">
            </a>
            <nav class="nav" data-nav>
              <a href="index.html" ${current === "home" ? 'aria-current="page"' : ""}>Início</a>
              <a href="catalogo.html" ${current === "catalog" ? 'aria-current="page"' : ""}>Catálogo</a>
              <a href="contato.html" ${current === "contact" ? 'aria-current="page"' : ""}>Contato</a>
              <a href="admin.html">Admin</a>
            </nav>
            <div class="header-actions">
              <a class="button whatsapp" href="${whatsappLink()}" target="_blank" rel="noreferrer">WhatsApp</a>
              <button class="mobile-menu-button" type="button" data-menu-button aria-label="Abrir menu">☰</button>
            </div>
          </div>
        </div>
      `;
    }

    if (footer) {
      footer.innerHTML = `
        <div class="footer">
          <div class="container">
            <div class="footer-grid">
              <div>
                <img src="${escapeHtml(state.data.company.logo)}" alt="${escapeHtml(state.data.company.name)}">
                <p>${escapeHtml(state.data.company.description)}</p>
              </div>
              <div>
                <h3>Catálogo</h3>
                ${state.data.categories
                  .slice(0, 6)
                  .map((category) => `<p><a href="catalogo.html?categoria=${category.id}">${escapeHtml(category.name)}</a></p>`)
                  .join("")}
              </div>
              <div>
                <h3>Contato</h3>
                <div class="footer-contact-list">
                  <a href="${whatsappLink()}" target="_blank" rel="noreferrer">WhatsApp: ${escapeHtml(state.data.company.whatsappDisplay)}</a>
                  <a href="tel:${digits(state.data.company.phone)}">Telefone: ${escapeHtml(state.data.company.phone)}</a>
                  <a href="mailto:${escapeHtml(state.data.company.email)}">E-mail: ${escapeHtml(state.data.company.email)}</a>
                  <a href="${escapeHtml(state.data.company.instagram)}" target="_blank" rel="noreferrer">Instagram</a>
                </div>
              </div>
              <div>
                <h3>Onde nos encontrar</h3>
                <p>${escapeHtml(state.data.company.address)}</p>
                <p>CNPJ: ${escapeHtml(state.data.company.cnpj)}</p>
              </div>
            </div>
            <div class="footer-bottom">
              Copyright © 2026 por ${escapeHtml(state.data.company.name)}. Todos os direitos reservados.
            </div>
          </div>
        </div>
      `;
    }
  }

  function bindMobileMenu() {
    const button = document.querySelector("[data-menu-button]");
    const nav = document.querySelector("[data-nav]");
    if (!button || !nav) return;

    button.addEventListener("click", () => {
      nav.classList.toggle("open");
    });
  }

  function renderHome() {
    renderHero();
    renderCategories("[data-home-categories]");
    renderFeaturedProducts("[data-featured-products]");
    renderCompanyHighlights();
  }

  function renderHero() {
    const target = document.querySelector("[data-hero]");
    if (!target) return;

    const banner = state.data.banners[state.activeBanner] || state.data.banners[0];
    target.innerHTML = `
      <section class="hero">
        <div class="hero-media">
          <img src="${escapeHtml(banner.image)}" alt="${escapeHtml(banner.title)}">
        </div>
        <div class="container">
          <div>
            <div class="eyebrow">${escapeHtml(banner.subtitle)}</div>
            <h1>${escapeHtml(banner.title)}</h1>
            <p>${escapeHtml(banner.text)}</p>
            <div class="hero-actions">
              <a class="button whatsapp" href="${whatsappLink()}" target="_blank" rel="noreferrer">${escapeHtml(banner.cta)}</a>
              <a class="button ghost" href="catalogo.html">Ver catálogo</a>
            </div>
            <div class="hero-metrics">
              <div class="metric"><strong>Casa</strong><span>limpeza para o dia a dia</span></div>
              <div class="metric"><strong>Empresa</strong><span>itens para reposição</span></div>
              <div class="metric"><strong>08h-17h</strong><span>atendimento em dias úteis</span></div>
            </div>
          </div>
        </div>
        <div class="banner-tabs" aria-label="Banners">
          ${state.data.banners
            .map(
              (_, index) =>
                `<button type="button" class="${index === state.activeBanner ? "active" : ""}" data-banner-index="${index}" aria-label="Banner ${
                  index + 1
                }"></button>`
            )
            .join("")}
        </div>
      </section>
    `;

    target.querySelectorAll("[data-banner-index]").forEach((button) => {
      button.addEventListener("click", () => {
        state.activeBanner = Number(button.dataset.bannerIndex);
        renderHero();
      });
    });
  }

  function renderCategories(selector) {
    const target = document.querySelector(selector);
    if (!target) return;

    target.innerHTML = state.data.categories
      .map(
        (category) => `
          <a class="category-card" href="catalogo.html?categoria=${category.id}">
            <img src="${escapeHtml(category.image)}" alt="${escapeHtml(category.name)}">
            <div class="category-card-body">
              <h3>${escapeHtml(category.name)}</h3>
              <p>${escapeHtml(category.description)}</p>
            </div>
          </a>
        `
      )
      .join("");
  }

  function renderFeaturedProducts(selector) {
    const target = document.querySelector(selector);
    if (!target) return;

    const products = state.data.products.filter((product) => product.active && product.featured).slice(0, 8);
    target.innerHTML = products.length ? products.map(productCard).join("") : emptyState("Nenhum produto em destaque.");
    bindProductButtons(target);
  }

  function renderCompanyHighlights() {
    const target = document.querySelector("[data-company-highlights]");
    if (!target) return;

    target.innerHTML = `
      <div class="feature-band">
        <div>
          <div class="eyebrow">Por que escolher a Brava</div>
          <h2>Variedade e atendimento direto para sua compra do dia a dia</h2>
          <p class="lead">A Brava atende quem precisa comprar com praticidade, variedade e orientação para escolher os produtos certos.</p>
          <div class="feature-list">
            <div class="feature-item">
              <span class="feature-mark">1</span>
              <div><h3>Variedade em um só lugar</h3><p>Produtos para limpeza, higiene, descartáveis, papéis, aromatizadores e equipamentos.</p></div>
            </div>
            <div class="feature-item">
              <span class="feature-mark">2</span>
              <div><h3>Atendimento direto</h3><p>Fale com a equipe pelo WhatsApp para confirmar disponibilidade, valores e melhores opções.</p></div>
            </div>
            <div class="feature-item">
              <span class="feature-mark">3</span>
              <div><h3>Compra mais prática</h3><p>Consulte o catálogo por categoria e envie seu pedido de orçamento em poucos cliques.</p></div>
            </div>
          </div>
        </div>
        <div class="feature-image">
          <img src="assets/hero-equipment.jpg" alt="Equipamentos de limpeza">
        </div>
      </div>
    `;
  }

  function renderCatalog() {
    const categoryFilter = document.querySelector("[data-category-filter]");
    const productList = document.querySelector("[data-product-list]");
    const searchInput = document.querySelector("[data-search]");
    const sortSelect = document.querySelector("[data-sort]");
    const title = document.querySelector("[data-catalog-title]");
    const subtitle = document.querySelector("[data-catalog-subtitle]");

    if (!categoryFilter || !productList) return;

    categoryFilter.innerHTML = [
      `<button class="chip ${state.filters.category === "todos" ? "active" : ""}" data-category="todos">Todos</button>`,
      ...state.data.categories.map(
        (category) =>
          `<button class="chip ${state.filters.category === category.id ? "active" : ""}" data-category="${category.id}">${escapeHtml(category.name)}</button>`
      )
    ].join("");

    categoryFilter.querySelectorAll("[data-category]").forEach((button) => {
      button.addEventListener("click", () => {
        state.filters.category = button.dataset.category;
        const url = state.filters.category === "todos" ? "catalogo.html" : `catalogo.html?categoria=${state.filters.category}`;
        window.history.replaceState({}, "", url);
        renderCatalog();
      });
    });

    if (searchInput && !searchInput.dataset.bound) {
      searchInput.dataset.bound = "true";
      searchInput.addEventListener("input", () => {
        state.filters.search = searchInput.value;
        renderCatalog();
      });
    }

    if (sortSelect && !sortSelect.dataset.bound) {
      sortSelect.dataset.bound = "true";
      sortSelect.addEventListener("change", renderCatalog);
    }

    const activeCategory = getCategory(state.filters.category);
    if (title) title.textContent = activeCategory ? activeCategory.name : "Catálogo de produtos";
    if (subtitle) {
      subtitle.textContent = activeCategory
        ? activeCategory.description
        : "Consulte produtos de limpeza, higiene, descartáveis, papéis e equipamentos. Para comprar, chame a Brava no WhatsApp.";
    }

    const query = normalize(state.filters.search);
    const sort = sortSelect ? sortSelect.value : "featured";
    let products = state.data.products.filter((product) => product.active);

    if (state.filters.category !== "todos") {
      products = products.filter((product) => product.categoryId === state.filters.category);
    }

    if (query) {
      products = products.filter((product) => {
        const haystack = normalize(`${product.name} ${product.description} ${product.code || ""} ${getCategoryName(product.categoryId)}`);
        return haystack.includes(query);
      });
    }

    products = sortProducts(products, sort);
    productList.innerHTML = products.length ? products.map(productCard).join("") : emptyState("Nenhum produto encontrado com esses filtros.");
    bindProductButtons(productList);
  }

  function renderContact() {
    const target = document.querySelector("[data-contact]");
    if (!target) return;
    const mapsUrl = state.data.company.mapsUrl || window.BRAVA_SEED.company.mapsUrl;
    const mapsEmbed = state.data.company.mapsEmbed || window.BRAVA_SEED.company.mapsEmbed;

    target.innerHTML = `
      <div class="feature-band">
        <div>
          <div class="eyebrow">Fale conosco</div>
          <h2>Entre em contato pelo WhatsApp para fazermos um orçamento</h2>
          <p class="lead">A equipe da ${escapeHtml(state.data.company.name)} atende de segunda a sexta e pode confirmar valores, disponibilidade e melhores opções para sua necessidade.</p>
          <div class="hero-actions">
            <a class="button whatsapp" href="${whatsappLink("Olá, gostaria de fazer um orçamento.")}" target="_blank" rel="noreferrer">Chamar no WhatsApp</a>
            <a class="button secondary" href="mailto:${escapeHtml(state.data.company.email)}">Enviar e-mail</a>
          </div>
        </div>
        <div class="contact-stack">
          <div class="admin-card">
            <h3>Dados de contato</h3>
            <p><strong>WhatsApp:</strong> ${escapeHtml(state.data.company.whatsappDisplay)}</p>
            <p><strong>Telefone:</strong> ${escapeHtml(state.data.company.phone)}</p>
            <p><strong>E-mail:</strong> ${escapeHtml(state.data.company.email)}</p>
            <p><strong>Endereço:</strong> ${escapeHtml(state.data.company.address)}</p>
            <p><strong>Horário:</strong> ${escapeHtml(state.data.company.hours)}</p>
            <p><strong>CNPJ:</strong> ${escapeHtml(state.data.company.cnpj)}</p>
          </div>
          <div class="map-card">
            <div class="map-fallback">
              <strong>Brava Materiais de Limpeza</strong>
              <span>${escapeHtml(state.data.company.address)}</span>
            </div>
            <iframe
              title="Mapa da Brava Materiais de Limpeza"
              src="${escapeHtml(mapsEmbed)}"
              loading="lazy"
              referrerpolicy="no-referrer-when-downgrade"
            ></iframe>
            <a class="button secondary" href="${escapeHtml(mapsUrl)}" target="_blank" rel="noreferrer">
              Abrir no Google Maps
            </a>
          </div>
        </div>
      </div>
    `;
  }

  function productCard(product) {
    const categoryName = getCategoryName(product.categoryId);
    return `
      <article class="product-card">
        <div class="product-media">
          ${product.featured ? '<span class="badge">Destaque</span>' : ""}
          <img src="${escapeHtml(product.image)}" alt="${escapeHtml(product.name)}" loading="lazy">
        </div>
        <div class="product-body">
          <span class="product-category">${escapeHtml(categoryName)}</span>
          <h3 class="product-title">${escapeHtml(product.name)}</h3>
          <p class="product-description">${escapeHtml(product.description || "Produto disponível para orçamento.")}</p>
          <div class="product-footer">
            <div class="price">${product.price ? escapeHtml(product.price) : "Sob consulta"}</div>
            <div class="product-actions">
              <button class="button secondary" type="button" data-product-detail="${escapeHtml(product.id)}">Ver detalhes</button>
              <a class="button whatsapp" href="${productWhatsappLink(product)}" target="_blank" rel="noreferrer">Pedir orçamento</a>
            </div>
          </div>
        </div>
      </article>
    `;
  }

  function bindProductButtons(root) {
    root.querySelectorAll("[data-product-detail]").forEach((button) => {
      button.addEventListener("click", () => openProductModal(button.dataset.productDetail));
    });
  }

  function renderProductModal() {
    const modal = document.querySelector("[data-modal]");
    if (!modal) return;

    modal.addEventListener("click", (event) => {
      if (event.target === modal || event.target.matches("[data-modal-close]")) {
        modal.classList.remove("open");
      }
    });

    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape") modal.classList.remove("open");
    });
  }

  function openProductModal(productId) {
    const modal = document.querySelector("[data-modal]");
    if (!modal) return;

    const product = state.data.products.find((item) => item.id === productId);
    if (!product) return;

    modal.innerHTML = `
      <div class="modal-panel" role="dialog" aria-modal="true" aria-label="${escapeHtml(product.name)}">
        <div class="modal-grid">
          <div class="modal-image">
            <img src="${escapeHtml(product.image)}" alt="${escapeHtml(product.name)}">
          </div>
          <div class="modal-content">
            <button class="modal-close" type="button" data-modal-close aria-label="Fechar">×</button>
            <span class="product-category">${escapeHtml(getCategoryName(product.categoryId))}</span>
            <h2>${escapeHtml(product.name)}</h2>
            <p>${escapeHtml(product.description || "Produto disponível para orçamento.")}</p>
            <p><strong>Código:</strong> ${escapeHtml(product.code || "Não informado")}</p>
            <p><strong>Valor:</strong> ${product.price ? escapeHtml(product.price) : "Sob consulta"}</p>
            <div class="hero-actions">
              <a class="button whatsapp" href="${productWhatsappLink(product)}" target="_blank" rel="noreferrer">Pedir orçamento pelo WhatsApp</a>
              <button class="button secondary" type="button" data-modal-close>Fechar</button>
            </div>
          </div>
        </div>
      </div>
    `;

    modal.classList.add("open");
  }

  function sortProducts(products, sort) {
    const copy = [...products];
    if (sort === "name") copy.sort((a, b) => a.name.localeCompare(b.name));
    if (sort === "category") copy.sort((a, b) => getCategoryName(a.categoryId).localeCompare(getCategoryName(b.categoryId)));
    if (sort === "featured") copy.sort((a, b) => Number(b.featured) - Number(a.featured) || a.name.localeCompare(b.name));
    return copy;
  }

  function getCategory(id) {
    return state.data.categories.find((category) => category.id === id);
  }

  function getCategoryName(id) {
    return getCategory(id)?.name || "Sem categoria";
  }

  function whatsappLink(message) {
    const defaultMessage = message || "Olá, gostaria de fazer um orçamento com a Brava Materiais de Limpeza.";
    return `https://wa.me/${digits(state.data.company.whatsapp)}?text=${encodeURIComponent(defaultMessage)}`;
  }

  function productWhatsappLink(product) {
    const message = `Olá, gostaria de fazer um orçamento do produto: ${product.name}${product.code ? ` (${product.code})` : ""}.`;
    return whatsappLink(message);
  }

  function getQueryParam(name) {
    return new URLSearchParams(window.location.search).get(name);
  }

  function digits(value) {
    return String(value || "").replace(/\D/g, "");
  }

  function normalize(value) {
    return String(value || "")
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
      .trim();
  }

  function escapeHtml(value) {
    return String(value ?? "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  function emptyState(message) {
    return `<div class="empty">${escapeHtml(message)}</div>`;
  }
})();
