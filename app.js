(function () {
  const state = {
    data: structuredClone(window.BRAVA_SEED),
    activeBanner: 0,
    bannerTimer: null,
    cart: [],
    cartToastTimer: null,
    filters: {
      category: getQueryParam("categoria") || "todos",
      search: "",
      highlight: false
    }
  };
  const GOOGLE_ADS_CONTACT_CONVERSION = "AW-18269808861/l9B1CMDI8cQcEN3R3IdE";
  const CART_STORAGE_KEY = "brava_quote_cart";
  const OFFICIAL_EMAIL = "bravamateriais@hotmail.com";
  const PRODUCT_PLACEHOLDER_IMAGE = "assets/brava-materiais-perfil-instagram.png";
  const GENERIC_PRODUCT_IMAGES = new Set([
    "assets/cleaning-bottles.jpg",
    "assets/category-produtos-limpeza.jpg",
    "assets/category-descartaveis.jpg",
    "assets/category-equipamentos.jpg",
    "assets/category-papeis-panos.jpg",
    "assets/category-aromatizadores.jpg",
    "assets/category-banheiro.jpg",
    "assets/category-cozinha.jpg",
    "assets/category-diversos.jpg"
  ]);

  document.addEventListener("DOMContentLoaded", () => {
    init().catch((error) => console.error("Não foi possível iniciar o site.", error));
  });

  async function init() {
    state.data = await loadData();
    state.cart = loadCart();
    renderSharedLayout();
    renderCartShell();
    bindMobileMenu();
    bindCartActions();
    renderCart();

    const page = document.body.dataset.page;
    if (page === "home") renderHome();
    if (page === "catalog") renderCatalog();
    if (page === "contact") renderContact();

    renderProductModal();
    bindConversionTracking();
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

      const variantsByProductDbId = await loadProductVariants(client);
      const categories = (categoriesResult.data || []).map((row) => ({
        id: row.slug,
        dbId: row.id,
        name: row.name,
        description: row.description || "",
        image: row.image_url || "assets/cleaning-bottles.jpg"
      }));
      const categoryByDbId = new Map(categories.map((category) => [category.dbId, category.id]));
      const categoryIdsByProductDbId = await loadProductCategories(client, categoryByDbId);
      const products = (productsResult.data || []).map((row) => ({
        ...mapProductRow(row, categoryByDbId, categoryIdsByProductDbId, variantsByProductDbId)
      }));
      const banners = (bannersResult.data || []).map((row) => ({
        id: row.id,
        title: row.title,
        subtitle: row.subtitle || "",
        text: row.body || "",
        cta: row.cta_label || "Chamar no WhatsApp",
        ctaUrl: row.cta_url || "",
        image: row.image_url || "assets/hero-brava-estrutura-4k.jpg"
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

  async function loadProductVariants(client) {
    try {
      const { data: rows, error } = await client.from("product_variants").select("*").eq("active", true).order("sort_order");
      if (error) throw error;

      return (rows || []).reduce((map, row) => {
        const variant = {
          id: row.id,
          name: row.name,
          code: row.code || "",
          price: row.price_label || "",
          description: row.description || "",
          active: row.active !== false,
          sortOrder: row.sort_order || 0
        };
        const current = map.get(row.product_id) || [];
        current.push(variant);
        map.set(row.product_id, current);
        return map;
      }, new Map());
    } catch (error) {
      console.warn("Variações de produtos indisponíveis.", error);
      return new Map();
    }
  }

  async function loadProductCategories(client, categoryByDbId) {
    try {
      const { data: rows, error } = await client.from("product_categories").select("product_id, category_id, sort_order").order("sort_order");
      if (error) throw error;

      return (rows || []).reduce((map, row) => {
        const categoryId = categoryByDbId.get(row.category_id);
        if (!categoryId) return map;
        const current = map.get(row.product_id) || [];
        if (!current.includes(categoryId)) current.push(categoryId);
        map.set(row.product_id, current);
        return map;
      }, new Map());
    } catch (error) {
      console.warn("Categorias adicionais de produtos indisponiveis.", error);
      return new Map();
    }
  }

  function mapProductRow(row, categoryByDbId, categoryIdsByProductDbId, variantsByProductDbId) {
    const primaryCategoryId = categoryByDbId.get(row.category_id) || "";
    const linkedCategoryIds = categoryIdsByProductDbId.get(row.id) || [];
    const categoryIds = uniqueValues([primaryCategoryId, ...linkedCategoryIds].filter(Boolean));

    return {
      id: row.slug,
      dbId: row.id,
      name: row.name,
      code: row.code || "",
      price: row.price_label || "",
      categoryId: categoryIds[0] || primaryCategoryId,
      categoryIds,
      image: productImage(row.image_url),
      description: row.description || "",
      featured: Boolean(row.featured),
      active: row.active !== false,
      variants: variantsByProductDbId.get(row.id) || []
    };
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
      email: normalizeCompanyEmail(row.email || fallback.email),
      instagram: row.instagram_url || fallback.instagram,
      address: row.address || fallback.address,
      mapsUrl: row.maps_url || fallback.mapsUrl,
      mapsEmbed: row.maps_embed || fallback.mapsEmbed,
      cnpj: row.cnpj || fallback.cnpj,
      hours: row.hours || fallback.hours
    };
  }

  function productImage(imageUrl) {
    const cleanUrl = (imageUrl || "").trim();
    if (!cleanUrl || GENERIC_PRODUCT_IMAGES.has(cleanUrl)) return PRODUCT_PLACEHOLDER_IMAGE;
    return cleanUrl;
  }

  function renderSharedLayout() {
    const header = document.querySelector("[data-header]");
    const footer = document.querySelector("[data-footer]");
    const current = document.body.dataset.page;
    const mapsUrl = state.data.company.mapsUrl || window.BRAVA_SEED.company.mapsUrl;
    const mapsEmbed = state.data.company.mapsEmbed || window.BRAVA_SEED.company.mapsEmbed;

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
                  <a class="footer-icon-link" href="${whatsappLink()}" target="_blank" rel="noreferrer">
                    <span class="footer-link-icon" aria-hidden="true">
                      <svg viewBox="0 0 24 24" focusable="false">
                        <path d="M4.5 19.5l1.2-4.1A8 8 0 1 1 8.4 18l-3.9 1.5z"></path>
                        <path d="M9.2 8.9c.2-.5.4-.7.8-.7h.5c.2 0 .4.1.5.4l.7 1.6c.1.3.1.5-.1.7l-.4.5c.5.9 1.2 1.6 2.2 2.1l.5-.4c.2-.2.5-.2.7-.1l1.5.7c.3.1.4.3.4.6v.4c0 .5-.3.9-.8 1.1-.5.2-1.7.1-3.4-.8-1.8-.9-3.1-2.2-3.9-3.9-.7-1.4-.8-2.1-.6-2.6z"></path>
                      </svg>
                    </span>
                    WhatsApp: ${escapeHtml(state.data.company.whatsappDisplay)}
                  </a>
                  <a class="footer-icon-link" href="tel:${digits(state.data.company.phone)}">
                    <span class="footer-link-icon" aria-hidden="true">
                      <svg viewBox="0 0 24 24" focusable="false">
                        <path d="M6.6 4.5l2 4.4-1.9 1.4c1.2 2.5 3 4.3 5.5 5.5l1.4-1.9 4.4 2c.5.2.8.8.6 1.3l-.8 2c-.2.5-.7.8-1.2.8C9.8 19.8 4.2 14.2 4 7.4c0-.5.3-1 .8-1.2l2-.8c.5-.2 1.1.1 1.3.6z"></path>
                      </svg>
                    </span>
                    Telefone: ${escapeHtml(state.data.company.phone)}
                  </a>
                  <a class="footer-icon-link" href="mailto:${escapeHtml(state.data.company.email)}">
                    <span class="footer-link-icon" aria-hidden="true">
                      <svg viewBox="0 0 24 24" focusable="false">
                        <rect x="3.5" y="5.5" width="17" height="13" rx="2"></rect>
                        <path d="M4.5 7l7.5 6 7.5-6"></path>
                      </svg>
                    </span>
                    E-mail: ${escapeHtml(state.data.company.email)}
                  </a>
                  <a class="footer-social-link" href="${escapeHtml(state.data.company.instagram)}" target="_blank" rel="noreferrer">
                    <span class="footer-social-icon" aria-hidden="true">
                      <svg viewBox="0 0 24 24" focusable="false">
                        <rect x="3" y="3" width="18" height="18" rx="5"></rect>
                        <circle cx="12" cy="12" r="4"></circle>
                        <circle cx="17.5" cy="6.5" r="1.1"></circle>
                      </svg>
                    </span>
                    Instagram
                  </a>
                </div>
              </div>
              <div>
                <h3>Onde nos encontrar</h3>
                <p class="footer-address">
                  <span class="footer-link-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" focusable="false">
                      <path d="M12 21s7-6.1 7-11a7 7 0 0 0-14 0c0 4.9 7 11 7 11z"></path>
                      <circle cx="12" cy="10" r="2.4"></circle>
                    </svg>
                  </span>
                  <span>${escapeHtml(state.data.company.address)}</span>
                </p>
                <p>CNPJ: ${escapeHtml(state.data.company.cnpj)}</p>
                <div class="footer-map">
                  <iframe
                    title="Mapa da Brava Materiais de Limpeza"
                    src="${escapeHtml(mapsEmbed)}"
                    loading="lazy"
                    referrerpolicy="no-referrer-when-downgrade"
                  ></iframe>
                  <a href="${escapeHtml(mapsUrl)}" target="_blank" rel="noreferrer">Ver no Google Maps</a>
                </div>
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

  function bindConversionTracking() {
    document.addEventListener("click", (event) => {
      const link = event.target.closest("a.whatsapp");
      if (!link) return;
      trackContactConversion();
    });
  }

  function trackContactConversion() {
    if (typeof window.gtag !== "function") return;

    window.gtag("event", "conversion", {
      send_to: GOOGLE_ADS_CONTACT_CONVERSION,
      value: 1.0,
      currency: "BRL"
    });
  }

  function renderCartShell() {
    if (document.querySelector("[data-cart-drawer]")) return;

    document.body.insertAdjacentHTML(
      "beforeend",
      `
        <button class="cart-fab" type="button" data-cart-open aria-label="Abrir orçamento">
          <span>Orçamento</span>
          <strong data-cart-count>0</strong>
        </button>
        <div class="cart-backdrop" data-cart-backdrop></div>
        <aside class="cart-drawer" data-cart-drawer aria-label="Carrinho de orçamento">
          <div class="cart-drawer-head">
            <div>
              <span class="eyebrow">Orçamento</span>
              <h2>Produtos escolhidos</h2>
              <p>Revise quantidades, opções e envie tudo direto para a Brava.</p>
            </div>
            <button class="cart-close" type="button" data-cart-close aria-label="Fechar carrinho">×</button>
          </div>
          <div class="cart-items" data-cart-items></div>
          <label class="cart-note">
            Observação para a Brava
            <textarea class="textarea" data-cart-note placeholder="Ex.: entregar em condomínio, confirmar disponibilidade, melhor horário..."></textarea>
          </label>
          <div class="cart-summary">
            <span data-cart-summary>0 produtos no orçamento</span>
            <button class="button secondary" type="button" data-cart-clear>Limpar</button>
          </div>
          <a class="button whatsapp cart-send" data-cart-whatsapp href="${whatsappLink()}" target="_blank" rel="noreferrer">
            Enviar orçamento pelo WhatsApp
          </a>
        </aside>
        <div class="cart-toast" data-cart-toast role="status" aria-live="polite">
          <button class="cart-toast-close" type="button" data-cart-toast-close aria-label="Fechar aviso">x</button>
          <strong data-cart-toast-title>Produto adicionado</strong>
          <span data-cart-toast-text></span>
          <button class="button secondary" type="button" data-cart-open>Ver orçamento</button>
        </div>
      `
    );
  }

  function bindCartActions() {
    document.addEventListener("click", (event) => {
      const openButton = event.target.closest("[data-cart-open]");
      if (openButton) {
        hideCartToast();
        setCartOpen(true);
        return;
      }

      if (event.target.closest("[data-cart-toast-close]")) {
        hideCartToast();
        return;
      }

      if (event.target.closest("[data-cart-close]") || event.target.matches("[data-cart-backdrop]")) {
        setCartOpen(false);
        return;
      }

      const addButton = event.target.closest("[data-add-to-cart]");
      if (addButton) {
        addProductToCart(addButton);
        return;
      }

      const decreaseButton = event.target.closest("[data-quantity-decrease]");
      if (decreaseButton) {
        adjustQuantityInput(decreaseButton, -1);
        return;
      }

      const increaseButton = event.target.closest("[data-quantity-increase]");
      if (increaseButton) {
        adjustQuantityInput(increaseButton, 1);
        return;
      }

      const removeButton = event.target.closest("[data-cart-remove]");
      if (removeButton) {
        removeCartItem(removeButton.dataset.cartRemove);
        return;
      }

      const clearButton = event.target.closest("[data-cart-clear]");
      if (clearButton) {
        clearCart();
      }
    });

    document.addEventListener("change", (event) => {
      const cartQuantity = event.target.closest("[data-cart-quantity]");
      if (cartQuantity) {
        updateCartQuantity(cartQuantity.dataset.cartQuantity, cartQuantity.value);
        return;
      }

      const productQuantity = event.target.closest("[data-product-quantity]");
      if (productQuantity) productQuantity.value = normalizeQuantity(productQuantity.value);
    });

    document.addEventListener("input", (event) => {
      if (event.target.matches("[data-cart-note]")) updateCartWhatsappLink();
    });

    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape") setCartOpen(false);
    });
  }

  function setCartOpen(isOpen) {
    document.body.classList.toggle("cart-open", isOpen);
    document.querySelector("[data-cart-drawer]")?.classList.toggle("open", isOpen);
    document.querySelector("[data-cart-backdrop]")?.classList.toggle("open", isOpen);
  }

  function addProductToCart(button) {
    const productId = button.dataset.addToCart;
    const product = state.data.products.find((item) => item.id === productId);
    if (!product) return;

    const scope = button.closest(".product-card, .modal-panel") || document;
    const variantSelect = scope.querySelector("[data-product-variant-select]");
    const variant = variantSelect ? getProductVariant(product, variantSelect.value) : getProductVariants(product)[0] || null;
    const quantityInput = scope.querySelector("[data-product-quantity]");
    const quantity = normalizeQuantity(quantityInput?.value || 1);
    const cartItem = {
      productId: product.id,
      variantId: variant?.id || "",
      quantity
    };
    const existing = findCartItem(cartItemKey(cartItem));

    if (existing) existing.quantity += quantity;
    else state.cart.push(cartItem);

    if (quantityInput) quantityInput.value = 1;
    if (scope.classList.contains("modal-panel")) document.querySelector("[data-modal]")?.classList.remove("open");
    saveCart();
    renderCart();
    showCartToast(product, quantity, variant);
  }

  function renderCart() {
    const validItems = getValidCartItems();
    if (validItems.length !== state.cart.length) {
      state.cart = validItems.map(({ item }) => item);
      saveCart();
    }

    const quantityTotal = validItems.reduce((total, { item }) => total + normalizeQuantity(item.quantity), 0);
    document.querySelector(".cart-fab")?.classList.toggle("visible", quantityTotal > 0);
    document.querySelectorAll("[data-cart-count]").forEach((target) => {
      target.textContent = String(quantityTotal);
    });

    const summary = document.querySelector("[data-cart-summary]");
    if (summary) summary.textContent = quantityTotal === 1 ? "1 produto no orçamento" : `${quantityTotal} produtos no orçamento`;

    const itemsTarget = document.querySelector("[data-cart-items]");
    if (itemsTarget) {
      itemsTarget.innerHTML = validItems.length
        ? validItems.map(({ item, product }) => cartItemTemplate(item, product)).join("")
        : `<div class="empty cart-empty">Nenhum produto escolhido ainda.</div>`;
    }

    updateCartWhatsappLink();
    if (!quantityTotal) hideCartToast();
  }

  function showCartToast(product, quantity, variant) {
    const toast = document.querySelector("[data-cart-toast]");
    if (!toast) return;

    const optionText = variant ? ` • ${variantLabel(variant)}` : "";
    const textTarget = toast.querySelector("[data-cart-toast-text]");
    if (textTarget) textTarget.textContent = `${quantity}x ${product.name}${optionText}`;

    toast.classList.add("open");
    window.clearTimeout(state.cartToastTimer);
    state.cartToastTimer = window.setTimeout(hideCartToast, 4200);
  }

  function hideCartToast() {
    const toast = document.querySelector("[data-cart-toast]");
    if (!toast) return;

    toast.classList.remove("open");
    window.clearTimeout(state.cartToastTimer);
    state.cartToastTimer = null;
  }

  function updateCartWhatsappLink() {
    const target = document.querySelector("[data-cart-whatsapp]");
    if (!target) return;

    const hasItems = getValidCartItems().length > 0;
    target.href = whatsappLink(cartMessage());
    target.classList.toggle("disabled", !hasItems);
    target.setAttribute("aria-disabled", hasItems ? "false" : "true");
  }

  function cartItemTemplate(item, product) {
    const variant = getCartVariant(item, product);
    const key = cartItemKey(item);

    return `
      <article class="cart-item">
        <img src="${escapeHtml(product.image)}" alt="${escapeHtml(product.name)}">
        <div class="cart-item-body">
          <strong>${escapeHtml(product.name)}</strong>
          ${variant ? `<span>Opção: ${escapeHtml(variantLabel(variant))}</span>` : ""}
          <div class="cart-item-actions">
            ${quantityStepper(item.quantity, `data-cart-quantity="${escapeHtml(key)}" aria-label="Quantidade de ${escapeHtml(product.name)}"`)}
            <button class="cart-remove" type="button" data-cart-remove="${escapeHtml(key)}">Remover</button>
          </div>
        </div>
      </article>
    `;
  }

  function cartMessage() {
    const validItems = getValidCartItems();
    if (!validItems.length) return "Olá, gostaria de fazer um orçamento com a Brava Materiais de Limpeza.";

    const lines = ["Olá, gostaria de fazer um orçamento com a Brava Materiais de Limpeza.", "", "Itens escolhidos:"];
    validItems.forEach(({ item, product }, index) => {
      const variant = getCartVariant(item, product);

      lines.push(`${index + 1}. ${normalizeQuantity(item.quantity)}x ${product.name}`);
      if (variant) lines.push(`   Opção: ${variantLabel(variant)}`);
    });

    const note = document.querySelector("[data-cart-note]")?.value?.trim();
    if (note) lines.push("", `Observação: ${note}`);
    lines.push("", "Pode confirmar disponibilidade e valores, por favor?");

    return lines.join("\n");
  }

  function updateCartQuantity(key, value) {
    const item = findCartItem(key);
    if (!item) return;

    item.quantity = normalizeQuantity(value);
    saveCart();
    renderCart();
  }

  function removeCartItem(key) {
    state.cart = state.cart.filter((item) => cartItemKey(item) !== key);
    saveCart();
    renderCart();
  }

  function clearCart() {
    state.cart = [];
    saveCart();
    renderCart();
  }

  function adjustQuantityInput(button, difference) {
    const scope = button.closest(".quantity-stepper");
    const input = scope?.querySelector("input");
    if (!input) return;

    input.value = Math.max(1, normalizeQuantity(input.value) + difference);
    input.dispatchEvent(new Event("change", { bubbles: true }));
  }

  function quantityStepper(value = 1, inputAttributes = "") {
    return `
      <div class="quantity-stepper">
        <button type="button" data-quantity-decrease aria-label="Diminuir quantidade">-</button>
        <input type="number" min="1" step="1" value="${escapeHtml(normalizeQuantity(value))}" ${inputAttributes}>
        <button type="button" data-quantity-increase aria-label="Aumentar quantidade">+</button>
      </div>
    `;
  }

  function loadCart() {
    try {
      const items = JSON.parse(window.localStorage.getItem(CART_STORAGE_KEY) || "[]");
      if (!Array.isArray(items)) return [];

      return items
        .map((item) => ({
          productId: String(item.productId || ""),
          variantId: item.variantId ? String(item.variantId) : "",
          quantity: normalizeQuantity(item.quantity)
        }))
        .filter((item) => item.productId);
    } catch {
      return [];
    }
  }

  function saveCart() {
    window.localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(state.cart));
  }

  function normalizeQuantity(value) {
    const quantity = Number.parseInt(value, 10);
    return Number.isFinite(quantity) && quantity > 0 ? quantity : 1;
  }

  function cartItemKey(item) {
    return `${item.productId}__${item.variantId || "sem-opcao"}`;
  }

  function findCartItem(key) {
    return state.cart.find((item) => cartItemKey(item) === key);
  }

  function getValidCartItems() {
    return state.cart
      .map((item) => ({ item, product: state.data.products.find((product) => product.id === item.productId) }))
      .filter(({ product }) => product);
  }

  function getCartVariant(item, product) {
    if (!product || !item.variantId) return null;
    return getProductVariant(product, item.variantId);
  }

  function renderHome() {
    renderHero();
    startHeroAutoplay();
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
          <div class="hero-copy">
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
        goToBanner(Number(button.dataset.bannerIndex), true);
      });
    });
  }

  function startHeroAutoplay() {
    if (state.bannerTimer) window.clearInterval(state.bannerTimer);
    if (!state.data.banners || state.data.banners.length < 2) return;

    state.bannerTimer = window.setInterval(() => {
      goToBanner(state.activeBanner + 1);
    }, 6500);
  }

  function goToBanner(index, restartTimer = false) {
    if (!state.data.banners || state.data.banners.length < 2) return;

    state.activeBanner = (index + state.data.banners.length) % state.data.banners.length;
    renderHero();

    if (restartTimer) startHeroAutoplay();
  }

  function renderCategories(selector) {
    const target = document.querySelector(selector);
    if (!target) return;

    const isHomeCategories = selector === "[data-home-categories]";
    if (isHomeCategories && !target.previousElementSibling?.classList.contains("mobile-carousel-hint")) {
      target.insertAdjacentHTML(
        "beforebegin",
        '<div class="mobile-carousel-hint"><span><strong>Categorias</strong><small>Arraste para o lado e veja mais!</small></span></div>'
      );
    }

    target.innerHTML = state.data.categories
      .map(
        (category) => `
          <a class="category-card" href="catalogo.html?categoria=${category.id}">
            <img src="${escapeHtml(category.image)}" alt="${escapeHtml(category.name)}">
            <div class="category-card-body">
              <h3>${escapeHtml(category.name)}</h3>
              <p>${escapeHtml(category.description)}</p>
              <span class="category-card-action">Ver produtos</span>
            </div>
          </a>
        `
      )
      .join("");
  }

  function renderFeaturedProducts(selector) {
    const target = document.querySelector(selector);
    if (!target) return;

    const isHomeFeatured = selector === "[data-featured-products]";
    if (isHomeFeatured && !target.previousElementSibling?.classList.contains("mobile-carousel-hint")) {
      target.insertAdjacentHTML(
        "beforebegin",
        '<div class="mobile-carousel-hint"><span><strong>Produtos em destaque</strong><small>Arraste para o lado e veja mais!</small></span></div>'
      );
    }

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
          <div class="benefit-grid">
            <div class="benefit-card">
              <span class="benefit-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><path d="M4 16V7.5A2.5 2.5 0 0 1 6.5 5H14v11H4z"></path><path d="M14 9h3.5l2.5 3.3V16h-6V9z"></path><circle cx="8" cy="17.5" r="1.5"></circle><circle cx="17" cy="17.5" r="1.5"></circle></svg>
              </span>
              <h3>Entrega rápida</h3>
              <p>Atendimento ágil para ajudar sua rotina a não parar.</p>
            </div>
            <div class="benefit-card">
              <span class="benefit-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><path d="M12 4a7 7 0 0 0-7 7v3"></path><path d="M19 14v-3a7 7 0 0 0-7-7"></path><path d="M5 14h3v4H5z"></path><path d="M16 14h3v4h-3z"></path><path d="M12 20c2 0 3.5-.7 4.2-2"></path></svg>
              </span>
              <h3>Atendimento especializado</h3>
              <p>Orientação direta para encontrar o produto certo.</p>
            </div>
            <div class="benefit-card">
              <span class="benefit-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><path d="M12 3l7 3v5c0 4.5-2.8 8-7 10-4.2-2-7-5.5-7-10V6l7-3z"></path><path d="M9 12l2 2 4-5"></path></svg>
              </span>
              <h3>Produtos de qualidade</h3>
              <p>Itens selecionados para limpeza, higiene e reposição.</p>
            </div>
            <div class="benefit-card">
              <span class="benefit-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><rect x="4" y="4" width="6" height="6" rx="1.5"></rect><rect x="14" y="4" width="6" height="6" rx="1.5"></rect><rect x="4" y="14" width="6" height="6" rx="1.5"></rect><rect x="14" y="14" width="6" height="6" rx="1.5"></rect></svg>
              </span>
              <h3>Grande variedade</h3>
              <p>Categorias organizadas para casas, empresas e condomínios.</p>
            </div>
          </div>
        </div>
        <div class="feature-image">
          <img src="assets/hero-equipment.jpg" alt="Equipamentos de limpeza">
          <div class="feature-image-caption">
            <strong>Catálogo organizado</strong>
            <span>Produtos separados por categoria e orçamento via WhatsApp.</span>
          </div>
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
      products = products.filter((product) => productHasCategory(product, state.filters.category));
    }

    if (query) {
      products = products.filter((product) => {
        const variantText = getProductVariants(product)
          .map((variant) => `${variant.name} ${variant.code || ""} ${variant.price || ""} ${variant.description || ""}`)
          .join(" ");
        const haystack = normalize(
          `${product.name} ${product.description} ${product.code || ""} ${getProductCategoryNames(product).join(" ")} ${variantText}`
        );
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
    const categoryName = getProductPrimaryCategoryName(product);
    const variants = getProductVariants(product);
    const selectedVariant = variants[0] || null;
    return `
      <article class="product-card">
        <div class="product-media">
          ${product.featured ? '<span class="badge">Destaque</span>' : ""}
          <img src="${escapeHtml(product.image)}" alt="${escapeHtml(product.name)}" loading="lazy">
        </div>
        <div class="product-body">
          <div class="product-topline">
            <span class="product-category">${escapeHtml(categoryName)}</span>
            ${product.code ? `<span class="product-code">${escapeHtml(product.code)}</span>` : ""}
          </div>
          <h3 class="product-title">${escapeHtml(product.name)}</h3>
          <p class="product-description">${escapeHtml(product.description || "Produto disponível para orçamento.")}</p>
          ${variantPicker(product, selectedVariant)}
          <div class="product-footer">
            <div class="price" data-product-price-label>${escapeHtml(productPriceLabel(product, selectedVariant))}</div>
            ${quantityStepper(1, `data-product-quantity="${escapeHtml(product.id)}" aria-label="Quantidade de ${escapeHtml(product.name)}"`)}
            <div class="product-actions">
              <button class="button secondary" type="button" data-product-detail="${escapeHtml(product.id)}">Ver detalhes</button>
              <button class="button cart-add-button" type="button" data-add-to-cart="${escapeHtml(product.id)}">Adicionar</button>
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
    root.querySelectorAll("[data-product-variant-select]").forEach((select) => {
      updateVariantTarget(select);
      select.addEventListener("change", () => updateVariantTarget(select));
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
    const variants = getProductVariants(product);
    const selectedVariant = variants[0] || null;

    modal.innerHTML = `
      <div class="modal-panel" role="dialog" aria-modal="true" aria-label="${escapeHtml(product.name)}">
        <div class="modal-grid">
          <div class="modal-image">
            <img src="${escapeHtml(product.image)}" alt="${escapeHtml(product.name)}">
          </div>
          <div class="modal-content">
            <button class="modal-close" type="button" data-modal-close aria-label="Fechar">×</button>
            <span class="product-category">${escapeHtml(getProductCategoryNames(product).join(", "))}</span>
            <h2>${escapeHtml(product.name)}</h2>
            <p>${escapeHtml(product.description || "Produto disponível para orçamento.")}</p>
            <p><strong>Código:</strong> ${escapeHtml(product.code || "Não informado")}</p>
            ${variantPicker(product, selectedVariant)}
            <p><strong>Valor:</strong> <span data-product-price-label>${escapeHtml(productPriceLabel(product, selectedVariant))}</span></p>
            ${quantityStepper(1, `data-product-quantity="${escapeHtml(product.id)}" aria-label="Quantidade de ${escapeHtml(product.name)}"`)}
            <div class="hero-actions">
              <button class="button cart-add-button" type="button" data-add-to-cart="${escapeHtml(product.id)}">Adicionar ao orçamento</button>
              <button class="button secondary" type="button" data-modal-close>Fechar</button>
            </div>
          </div>
        </div>
      </div>
    `;

    modal.classList.add("open");
    bindProductButtons(modal);
  }

  function variantPicker(product, selectedVariant) {
    const variants = getProductVariants(product);
    if (!variants.length) return "";

    if (variants.length === 1) {
      return `
        <div class="variant-picker variant-picker-static">
          <span>Opção</span>
          <strong>${escapeHtml(variantLabel(selectedVariant || variants[0]))}</strong>
        </div>
      `;
    }

    return `
      <label class="variant-picker">
        Escolha a opção
        <select class="select" data-product-variant-select="${escapeHtml(product.id)}">
          ${variants
            .map(
              (variant) =>
                `<option value="${escapeHtml(variant.id)}" ${selectedVariant?.id === variant.id ? "selected" : ""}>${escapeHtml(
                  variantLabel(variant)
                )}</option>`
            )
            .join("")}
        </select>
      </label>
    `;
  }

  function updateVariantTarget(select) {
    const product = state.data.products.find((item) => item.id === select.dataset.productVariantSelect);
    if (!product) return;

    const variant = getProductVariant(product, select.value);
    const scope = select.closest(".product-card, .modal-panel") || document;
    const priceTarget = scope.querySelector("[data-product-price-label]");
    const whatsappTarget = scope.querySelector("[data-product-whatsapp]");

    if (priceTarget) priceTarget.textContent = productPriceLabel(product, variant);
    if (whatsappTarget) whatsappTarget.href = productWhatsappLink(product, variant);
  }

  function getProductVariants(product) {
    return (product.variants || []).filter((variant) => variant && variant.active !== false);
  }

  function getProductVariant(product, variantId) {
    return getProductVariants(product).find((variant) => variant.id === variantId) || getProductVariants(product)[0] || null;
  }

  function productPriceLabel(product, variant) {
    if (variant?.price) return variant.price;
    return product.price || "Sob consulta";
  }

  function variantLabel(variant) {
    if (!variant) return "Opção do produto";
    return variant.name || "Opção do produto";
  }

  function sortProducts(products, sort) {
    const copy = [...products];
    if (sort === "name") copy.sort((a, b) => a.name.localeCompare(b.name));
    if (sort === "category") copy.sort((a, b) => getProductPrimaryCategoryName(a).localeCompare(getProductPrimaryCategoryName(b)));
    if (sort === "featured") copy.sort((a, b) => Number(b.featured) - Number(a.featured) || a.name.localeCompare(b.name));
    return copy;
  }

  function getProductCategoryIds(product) {
    if (Array.isArray(product.categoryIds) && product.categoryIds.length) return product.categoryIds;
    return product.categoryId ? [product.categoryId] : [];
  }

  function productHasCategory(product, categoryId) {
    return getProductCategoryIds(product).includes(categoryId);
  }

  function getProductCategoryNames(product) {
    const names = getProductCategoryIds(product).map(getCategoryName).filter(Boolean);
    return names.length ? uniqueValues(names) : ["Sem categoria"];
  }

  function getProductPrimaryCategoryName(product) {
    return getProductCategoryNames(product)[0] || "Sem categoria";
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

  function productWhatsappLink(product, variant) {
    const optionText = variant
      ? `\nOpção escolhida: ${variant.name}${variant.code ? `\nCódigo da opção: ${variant.code}` : ""}${
          variant.price ? `\nValor informado: ${variant.price}` : ""
        }${variant.description ? `\nDetalhe: ${variant.description}` : ""}`
      : "";
    const message = `Olá, gostaria de fazer um orçamento do produto: ${product.name}${product.code ? ` (${product.code})` : ""}.${optionText}`;
    return whatsappLink(message);
  }

  function normalizeCompanyEmail(email) {
    const value = String(email || "").trim();
    if (!value || value.toLowerCase() === "materiais.brava@gmail.com") return OFFICIAL_EMAIL;
    return value;
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

  function uniqueValues(values) {
    return [...new Set(values)];
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
