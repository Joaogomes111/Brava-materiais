(function () {
  const STORAGE_KEY = "brava_catalog_data_v6";
  const SESSION_KEY = "brava_admin_demo_session";
  const PLACEHOLDER_IMAGE = "assets/cleaning-bottles.jpg";

  let data = loadData();

  document.addEventListener("DOMContentLoaded", init);

  function init() {
    bindLogin();
    if (sessionStorage.getItem(SESSION_KEY) === "active") showAdmin();
  }

  function bindLogin() {
    const form = qs("[data-login-form]");
    if (!form) return;

    form.addEventListener("submit", (event) => {
      event.preventDefault();
      sessionStorage.setItem(SESSION_KEY, "active");
      showAdmin();
    });
  }

  function showAdmin() {
    qs("[data-login-screen]")?.classList.add("hidden");
    qs("[data-admin-shell]")?.classList.remove("hidden");

    bindTabs();
    bindActions();
    renderAll();
  }

  function bindTabs() {
    qsa("[data-admin-tab]").forEach((button) => {
      button.addEventListener("click", () => {
        qsa("[data-admin-tab]").forEach((item) => item.classList.remove("active"));
        qsa("[data-panel]").forEach((panel) => panel.classList.remove("active"));
        button.classList.add("active");
        qs(`[data-panel="${button.dataset.adminTab}"]`)?.classList.add("active");
      });
    });
  }

  function bindActions() {
    qs("[data-logout]")?.addEventListener("click", () => {
      sessionStorage.removeItem(SESSION_KEY);
      window.location.reload();
    });

    qs("[data-reset-demo]")?.addEventListener("click", () => {
      if (!window.confirm("Restaurar os dados originais da demonstração?")) return;
      localStorage.removeItem(STORAGE_KEY);
      data = structuredClone(window.BRAVA_SEED);
      renderAll();
      notify("Dados originais restaurados.");
    });

    qs("[data-product-form]")?.addEventListener("submit", saveProduct);
    qs("[data-product-clear]")?.addEventListener("click", clearProductForm);
    qs("[data-product-file]")?.addEventListener("change", (event) => handleImageFile(event, "[data-product-image]"));

    qs("[data-category-form]")?.addEventListener("submit", saveCategory);
    qs("[data-category-clear]")?.addEventListener("click", clearCategoryForm);
    qs("[data-category-file]")?.addEventListener("change", (event) => handleImageFile(event, "[data-category-image]"));

    qs("[data-banner-form]")?.addEventListener("submit", saveBanner);
    qs("[data-banner-clear]")?.addEventListener("click", clearBannerForm);
    qs("[data-banner-file]")?.addEventListener("change", (event) => handleImageFile(event, "[data-banner-image]"));

    qs("[data-company-form]")?.addEventListener("submit", saveCompany);
  }

  function renderAll() {
    renderCategorySelect();
    renderProducts();
    renderCategories();
    renderBanners();
    fillCompanyForm();
  }

  function loadData() {
    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      if (stored) return mergeSeedData(JSON.parse(stored));
    } catch (error) {
      console.warn("Não foi possível carregar dados locais.", error);
    }
    return structuredClone(window.BRAVA_SEED);
  }

  function mergeSeedData(storedData) {
    const seed = structuredClone(window.BRAVA_SEED);
    return {
      ...seed,
      ...storedData,
      company: {
        ...seed.company,
        ...(storedData.company || {})
      },
      banners: storedData.banners?.length ? storedData.banners : seed.banners,
      categories: storedData.categories?.length ? storedData.categories : seed.categories,
      products: storedData.products?.length ? storedData.products : seed.products
    };
  }

  function persist() {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
  }

  function renderCategorySelect() {
    const select = qs("[data-product-category]");
    if (!select) return;
    select.innerHTML = data.categories.map((category) => `<option value="${category.id}">${escapeHtml(category.name)}</option>`).join("");
  }

  function renderProducts() {
    const target = qs("[data-product-list]");
    if (!target) return;

    target.innerHTML = data.products.length
      ? data.products
          .map(
            (product) => `
              <div class="admin-list-item">
                <img src="${escapeHtml(product.image || PLACEHOLDER_IMAGE)}" alt="${escapeHtml(product.name)}">
                <div>
                  <strong>${escapeHtml(product.name)}</strong>
                  <div style="color: var(--muted); font-size: 0.9rem;">
                    ${escapeHtml(getCategoryName(product.categoryId))} ${product.price ? `| ${escapeHtml(product.price)}` : "| Sob consulta"}
                    ${product.active ? "" : "| Inativo"}
                  </div>
                </div>
                <div class="admin-list-actions">
                  <button class="small-button" type="button" data-edit-product="${product.id}">Editar</button>
                  <button class="small-button danger" type="button" data-delete-product="${product.id}">Excluir</button>
                </div>
              </div>
            `
          )
          .join("")
      : `<div class="empty">Nenhum produto cadastrado.</div>`;

    qsa("[data-edit-product]").forEach((button) => button.addEventListener("click", () => editProduct(button.dataset.editProduct)));
    qsa("[data-delete-product]").forEach((button) => button.addEventListener("click", () => deleteProduct(button.dataset.deleteProduct)));
  }

  function saveProduct(event) {
    event.preventDefault();

    const idField = qs("[data-product-id]");
    const existingId = idField.value;
    const name = value("[data-product-name]");
    const product = {
      id: existingId || slugify(name),
      name,
      code: value("[data-product-code]"),
      price: value("[data-product-price]"),
      categoryId: value("[data-product-category]"),
      image: value("[data-product-image]") || PLACEHOLDER_IMAGE,
      description: value("[data-product-description]"),
      featured: qs("[data-product-featured]").checked,
      active: qs("[data-product-active]").checked
    };

    if (existingId) {
      data.products = data.products.map((item) => (item.id === existingId ? product : item));
      notify("Produto atualizado.");
    } else {
      if (data.products.some((item) => item.id === product.id)) product.id = `${product.id}-${Date.now()}`;
      data.products.unshift(product);
      notify("Produto adicionado.");
    }

    persist();
    clearProductForm();
    renderProducts();
  }

  function editProduct(id) {
    const product = data.products.find((item) => item.id === id);
    if (!product) return;

    setValue("[data-product-id]", product.id);
    setValue("[data-product-name]", product.name);
    setValue("[data-product-code]", product.code);
    setValue("[data-product-price]", product.price);
    setValue("[data-product-category]", product.categoryId);
    setValue("[data-product-image]", product.image);
    setValue("[data-product-description]", product.description);
    qs("[data-product-featured]").checked = Boolean(product.featured);
    qs("[data-product-active]").checked = product.active !== false;
    qs("[data-product-form] h3").textContent = "Editar produto";
    qs("[data-product-name]").focus();
  }

  function deleteProduct(id) {
    const product = data.products.find((item) => item.id === id);
    if (!product) return;
    if (!window.confirm(`Excluir "${product.name}"?`)) return;

    data.products = data.products.filter((item) => item.id !== id);
    persist();
    renderProducts();
    notify("Produto excluído.");
  }

  function clearProductForm() {
    qs("[data-product-form]").reset();
    setValue("[data-product-id]", "");
    qs("[data-product-active]").checked = true;
    qs("[data-product-form] h3").textContent = "Novo produto";
  }

  function handleImageFile(event, targetSelector) {
    const file = event.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = () => {
      setValue(targetSelector, reader.result);
    };
    reader.readAsDataURL(file);
  }

  function renderCategories() {
    const target = qs("[data-category-list]");
    if (!target) return;

    target.innerHTML = data.categories.length
      ? data.categories
          .map(
            (category) => `
              <div class="admin-list-item">
                <img src="${escapeHtml(category.image || PLACEHOLDER_IMAGE)}" alt="${escapeHtml(category.name)}">
                <div>
                  <strong>${escapeHtml(category.name)}</strong>
                  <div style="color: var(--muted); font-size: 0.9rem;">${countProducts(category.id)} produtos vinculados</div>
                </div>
                <div class="admin-list-actions">
                  <button class="small-button" type="button" data-edit-category="${category.id}">Editar</button>
                  <button class="small-button danger" type="button" data-delete-category="${category.id}">Excluir</button>
                </div>
              </div>
            `
          )
          .join("")
      : `<div class="empty">Nenhuma categoria cadastrada.</div>`;

    qsa("[data-edit-category]").forEach((button) => button.addEventListener("click", () => editCategory(button.dataset.editCategory)));
    qsa("[data-delete-category]").forEach((button) => button.addEventListener("click", () => deleteCategory(button.dataset.deleteCategory)));
  }

  function saveCategory(event) {
    event.preventDefault();

    const existingId = value("[data-category-id]");
    const name = value("[data-category-name]");
    const category = {
      id: existingId || slugify(name),
      name,
      image: value("[data-category-image]") || PLACEHOLDER_IMAGE,
      description: value("[data-category-description]")
    };

    if (existingId) {
      data.categories = data.categories.map((item) => (item.id === existingId ? category : item));
      notify("Categoria atualizada.");
    } else {
      if (data.categories.some((item) => item.id === category.id)) category.id = `${category.id}-${Date.now()}`;
      data.categories.push(category);
      notify("Categoria adicionada.");
    }

    persist();
    clearCategoryForm();
    renderCategories();
    renderCategorySelect();
  }

  function editCategory(id) {
    const category = data.categories.find((item) => item.id === id);
    if (!category) return;

    setValue("[data-category-id]", category.id);
    setValue("[data-category-name]", category.name);
    setValue("[data-category-image]", category.image);
    setValue("[data-category-description]", category.description);
    qs("[data-category-form] h3").textContent = "Editar categoria";
  }

  function deleteCategory(id) {
    if (countProducts(id) > 0) {
      window.alert("Não é possível excluir uma categoria com produtos vinculados. Mova ou exclua os produtos primeiro.");
      return;
    }
    const category = data.categories.find((item) => item.id === id);
    if (!category) return;
    if (!window.confirm(`Excluir categoria "${category.name}"?`)) return;

    data.categories = data.categories.filter((item) => item.id !== id);
    persist();
    renderCategories();
    renderCategorySelect();
    notify("Categoria excluída.");
  }

  function clearCategoryForm() {
    qs("[data-category-form]").reset();
    setValue("[data-category-id]", "");
    qs("[data-category-form] h3").textContent = "Categoria";
  }

  function renderBanners() {
    const target = qs("[data-banner-list]");
    if (!target) return;

    target.innerHTML = data.banners.length
      ? data.banners
          .map(
            (banner) => `
              <div class="admin-list-item">
                <img src="${escapeHtml(banner.image || PLACEHOLDER_IMAGE)}" alt="${escapeHtml(banner.title)}">
                <div>
                  <strong>${escapeHtml(banner.title)}</strong>
                  <div style="color: var(--muted); font-size: 0.9rem;">${escapeHtml(banner.subtitle)}</div>
                </div>
                <div class="admin-list-actions">
                  <button class="small-button" type="button" data-edit-banner="${banner.id}">Editar</button>
                  <button class="small-button danger" type="button" data-delete-banner="${banner.id}">Excluir</button>
                </div>
              </div>
            `
          )
          .join("")
      : `<div class="empty">Nenhum banner cadastrado.</div>`;

    qsa("[data-edit-banner]").forEach((button) => button.addEventListener("click", () => editBanner(button.dataset.editBanner)));
    qsa("[data-delete-banner]").forEach((button) => button.addEventListener("click", () => deleteBanner(button.dataset.deleteBanner)));
  }

  function saveBanner(event) {
    event.preventDefault();

    const existingId = value("[data-banner-id]");
    const title = value("[data-banner-title]");
    const banner = {
      id: existingId || slugify(title),
      title,
      subtitle: value("[data-banner-subtitle]"),
      text: value("[data-banner-text]"),
      cta: value("[data-banner-cta]"),
      image: value("[data-banner-image]") || PLACEHOLDER_IMAGE
    };

    if (existingId) {
      data.banners = data.banners.map((item) => (item.id === existingId ? banner : item));
      notify("Banner atualizado.");
    } else {
      if (data.banners.some((item) => item.id === banner.id)) banner.id = `${banner.id}-${Date.now()}`;
      data.banners.push(banner);
      notify("Banner adicionado.");
    }

    persist();
    clearBannerForm();
    renderBanners();
  }

  function editBanner(id) {
    const banner = data.banners.find((item) => item.id === id);
    if (!banner) return;

    setValue("[data-banner-id]", banner.id);
    setValue("[data-banner-title]", banner.title);
    setValue("[data-banner-subtitle]", banner.subtitle);
    setValue("[data-banner-text]", banner.text);
    setValue("[data-banner-cta]", banner.cta);
    setValue("[data-banner-image]", banner.image);
    qs("[data-banner-form] h3").textContent = "Editar banner";
  }

  function deleteBanner(id) {
    if (data.banners.length <= 1) {
      window.alert("Mantenha pelo menos um banner cadastrado.");
      return;
    }
    const banner = data.banners.find((item) => item.id === id);
    if (!banner) return;
    if (!window.confirm(`Excluir banner "${banner.title}"?`)) return;

    data.banners = data.banners.filter((item) => item.id !== id);
    persist();
    renderBanners();
    notify("Banner excluído.");
  }

  function clearBannerForm() {
    qs("[data-banner-form]").reset();
    setValue("[data-banner-id]", "");
    qs("[data-banner-form] h3").textContent = "Banner da home";
  }

  function fillCompanyForm() {
    const company = data.company;
    setValue("[data-company-name]", company.name);
    setValue("[data-company-slogan]", company.slogan);
    setValue("[data-company-description]", company.description);
    setValue("[data-company-whatsapp]", company.whatsapp);
    setValue("[data-company-whatsapp-display]", company.whatsappDisplay);
    setValue("[data-company-phone]", company.phone);
    setValue("[data-company-email]", company.email);
    setValue("[data-company-instagram]", company.instagram);
    setValue("[data-company-address]", company.address);
    setValue("[data-company-cnpj]", company.cnpj);
    setValue("[data-company-hours]", company.hours);
  }

  function saveCompany(event) {
    event.preventDefault();
    data.company = {
      ...data.company,
      name: value("[data-company-name]"),
      slogan: value("[data-company-slogan]"),
      description: value("[data-company-description]"),
      whatsapp: value("[data-company-whatsapp]"),
      whatsappDisplay: value("[data-company-whatsapp-display]"),
      phone: value("[data-company-phone]"),
      email: value("[data-company-email]"),
      instagram: value("[data-company-instagram]"),
      address: value("[data-company-address]"),
      cnpj: value("[data-company-cnpj]"),
      hours: value("[data-company-hours]")
    };
    persist();
    notify("Dados da empresa atualizados.");
  }

  function countProducts(categoryId) {
    return data.products.filter((product) => product.categoryId === categoryId).length;
  }

  function getCategoryName(id) {
    return data.categories.find((category) => category.id === id)?.name || "Sem categoria";
  }

  function notify(message) {
    const notice = document.createElement("div");
    notice.className = "notice";
    notice.textContent = message;
    notice.style.position = "fixed";
    notice.style.right = "18px";
    notice.style.bottom = "18px";
    notice.style.zIndex = "120";
    notice.style.boxShadow = "var(--shadow)";
    document.body.appendChild(notice);
    window.setTimeout(() => notice.remove(), 2600);
  }

  function qs(selector) {
    return document.querySelector(selector);
  }

  function qsa(selector) {
    return Array.from(document.querySelectorAll(selector));
  }

  function value(selector) {
    return qs(selector)?.value.trim() || "";
  }

  function setValue(selector, nextValue) {
    const field = qs(selector);
    if (field) field.value = nextValue || "";
  }

  function slugify(value) {
    return String(value || "item")
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "")
      .slice(0, 80);
  }

  function escapeHtml(value) {
    return String(value ?? "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }
})();
