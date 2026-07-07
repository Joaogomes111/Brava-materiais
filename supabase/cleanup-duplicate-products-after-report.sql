-- Brava Materiais de Limpeza
-- Limpeza de duplicados criados na importação do relatório de vendas.
-- Execute uma vez no SQL Editor do Supabase.
-- O script mantém o produto principal, cria opções limpas e remove produtos duplicados.

begin;

with direct_source as (
  select *
  from (values
  ('luva-plastica-descartavel-100-unidades', 'luva-plastica-descartavel-c-100', 'Luva Plástica Descartável C/100'),
  ('vassoura-classica-sanches-com-cabo', 'vassoura-classica-sanches-cabo-de-madeira', 'Vassoura Clássica Sanches com Cabo'),
  ('alcool-gel-pump-500ml', 'alcool-gel-pump-premisse-500ml', 'Álcool Gel Pump Premisse 500ml'),
  ('papel-toalha-interfolhado-ipel', 'p-toalha-interf-ipel-2000-f-dupla-22-5x20-5-30g', 'Papel Toalha Interfolhado Ipel Folha Dupla 30g Cx com 2000'),
  ('escova-sanitaria-com-suporte', 'escova-sanitaria-c-suporte-sanches', 'Escova Sanitária com Suporte Sanches'),
  ('pa-jeitosa-com-cabo', 'pa-jeitosa-c-cabo-bettanin', 'Pá Jeitosa com Cabo Bettanin'),
  ('refil-de-mop-umido', 'refil-mop-umido-cru', 'Refil Mop Úmido Cru'),
  ('alvejante-sem-cloro-5l', 'alvejante-sem-cloro-spry-peroxy-5l', 'Alvejante Sem Cloro Spry Peroxy 5L'),
  ('naftalina-30g-sany', 'naftalina-pacote-30g', 'Naftalina Pacote 30g'),
  ('alcool-gel-5l-70', 'alcool-gel-vale-verde-5l-70', 'Álcool Gel Vale Verde 5L 70%'),
  ('limpa-vidros-up-pro-500ml', 'limpa-vidro-500ml-up-nobre', 'Limpa Vidros UP Nobre 500ml'),
  ('limpa-vidros-up-pro-5l', 'limpa-vidro-5l-up', 'Limpa Vidros UP 5L'),
  ('sabonete-liquido-dove-5l', 'sabonete-liq-besser-dove-5l', 'Sabonete Líquido Besser Dove 5L'),
  ('mult-espuma-desincrustante-5l', 'mult-espuma-desincrustante-desengord-5l-diluirm-em-1-40', 'Mult Espuma Desincrustante / Desengordurante 5L'),
  ('fibraco-branco-leve', 'fibraco-leve-branco-gde-26cm', 'Fibraço Leve Branco GDE 26cm'),
  ('pano-fraldina-para-limpeza', 'fralda-para-limpeza-48x58', 'Fralda para Limpeza 48x58')
  ) as v(parent_slug, child_slug, final_name)
),
direct_rows as (
  select parent.id as parent_id, child.id as child_id, ds.final_name, child.code as child_code
  from direct_source ds
  join public.products parent on parent.slug = ds.parent_slug
  join public.products child on child.slug = ds.child_slug
)
update public.products parent
set
  name = dr.final_name,
  code = coalesce(nullif(dr.child_code, ''), parent.code),
  updated_at = now()
from direct_rows dr
where parent.id = dr.parent_id;

with direct_source as (
  select *
  from (values
  ('luva-plastica-descartavel-100-unidades', 'luva-plastica-descartavel-c-100', 'Luva Plástica Descartável C/100'),
  ('vassoura-classica-sanches-com-cabo', 'vassoura-classica-sanches-cabo-de-madeira', 'Vassoura Clássica Sanches com Cabo'),
  ('alcool-gel-pump-500ml', 'alcool-gel-pump-premisse-500ml', 'Álcool Gel Pump Premisse 500ml'),
  ('papel-toalha-interfolhado-ipel', 'p-toalha-interf-ipel-2000-f-dupla-22-5x20-5-30g', 'Papel Toalha Interfolhado Ipel Folha Dupla 30g Cx com 2000'),
  ('escova-sanitaria-com-suporte', 'escova-sanitaria-c-suporte-sanches', 'Escova Sanitária com Suporte Sanches'),
  ('pa-jeitosa-com-cabo', 'pa-jeitosa-c-cabo-bettanin', 'Pá Jeitosa com Cabo Bettanin'),
  ('refil-de-mop-umido', 'refil-mop-umido-cru', 'Refil Mop Úmido Cru'),
  ('alvejante-sem-cloro-5l', 'alvejante-sem-cloro-spry-peroxy-5l', 'Alvejante Sem Cloro Spry Peroxy 5L'),
  ('naftalina-30g-sany', 'naftalina-pacote-30g', 'Naftalina Pacote 30g'),
  ('alcool-gel-5l-70', 'alcool-gel-vale-verde-5l-70', 'Álcool Gel Vale Verde 5L 70%'),
  ('limpa-vidros-up-pro-500ml', 'limpa-vidro-500ml-up-nobre', 'Limpa Vidros UP Nobre 500ml'),
  ('limpa-vidros-up-pro-5l', 'limpa-vidro-5l-up', 'Limpa Vidros UP 5L'),
  ('sabonete-liquido-dove-5l', 'sabonete-liq-besser-dove-5l', 'Sabonete Líquido Besser Dove 5L'),
  ('mult-espuma-desincrustante-5l', 'mult-espuma-desincrustante-desengord-5l-diluirm-em-1-40', 'Mult Espuma Desincrustante / Desengordurante 5L'),
  ('fibraco-branco-leve', 'fibraco-leve-branco-gde-26cm', 'Fibraço Leve Branco GDE 26cm'),
  ('pano-fraldina-para-limpeza', 'fralda-para-limpeza-48x58', 'Fralda para Limpeza 48x58')
  ) as v(parent_slug, child_slug, final_name)
)
insert into public.product_categories (product_id, category_id, sort_order)
select parent.id, pc.category_id, pc.sort_order
from direct_source ds
join public.products parent on parent.slug = ds.parent_slug
join public.products child on child.slug = ds.child_slug
join public.product_categories pc on pc.product_id = child.id
on conflict (product_id, category_id) do update set
  sort_order = excluded.sort_order;

with parent_source as (
  select *
  from (values
  ('papel-toalha-bobina-28g-fardo-com-6-rolos', 'Papel Toalha Bobina 200m Fardo C/6'),
  ('touca-tnt-descartavel-100-unidades', 'Touca TNT Descartável C/100'),
  ('copo-descartavel-180ml-agua-100-unidades', 'Copo Descartável 180ml Transparente'),
  ('saponaceo-cremoso-lavanda-sany-300ml', 'Saponáceo Cremoso 300ml'),
  ('pulverizador-500ml', 'Pulverizador 500ml')
  ) as v(parent_slug, final_name)
)
update public.products parent
set
  name = ps.final_name,
  code = null,
  description = case
    when nullif(parent.description, '') is null then 'Produto com opções de marca, tamanho, embalagem ou modelo. Selecione a opção desejada e solicite orçamento pelo WhatsApp.'
    else parent.description
  end,
  updated_at = now()
from parent_source ps
where parent.slug = ps.parent_slug;

with variant_source as (
  select *
  from (values
  ('papel-toalha-bobina-28g-fardo-com-6-rolos', 'p-toalha-bobina-200m-brava-bello-28g-100-cel-cx-c-6', 'Brava Bello 28g 100% Cel', 1),
  ('papel-toalha-bobina-28g-fardo-com-6-rolos', 'p-toalha-bobina-200m-brava-bello-32g-100-cel-cx-c-6', 'Brava Bello 32g 100% Cel', 2),
  ('papel-toalha-bobina-28g-fardo-com-6-rolos', 'p-toalha-bobina-200m-ipel-28g-100-cel-cx-c-6', 'Ipel 28g 100% Cel', 3),
  ('papel-toalha-bobina-28g-fardo-com-6-rolos', 'p-toalha-bobina-200m-premium-brava-38g-cx-c-6', 'Premium Brava 38g', 4),
  ('touca-tnt-descartavel-100-unidades', 'touca-tnt-descartavel-100-unidades', 'TNT Descartável C/100', 1),
  ('touca-tnt-descartavel-100-unidades', 'touca-nobre-tnt-clipada-pc-c-100un', 'Nobre Clipada C/100', 2),
  ('touca-tnt-descartavel-100-unidades', 'touca-tnt-bompack-clipada-pc-c-100un', 'Bompack Clipada C/100', 3),
  ('saponaceo-cremoso-lavanda-sany-300ml', 'saponaceo-cremoso-lavanda-sany-300ml', 'Lavanda Sany', 1),
  ('saponaceo-cremoso-lavanda-sany-300ml', 'saponaceo-cremoso-sany-floral-300ml', 'Floral Sany', 2),
  ('saponaceo-cremoso-lavanda-sany-300ml', 'saponaceo-cremoso-sanybril-lavanda-300ml', 'Lavanda Sanybril', 3),
  ('saponaceo-cremoso-lavanda-sany-300ml', 'saponaceo-cremoso-sanybril-cloro-300ml', 'Cloro Sanybril', 4),
  ('saponaceo-cremoso-lavanda-sany-300ml', 'saponaceo-cremoso-sanybril-limao-300ml', 'Limão Sanybril', 5),
  ('pulverizador-500ml', 'pulverizador-bompack-500ml', 'Bompack', 1),
  ('pulverizador-500ml', 'pulverizador-profissional-500ml', 'Profissional', 2),
  ('pulverizador-500ml', 'pulverizador-transparente-bettanin-500ml', 'Transparente Bettanin', 3),
  ('pulverizador-500ml', 'gatilho-pulverizador-bompack-500ml', 'Gatilho Bompack', 4)
  ) as v(parent_slug, child_slug, variant_name, sort_order)
),
variant_rows as (
  select
    parent.id as parent_id,
    child.id as child_id,
    vs.variant_name,
    nullif(child.code, '') as code,
    vs.sort_order
  from variant_source vs
  join public.products parent on parent.slug = vs.parent_slug
  join public.products child on child.slug = vs.child_slug
)
insert into public.product_variants (product_id, name, code, price_label, description, active, sort_order)
select parent_id, variant_name, code, null, null, true, sort_order
from variant_rows vr
where not exists (
  select 1
  from public.product_variants existing
  where existing.product_id = vr.parent_id
    and (
      lower(existing.name) = lower(vr.variant_name)
      or (vr.code is not null and existing.code = vr.code)
    )
);

with move_source as (
  select *
  from (values
  ('copo-descartavel-180ml-agua-100-unidades', 'copo-180ml-dudigo-promo-com-25tr-transparente')
  ) as v(parent_slug, child_slug)
),
variant_rows as (
  select
    parent.id as parent_id,
    child_variant.name,
    child_variant.code,
    child_variant.price_label,
    child_variant.sort_order
  from move_source ms
  join public.products parent on parent.slug = ms.parent_slug
  join public.products child on child.slug = ms.child_slug
  join public.product_variants child_variant on child_variant.product_id = child.id
)
insert into public.product_variants (product_id, name, code, price_label, description, active, sort_order)
select parent_id, name, code, price_label, null, true, sort_order
from variant_rows vr
where not exists (
  select 1
  from public.product_variants existing
  where existing.product_id = vr.parent_id
    and (
      lower(existing.name) = lower(vr.name)
      or (vr.code is not null and existing.code = vr.code)
    )
);

with duplicate_slugs as (
  select slug
  from (values
  ('alcool-gel-pump-premisse-500ml'),
  ('alcool-gel-vale-verde-5l-70'),
  ('alvejante-sem-cloro-spry-peroxy-5l'),
  ('copo-180ml-dudigo-promo-com-25tr-transparente'),
  ('escova-sanitaria-c-suporte-sanches'),
  ('fibraco-leve-branco-gde-26cm'),
  ('fralda-para-limpeza-48x58'),
  ('gatilho-pulverizador-bompack-500ml'),
  ('limpa-vidro-500ml-up-nobre'),
  ('limpa-vidro-5l-up'),
  ('luva-plastica-descartavel-c-100'),
  ('mult-espuma-desincrustante-desengord-5l-diluirm-em-1-40'),
  ('naftalina-pacote-30g'),
  ('p-toalha-bobina-200m-brava-bello-28g-100-cel-cx-c-6'),
  ('p-toalha-bobina-200m-brava-bello-32g-100-cel-cx-c-6'),
  ('p-toalha-bobina-200m-ipel-28g-100-cel-cx-c-6'),
  ('p-toalha-bobina-200m-premium-brava-38g-cx-c-6'),
  ('p-toalha-interf-ipel-2000-f-dupla-22-5x20-5-30g'),
  ('pa-jeitosa-c-cabo-bettanin'),
  ('papel-toalha-bobina-ipel-28g-fardo-com-6-rolos'),
  ('papel-toalha-bobina-premium-38g-fardo-com-6-rolos-200m'),
  ('pulverizador-bompack-500ml'),
  ('pulverizador-profissional-500ml'),
  ('pulverizador-transparente-bettanin-500ml'),
  ('refil-mop-umido-cru'),
  ('sabonete-liq-besser-dove-5l'),
  ('saponaceo-cremoso-sany-floral-300ml'),
  ('saponaceo-cremoso-sanybril-cloro-300ml'),
  ('saponaceo-cremoso-sanybril-lavanda-300ml'),
  ('saponaceo-cremoso-sanybril-limao-300ml'),
  ('touca-nobre-tnt-clipada-pc-c-100un'),
  ('touca-tnt-bompack-clipada-pc-c-100un'),
  ('vassoura-classica-sanches-cabo-de-madeira')
  ) as v(slug)
)
delete from public.products product
using duplicate_slugs ds
where product.slug = ds.slug;

commit;
