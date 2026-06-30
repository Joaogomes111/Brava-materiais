-- Brava Materiais de Limpeza
-- Estrutura inicial para Supabase/PostgreSQL.
-- Execute este arquivo no SQL Editor do Supabase.

create extension if not exists "pgcrypto";

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table if not exists public.admin_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text,
  created_at timestamptz not null default now()
);

create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.admin_profiles
    where id = auth.uid()
  );
$$;

create table if not exists public.company_settings (
  id boolean primary key default true,
  name text not null,
  short_name text,
  slogan text,
  description text,
  logo_url text,
  whatsapp text,
  whatsapp_display text,
  whatsapp_legacy_link text,
  phone text,
  email text,
  instagram_url text,
  address text,
  maps_url text,
  maps_embed text,
  cnpj text,
  hours text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint only_one_company_settings check (id = true)
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  description text,
  image_url text,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.categories(id) on delete set null,
  slug text not null unique,
  name text not null,
  description text,
  image_url text,
  price_label text,
  price_cents integer,
  code text,
  sku text,
  stock_qty integer,
  featured boolean not null default false,
  active boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.product_variants (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  name text not null,
  code text,
  price_label text,
  description text,
  active boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.product_categories (
  product_id uuid not null references public.products(id) on delete cascade,
  category_id uuid not null references public.categories(id) on delete cascade,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  primary key (product_id, category_id)
);

create index if not exists product_categories_category_id_idx
on public.product_categories(category_id);

create index if not exists product_categories_product_id_idx
on public.product_categories(product_id);

create table if not exists public.banners (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  subtitle text,
  body text,
  cta_label text,
  cta_url text,
  image_url text,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_company_settings_updated_at on public.company_settings;
create trigger set_company_settings_updated_at
before update on public.company_settings
for each row execute function public.set_updated_at();

drop trigger if exists set_categories_updated_at on public.categories;
create trigger set_categories_updated_at
before update on public.categories
for each row execute function public.set_updated_at();

drop trigger if exists set_products_updated_at on public.products;
create trigger set_products_updated_at
before update on public.products
for each row execute function public.set_updated_at();

drop trigger if exists set_product_variants_updated_at on public.product_variants;
create trigger set_product_variants_updated_at
before update on public.product_variants
for each row execute function public.set_updated_at();

drop trigger if exists set_banners_updated_at on public.banners;
create trigger set_banners_updated_at
before update on public.banners
for each row execute function public.set_updated_at();

alter table public.admin_profiles enable row level security;
alter table public.company_settings enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.product_variants enable row level security;
alter table public.product_categories enable row level security;
alter table public.banners enable row level security;

drop policy if exists "Admins can read admin profiles" on public.admin_profiles;
create policy "Admins can read admin profiles"
on public.admin_profiles for select
to authenticated
using (public.is_admin());

drop policy if exists "Public can read company settings" on public.company_settings;
create policy "Public can read company settings"
on public.company_settings for select
to anon, authenticated
using (true);

drop policy if exists "Admins can manage company settings" on public.company_settings;
create policy "Admins can manage company settings"
on public.company_settings for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Public can read active categories" on public.categories;
create policy "Public can read active categories"
on public.categories for select
to anon, authenticated
using (is_active = true or public.is_admin());

drop policy if exists "Admins can manage categories" on public.categories;
create policy "Admins can manage categories"
on public.categories for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Public can read active products" on public.products;
create policy "Public can read active products"
on public.products for select
to anon, authenticated
using (active = true or public.is_admin());

drop policy if exists "Admins can manage products" on public.products;
create policy "Admins can manage products"
on public.products for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Public can read active product variants" on public.product_variants;
create policy "Public can read active product variants"
on public.product_variants for select
to anon, authenticated
using (active = true or public.is_admin());

drop policy if exists "Admins can manage product variants" on public.product_variants;
create policy "Admins can manage product variants"
on public.product_variants for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Public can read product categories" on public.product_categories;
create policy "Public can read product categories"
on public.product_categories for select
to anon, authenticated
using (
  exists (
    select 1
    from public.products p
    where p.id = product_id
      and (p.active = true or public.is_admin())
  )
);

drop policy if exists "Admins can manage product categories" on public.product_categories;
create policy "Admins can manage product categories"
on public.product_categories for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Public can read active banners" on public.banners;
create policy "Public can read active banners"
on public.banners for select
to anon, authenticated
using (is_active = true or public.is_admin());

drop policy if exists "Admins can manage banners" on public.banners;
create policy "Admins can manage banners"
on public.banners for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

insert into storage.buckets (id, name, public)
values ('catalog', 'catalog', true)
on conflict (id) do nothing;

drop policy if exists "Public can read catalog files" on storage.objects;
create policy "Public can read catalog files"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'catalog');

drop policy if exists "Admins can upload catalog files" on storage.objects;
create policy "Admins can upload catalog files"
on storage.objects for insert
to authenticated
with check (bucket_id = 'catalog' and public.is_admin());

drop policy if exists "Admins can update catalog files" on storage.objects;
create policy "Admins can update catalog files"
on storage.objects for update
to authenticated
using (bucket_id = 'catalog' and public.is_admin())
with check (bucket_id = 'catalog' and public.is_admin());

drop policy if exists "Admins can delete catalog files" on storage.objects;
create policy "Admins can delete catalog files"
on storage.objects for delete
to authenticated
using (bucket_id = 'catalog' and public.is_admin());
