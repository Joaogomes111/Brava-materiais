(function () {
  const client = window.bravaSupabase;
  const bucket = window.BRAVA_SUPABASE_CONFIG?.bucket || "catalog";
  const PLACEHOLDER_IMAGE = "assets/cleaning-bottles.jpg";

  let data = {
    company: structuredClone(window.BRAVA_SEED.company),
    categories: [],
    products: [],
    banners: []
  };
  let tabsBound = false;
  let actionsBound = false;

  document.addEventListener("DOMContentLoaded", () => {
    init().catch((error) => showLoginMessage(readableError(error)));
  });

  async function init() {
    bindLogin();
    if (!client) {
      showLoginMessage("Não foi possível carregar a conexão com o Supabase. Atualize a página.");
      return;
    }

    const { data: sessionData, error } = await client.auth.getSession();
    if (error) throw error;
    if (sessionData.session?.user) await enterAdmin(sessionData.session.user);
  }

  function bindLogin() {
    const form = qs("[data-login-form]");
    if (!form) return;

    form.addEventListener("submit", async (event) => {
      event.preventDefault();
      clearLoginMessage();
      setFormBusy(form, true, "Entrando...");

      try {
        if (!client) throw new Error("Conexão com o Supabase indisponível.");
        const { data: authData, error } = await client.auth.signInWithPassword({
          email: value("[data-login-email]"),
          password: qs("[data-login-password]")?.value || ""
        });
        if (error) throw error;
        await enterAdmin(authData.user);
      } catch (error) {
        showLoginMessage(readableError(error));
      } finally {
        setFormBusy(form, false);
      }
    });
  }

  async function enterAdmin(user) {
    if (!user || !(await userIsAdmin(user.id))) {
      await client.auth.signOut();
      throw new Error("Este usuário não possui permissão de administrador.");
    }

    qs("[data-login-screen]")?.classList.add("hidden");
    qs("[data-admin-shell]")?.classList.remove("hidden");
    bindTabs();
    bindActions();
    await refreshData();
  }

  async function userIsAdmin(userId) {
    const { data: profile, error } = await client.from("admin_profiles").select("id").eq("id", userId).maybeSingle();
    if (error) throw error;
    return Boolean(profile);
  }

  function bindTabs() {
    if (tabsBound) return;
    tabsBound = true;

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
    if (actionsBound) return;
    actionsBound = true;

    qs("[data-logout]")?.addEventListener("click", async () => {
      await client.auth.signOut();
      window.location.reload();
    });

    qs("[data-product-form]")?.addEventListener("submit", saveProduct);
    qs("[data-product-clear]")?.addEventListener("click", clearProductForm);
    qs("[data-category-form]")?.addEventListener("submit", saveCategory);
    qs("[data-category-clear]")?.addEventListener("click", clearCategoryForm);
    qs("[data-banner-form]")?.addEventListener("submit", saveBanner);
    qs("[data-banner-clear]")?.addEventListener("click", clearBannerForm);
    qs("[data-company-form]")?.addEventListener("submit", saveCompany);
  }

  async function refreshData() {
    const [companyResult, categoriesResult, productsResult, bannersResult] = await Promise.all([
      client.from("company_settings").select("*").eq("id", true).single(),
      client.from("categories").select("*").order("sort_order"),
      client.from("products").select("*").order("sort_order"),
      client.from("banners").select("*").order("sort_order")
    ]);

    const failed = [companyResult, categoriesResult, productsResult, bannersResult].find((result) => result.error);
    if (failed) throw failed.error;

    const categories = (categoriesResult.data || []).map((row) => ({
      id: row.slug,
      dbId: row.id,
      name: row.name,
      description: row.description || "",
      image: row.image_url || PLACEHOLDER_IMAGE,
      sortOrder: row.sort_order || 0
    }));
    const categoryByDbId = new Map(categories.map((category) => [category.dbId, category.id]));

    data = {
      company: mapCompany(companyResult.data),
      categories,
      products: (productsResult.data || []).map((row) => ({
        id: row.slug,
        dbId: row.id,
        name: row.name,
        code: row.code || "",
        price: row.price_label || "",
        categoryId: categoryByDbId.get(row.category_id) || "",
        image: row.image_url || PLACEHOLDER_IMAGE,
        description: row.description || "",
        featured: Boolean(row.featured),
        active: row.active !== false,
        sortOrder: row.sort_order || 0
      })),
      banners: (bannersResult.data || []).map((row) => ({
        id: row.id,
        title: row.title,
        subtitle: row.subtitle || "",
        text: row.body || "",
        cta: row.cta_label || "Chamar no WhatsApp",
        ctaUrl: row.cta_url || "",
        image: row.image_url || "assets/hero-cleaning.jpg",
        sortOrder: row.sort_order || 0,
        active: row.is_active !== false
      }))
    };

    renderAll();
  }

  function mapCompany(row) {
    const fallback = window.BRAVA_SEED.company;
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

  function renderAll() {
    renderCategorySelect();
    renderProducts();
    renderCategories();
    renderBanners();
    fillCompanyForm();
  }

  function renderCategorySelect() {
    const select = qs("[data-product-category]");
    if (!select) return;
    select.innerHTML = data.categories
      .map((category) => `<option value="${escapeHtml(category.id)}">${escapeHtml(category.name)}</option>`)
      .join("");
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
                  <button class="small-button" type="button" data-edit-product="${escapeHtml(product.id)}">Editar</button>
                  <button class="small-button danger" type="button" data-delete-product="${escapeHtml(product.id)}">Excluir</button>
                </div>
              </div>
            `
          )
          .join("")
      : `<div class="empty">Nenhum produto cadastrado.</div>`;

    qsa("[data-edit-product]").forEach((button) => button.addEventListener("click", () => editProduct(button.dataset.editProduct)));
    qsa("[data-delete-product]").forEach((button) => button.addEventListener("click", () => deleteProduct(button.dataset.deleteProduct)));
  }

  async function saveProduct(event) {
    event.preventDefault();
    const form = event.currentTarget;
    await runFormAction(form, "Salvando...", async () => {
      const existingSlug = value("[data-product-id]");
      const existing = data.products.find((item) => item.id === existingSlug);
      const name = value("[data-product-name]");
      const category = data.categories.find((item) => item.id === value("[data-product-category]"));
      if (!category) throw new Error("Selecione uma categoria válida.");

      const imageUrl = await resolveImage(
        "[data-product-image]",
        "[data-product-file]",
        "products",
        existing?.image || PLACEHOLDER_IMAGE
      );
      const payload = {
        slug: existingSlug || uniqueSlug(name, data.products),
        name,
        code: value("[data-product-code]") || null,
        price_label: value("[data-product-price]") || null,
        category_id: category.dbId,
        image_url: imageUrl,
        description: value("[data-product-description]"),
        featured: qs("[data-product-featured]").checked,
        active: qs("[data-product-active]").checked,
        sort_order: existing?.sortOrder || data.products.length + 1
      };

      const query = existingSlug
        ? client.from("products").update(payload).eq("slug", existingSlug)
        : client.from("products").insert(payload);
      const { error } = await query;
      if (error) throw error;
      clearProductForm();
      await refreshData();
      notify(existingSlug ? "Produto atualizado." : "Produto adicionado.");
    });
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

  async function deleteProduct(id) {
    const product = data.products.find((item) => item.id === id);
    if (!product || !window.confirm(`Excluir "${product.name}"?`)) return;

    try {
      const { error } = await client.from("products").delete().eq("slug", id);
      if (error) throw error;
      await refreshData();
      notify("Produto excluído.");
    } catch (error) {
      notify(readableError(error), true);
    }
  }

  function clearProductForm() {
    qs("[data-product-form]")?.reset();
    setValue("[data-product-id]", "");
    qs("[data-product-active]").checked = true;
    qs("[data-product-form] h3").textContent = "Novo produto";
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
                  <button class="small-button" type="button" data-edit-category="${escapeHtml(category.id)}">Editar</button>
                  <button class="small-button danger" type="button" data-delete-category="${escapeHtml(category.id)}">Excluir</button>
                </div>
              </div>
            `
          )
          .join("")
      : `<div class="empty">Nenhuma categoria cadastrada.</div>`;

    qsa("[data-edit-category]").forEach((button) => button.addEventListener("click", () => editCategory(button.dataset.editCategory)));
    qsa("[data-delete-category]").forEach((button) => button.addEventListener("click", () => deleteCategory(button.dataset.deleteCategory)));
  }

  async function saveCategory(event) {
    event.preventDefault();
    const form = event.currentTarget;
    await runFormAction(form, "Salvando...", async () => {
      const existingSlug = value("[data-category-id]");
      const existing = data.categories.find((item) => item.id === existingSlug);
      const name = value("[data-category-name]");
      const imageUrl = await resolveImage(
        "[data-category-image]",
        "[data-category-file]",
        "categories",
        existing?.image || PLACEHOLDER_IMAGE
      );
      const payload = {
        slug: existingSlug || uniqueSlug(name, data.categories),
        name,
        description: value("[data-category-description]"),
        image_url: imageUrl,
        sort_order: existing?.sortOrder || data.categories.length + 1,
        is_active: true
      };

      const query = existingSlug
        ? client.from("categories").update(payload).eq("slug", existingSlug)
        : client.from("categories").insert(payload);
      const { error } = await query;
      if (error) throw error;
      clearCategoryForm();
      await refreshData();
      notify(existingSlug ? "Categoria atualizada." : "Categoria adicionada.");
    });
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

  async function deleteCategory(id) {
    if (countProducts(id) > 0) {
      window.alert("Não é possível excluir uma categoria com produtos vinculados. Mova ou exclua os produtos primeiro.");
      return;
    }
    const category = data.categories.find((item) => item.id === id);
    if (!category || !window.confirm(`Excluir categoria "${category.name}"?`)) return;

    try {
      const { error } = await client.from("categories").delete().eq("slug", id);
      if (error) throw error;
      await refreshData();
      notify("Categoria excluída.");
    } catch (error) {
      notify(readableError(error), true);
    }
  }

  function clearCategoryForm() {
    qs("[data-category-form]")?.reset();
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
                  <button class="small-button" type="button" data-edit-banner="${escapeHtml(banner.id)}">Editar</button>
                  <button class="small-button danger" type="button" data-delete-banner="${escapeHtml(banner.id)}">Excluir</button>
                </div>
              </div>
            `
          )
          .join("")
      : `<div class="empty">Nenhum banner cadastrado.</div>`;

    qsa("[data-edit-banner]").forEach((button) => button.addEventListener("click", () => editBanner(button.dataset.editBanner)));
    qsa("[data-delete-banner]").forEach((button) => button.addEventListener("click", () => deleteBanner(button.dataset.deleteBanner)));
  }

  async function saveBanner(event) {
    event.preventDefault();
    const form = event.currentTarget;
    await runFormAction(form, "Salvando...", async () => {
      const existingId = value("[data-banner-id]");
      const existing = data.banners.find((item) => item.id === existingId);
      const imageUrl = await resolveImage(
        "[data-banner-image]",
        "[data-banner-file]",
        "banners",
        existing?.image || "assets/hero-cleaning.jpg"
      );
      const payload = {
        title: value("[data-banner-title]"),
        subtitle: value("[data-banner-subtitle]"),
        body: value("[data-banner-text]"),
        cta_label: value("[data-banner-cta]"),
        cta_url: existing?.ctaUrl || `https://wa.me/${digits(data.company.whatsapp)}`,
        image_url: imageUrl,
        sort_order: existing?.sortOrder || data.banners.length + 1,
        is_active: true
      };

      const query = existingId
        ? client.from("banners").update(payload).eq("id", existingId)
        : client.from("banners").insert(payload);
      const { error } = await query;
      if (error) throw error;
      clearBannerForm();
      await refreshData();
      notify(existingId ? "Banner atualizado." : "Banner adicionado.");
    });
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

  async function deleteBanner(id) {
    if (data.banners.length <= 1) {
      window.alert("Mantenha pelo menos um banner cadastrado.");
      return;
    }
    const banner = data.banners.find((item) => item.id === id);
    if (!banner || !window.confirm(`Excluir banner "${banner.title}"?`)) return;

    try {
      const { error } = await client.from("banners").delete().eq("id", id);
      if (error) throw error;
      await refreshData();
      notify("Banner excluído.");
    } catch (error) {
      notify(readableError(error), true);
    }
  }

  function clearBannerForm() {
    qs("[data-banner-form]")?.reset();
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

  async function saveCompany(event) {
    event.preventDefault();
    const form = event.currentTarget;
    await runFormAction(form, "Salvando...", async () => {
      const payload = {
        name: value("[data-company-name]"),
        short_name: data.company.shortName,
        slogan: value("[data-company-slogan]"),
        description: value("[data-company-description]"),
        logo_url: data.company.logo,
        whatsapp: value("[data-company-whatsapp]"),
        whatsapp_display: value("[data-company-whatsapp-display]"),
        whatsapp_legacy_link: data.company.whatsappLegacyLink,
        phone: value("[data-company-phone]"),
        email: value("[data-company-email]"),
        instagram_url: value("[data-company-instagram]"),
        address: value("[data-company-address]"),
        maps_url: data.company.mapsUrl,
        maps_embed: data.company.mapsEmbed,
        cnpj: value("[data-company-cnpj]"),
        hours: value("[data-company-hours]")
      };

      const { error } = await client.from("company_settings").update(payload).eq("id", true);
      if (error) throw error;
      await refreshData();
      notify("Dados da empresa atualizados.");
    });
  }

  async function resolveImage(urlSelector, fileSelector, folder, fallback) {
    const file = qs(fileSelector)?.files?.[0];
    if (!file) return value(urlSelector) || fallback;
    if (!file.type.startsWith("image/")) throw new Error("Selecione um arquivo de imagem.");
    if (file.size > 8 * 1024 * 1024) throw new Error("A imagem deve ter no máximo 8 MB.");

    const extension = file.name.split(".").pop()?.toLowerCase().replace(/[^a-z0-9]/g, "") || "jpg";
    const baseName = slugify(file.name.replace(/\.[^.]+$/, "")) || "imagem";
    const path = `${folder}/${Date.now()}-${baseName}.${extension}`;
    const { error } = await client.storage.from(bucket).upload(path, file, {
      cacheControl: "3600",
      contentType: file.type,
      upsert: false
    });
    if (error) throw error;

    const { data: publicUrlData } = client.storage.from(bucket).getPublicUrl(path);
    if (!publicUrlData?.publicUrl) throw new Error("Não foi possível gerar a URL pública da imagem.");
    return publicUrlData.publicUrl;
  }

  async function runFormAction(form, busyLabel, action) {
    setFormBusy(form, true, busyLabel);
    try {
      await action();
    } catch (error) {
      notify(readableError(error), true);
    } finally {
      setFormBusy(form, false);
    }
  }

  function setFormBusy(form, busy, busyLabel) {
    const button = form?.querySelector('button[type="submit"]');
    if (!button) return;
    if (!button.dataset.defaultLabel) button.dataset.defaultLabel = button.textContent;
    button.disabled = busy;
    button.textContent = busy ? busyLabel : button.dataset.defaultLabel;
  }

  function countProducts(categoryId) {
    return data.products.filter((product) => product.categoryId === categoryId).length;
  }

  function getCategoryName(id) {
    return data.categories.find((category) => category.id === id)?.name || "Sem categoria";
  }

  function uniqueSlug(name, items) {
    const base = slugify(name);
    return items.some((item) => item.id === base) ? `${base}-${Date.now()}` : base;
  }

  function showLoginMessage(message) {
    const target = qs("[data-login-message]");
    if (!target) return;
    target.textContent = message;
    target.classList.remove("hidden");
  }

  function clearLoginMessage() {
    const target = qs("[data-login-message]");
    if (!target) return;
    target.textContent = "";
    target.classList.add("hidden");
  }

  function readableError(error) {
    const message = String(error?.message || error || "Ocorreu um erro inesperado.");
    if (/invalid login credentials/i.test(message)) return "E-mail ou senha incorretos.";
    if (/email not confirmed/i.test(message)) return "O e-mail ainda não foi confirmado no Supabase.";
    if (/row-level security/i.test(message)) return "Seu usuário não tem permissão para realizar esta alteração.";
    if (/duplicate key/i.test(message)) return "Já existe um item com esse nome ou identificador.";
    return message;
  }

  function notify(message, danger = false) {
    const notice = document.createElement("div");
    notice.className = "notice";
    notice.textContent = message;
    notice.style.position = "fixed";
    notice.style.right = "18px";
    notice.style.bottom = "18px";
    notice.style.zIndex = "120";
    notice.style.boxShadow = "var(--shadow)";
    if (danger) {
      notice.style.borderColor = "#f4c7c3";
      notice.style.background = "#fff4f2";
      notice.style.color = "var(--danger)";
    }
    document.body.appendChild(notice);
    window.setTimeout(() => notice.remove(), 3600);
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

  function digits(valueToClean) {
    return String(valueToClean || "").replace(/\D/g, "");
  }

  function slugify(valueToSlug) {
    return String(valueToSlug || "item")
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "")
      .slice(0, 80);
  }

  function escapeHtml(valueToEscape) {
    return String(valueToEscape ?? "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }
})();
