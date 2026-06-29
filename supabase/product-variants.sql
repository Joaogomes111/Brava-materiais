-- Brava Materiais de Limpeza
-- Atualizacao para produtos com variacoes/opcoes.
-- Execute este arquivo uma vez no SQL Editor do Supabase.

begin;

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

drop trigger if exists set_product_variants_updated_at on public.product_variants;
create trigger set_product_variants_updated_at
before update on public.product_variants
for each row execute function public.set_updated_at();

alter table public.product_variants enable row level security;

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

create index if not exists product_variants_product_id_idx
on public.product_variants (product_id);

create index if not exists product_variants_sort_order_idx
on public.product_variants (sort_order);

commit;
