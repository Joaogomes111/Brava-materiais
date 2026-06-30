-- Brava Materiais de Limpeza
-- Suporte para produtos em mais de uma categoria.
-- Execute este arquivo uma vez no SQL Editor do Supabase.

begin;

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

alter table public.product_categories enable row level security;

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

insert into public.product_categories (product_id, category_id, sort_order)
select id, category_id, 1
from public.products
where category_id is not null
on conflict (product_id, category_id) do nothing;

commit;
