-- Dados iniciais completos da Brava Materiais de Limpeza.
-- Execute depois de supabase/schema.sql.

begin;

insert into public.company_settings (
  id,
  name,
  short_name,
  slogan,
  description,
  logo_url,
  whatsapp,
  whatsapp_display,
  whatsapp_legacy_link,
  phone,
  email,
  instagram_url,
  address,
  maps_url,
  maps_embed,
  cnpj,
  hours
) values (
  true,
  'Brava Materiais de Limpeza',
  'Brava',
  'De tudo para facilitar sua vida',
  'Materiais e equipamentos de limpeza para sua casa, comércio, empresa e condomínio em Itajaí e região.',
  'assets/logo-brava-materiais.jpeg',
  '5547999118317',
  '(47) 99911-8317',
  'https://wa.me/message/NXZV2F4M4Z75K1',
  '(47) 3348 9682',
  'bravamateriais@hotmail.com',
  'https://www.instagram.com/brava_materiais_de_limpeza/',
  'Av. Osvaldo Reis, 2980 Praia Brava, Itajaí - SC',
  'https://www.google.com/maps/place/Brava+Materiais+de+Limpeza/data=!4m2!3m1!1s0x0:0x8d3efcf983a27fcf?sa=X&ved=1t:2428&ictx=111',
  'https://maps.google.com/maps?q=Brava%20Materiais%20de%20Limpeza%2C%20Av.%20Osvaldo%20Reis%2C%202980%20Praia%20Brava%2C%20Itajai%20SC&t=&z=16&ie=UTF8&iwloc=&output=embed',
  '25.014.862/0001-02',
  'Segunda a sexta, das 08h às 17h'
) on conflict (id) do update set
  name = excluded.name,
  short_name = excluded.short_name,
  slogan = excluded.slogan,
  description = excluded.description,
  logo_url = excluded.logo_url,
  whatsapp = excluded.whatsapp,
  whatsapp_display = excluded.whatsapp_display,
  whatsapp_legacy_link = excluded.whatsapp_legacy_link,
  phone = excluded.phone,
  email = excluded.email,
  instagram_url = excluded.instagram_url,
  address = excluded.address,
  maps_url = excluded.maps_url,
  maps_embed = excluded.maps_embed,
  cnpj = excluded.cnpj,
  hours = excluded.hours;

insert into public.categories (slug, name, description, image_url, sort_order)
values
  ('produtos-de-limpeza', 'Produtos de Limpeza', 'Químicos, desinfetantes, detergentes, limpadores e soluções profissionais.', 'assets/category-produtos-limpeza.jpg', 1),
  ('descartaveis', 'Descartáveis', 'Luvas, máscaras, toucas, mexedores, guardanapos e itens de uso único.', 'assets/category-descartaveis.jpg', 2),
  ('equipamentos', 'Equipamentos', 'Mops, rodos, vassouras, pás, suportes, dispensers e acessórios.', 'assets/category-equipamentos.jpg', 3),
  ('papeis-e-panos', 'Papéis e Panos', 'Papéis toalha, papéis higiênicos, panos multiuso e panos de limpeza.', 'assets/category-papeis-panos.jpg', 4),
  ('aromatizadores', 'Aromatizadores', 'Aromatizadores, essências, águas perfumadas e itens para ambientes.', 'assets/category-aromatizadores.jpg', 5),
  ('banheiro', 'Banheiro', 'Sabonetes, saboneteiras, papéis, suportes, refis e itens sanitários.', 'assets/category-banheiro.jpg', 6),
  ('cozinha', 'Cozinha', 'Desengordurantes, detergentes, limpa-alumínio e produtos para lava-louças.', 'assets/category-cozinha.jpg', 7),
  ('diversos', 'Diversos', 'Itens complementares para limpeza, organização e reposição do dia a dia.', 'assets/category-diversos.jpg', 8)
on conflict (slug) do update set
  name = excluded.name,
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order,
  is_active = true;

delete from public.banners;

insert into public.banners (title, subtitle, body, cta_label, cta_url, image_url, sort_order)
values
  ('Brava Materiais de Limpeza', 'De tudo para facilitar sua vida', 'Produtos de limpeza, descartáveis, papéis, higiene e equipamentos para sua casa, empresa, comércio ou condomínio.', 'Pedir orçamento', 'https://wa.me/5547999118317', 'assets/hero-brava-estrutura-4k.jpg', 1);

insert into public.products (
  category_id,
  slug,
  name,
  description,
  image_url,
  price_label,
  code,
  featured,
  active,
  sort_order
)
select
  c.id,
  v.slug,
  v.name,
  v.description,
  v.image_url,
  v.price_label,
  v.code,
  v.featured,
  v.active,
  v.sort_order
from (
  values
    ('produtos-de-limpeza', 'shampoo-automotivo-com-cera-5l', 'Shampoo automotivo com cera 5L', 'Produto para limpeza automotiva com cera, indicado para brilho e proteção no uso frequente.', 'assets/product-gallon-red.jpg', 'R$ 31,00', 'LIMP-001', true, true, 1),
    ('produtos-de-limpeza', 'preteador-de-pneu-5l', 'Preteador de pneu 5L', 'Preteador para pneus em embalagem de 5 litros, ideal para acabamento e conservação visual.', 'assets/product-gallon-gray.jpg', 'R$ 39,90', 'LIMP-002', true, true, 2),
    ('produtos-de-limpeza', 'limpa-pedras-quimak-5l', 'Limpa Pedras Quimak 5L', 'Limpador para pedras e pisos resistentes, indicado para limpezas pesadas conforme orientação de uso.', 'assets/product-gallon-pink.jpg', 'R$ 49,90', 'LIMP-003', true, true, 3),
    ('produtos-de-limpeza', 'desengraxante-quimak-5l', 'Desengraxante Quimak 5L', 'Desengraxante para remoção de sujeiras pesadas, graxa e resíduos oleosos.', 'assets/product-gallon-gray.jpg', 'R$ 59,90', 'LIMP-004', true, true, 4),
    ('produtos-de-limpeza', 'lustra-moveis-jasmin-mr-keep-750ml', 'Lustra-móveis Jasmin Mr. Keep 750ml', 'Lustra-móveis com fragrância jasmin para limpeza, brilho e cuidado de superfícies.', 'assets/category-produtos-limpeza.jpg', 'R$ 19,90', 'LIMP-005', false, true, 5),
    ('banheiro', 'sabonete-liquido-dove-5l', 'Sabonete líquido Dove 5L', 'Sabonete líquido em galão de 5 litros, indicado para reposição em ambientes com alto fluxo.', 'assets/product-bottle.jpg', 'R$ 21,90', 'HIG-001', true, true, 6),
    ('cozinha', 'pasta-multiuso-rosa-500g-sany', 'Pasta Multiuso Rosa 500g - Sany', 'Pasta multiuso para limpeza de superfícies, utensílios e remoção de sujeiras do dia a dia.', 'assets/product-gallon-pink.jpg', 'R$ 5,90', 'COZ-001', false, true, 7),
    ('cozinha', 'saponaceo-cremoso-lavanda-sany-300ml', 'Saponáceo cremoso lavanda Sany 300ml', 'Saponáceo cremoso para limpeza de cozinha e banheiro, com fragrância lavanda.', 'assets/product-spray.png', 'R$ 6,10', 'COZ-002', false, true, 8),
    ('cozinha', 'brilha-inox-spray-super-dom-300ml', 'Brilha Inox Spray Super Dom 300ml', 'Spray para brilho e acabamento em superfícies de inox, com ação duradoura.', 'assets/product-spray.png', 'R$ 21,99', 'COZ-003', false, true, 9),
    ('produtos-de-limpeza', 'desinfetante-hospitalar-bactgerm', 'Desinfetante Hospitalar Bactgerm', 'Desinfetante hospitalar para uso profissional, ideal para ambientes que exigem higienização rigorosa.', 'assets/category-produtos-limpeza.jpg', 'R$ 79,90', 'LIMP-006', true, true, 10),
    ('produtos-de-limpeza', 'cera-liquida-5l', 'Cera líquida 5L', 'Cera líquida para acabamento e conservação de pisos.', 'assets/category-produtos-limpeza.jpg', 'R$ 79,50', 'LIMP-007', false, true, 11),
    ('banheiro', 'refil-sabonete-proteinas-do-leite-800ml', 'Refil sabonete proteínas do leite 800ml', 'Refil de sabonete para saboneteira spray, indicado para reposição prática em banheiros.', 'assets/category-banheiro.jpg', 'R$ 18,60', 'HIG-002', false, true, 12),
    ('produtos-de-limpeza', 'super-cloro-besser-5l', 'Super Cloro Besser 5L', 'Cloro para limpeza pesada e higienização, em embalagem de 5 litros.', 'assets/category-produtos-limpeza.jpg', 'R$ 19,60', 'LIMP-008', false, true, 13),
    ('cozinha', 'secante-para-lava-loucas-5l', 'Secante para lava-louças 5L', 'Secante para máquinas lava-louças profissionais.', 'assets/category-cozinha.jpg', 'R$ 149,20', 'COZ-004', false, true, 14),
    ('cozinha', 'pratico-desengordurante-1l-e-5l', 'Prático desengordurante 1L e 5L', 'Desengordurante prático para cozinhas, bancadas, equipamentos e superfícies laváveis.', 'assets/category-cozinha.jpg', 'R$ 16,75', 'COZ-005', false, true, 15),
    ('cozinha', 'detergente-para-maquina-de-lavar-louca', 'Detergente para máquina de lavar louça', 'Detergente profissional para máquina de lavar louças.', 'assets/category-cozinha.jpg', 'R$ 91,20', 'COZ-006', false, true, 16),
    ('equipamentos', 'vassoura-rodo-esfregao-flat-mop-slim', 'Vassoura, rodo e esfregão Flat Mop Slim balde espremedor Nobre', 'Kit flat mop com balde espremedor, ideal para limpeza prática em pisos.', 'assets/hero-equipment.jpg', 'R$ 148,95', 'EQP-001', true, true, 17),
    ('equipamentos', 'garra-haste-para-mop-umido', 'Garra / haste para mop úmido multiuso', 'Garra e haste para mop úmido multiuso.', 'assets/category-equipamentos.jpg', 'R$ 23,05', 'EQP-002', false, true, 18),
    ('banheiro', 'suporte-papel-higienico-rolao', 'Suporte papel higiênico rolão 300m - branco e preto', 'Suporte para papel higiênico rolão de 300m, disponível em branco e preto.', 'assets/category-banheiro.jpg', 'R$ 39,90', 'HIG-003', false, true, 19),
    ('banheiro', 'toalheiro-para-toalha-bobina', 'Toalheiro para toalha bobina - branco e preto', 'Toalheiro para papel toalha bobina, indicado para banheiros e áreas de higienização.', 'assets/category-banheiro.jpg', 'R$ 233,00', 'HIG-004', false, true, 20),
    ('papeis-e-panos', 'flanela-de-algodao-laranja', 'Flanela de algodão laranja', 'Flanela de algodão para limpeza geral e acabamento de superfícies.', 'assets/category-papeis-panos.jpg', 'R$ 1,89', 'PAP-001', false, true, 21),
    ('papeis-e-panos', 'pano-de-chao-economico-saco-alvejado', 'Pano de chão econômico saco alvejado', 'Pano de chão econômico tipo saco alvejado para uso diário.', 'assets/category-papeis-panos.jpg', 'R$ 3,50', 'PAP-002', false, true, 22),
    ('descartaveis', 'papel-higienico-cai-cai-ipel', 'Papel higiênico cai-cai folha dupla Ipel caixa com 8000 folhas', 'Papel higiênico cai-cai folha dupla em caixa com 8000 folhas.', 'assets/category-descartaveis.jpg', 'R$ 120,80', 'DESC-001', false, true, 23),
    ('papeis-e-panos', 'papel-toalha-interfolhado-ipel', 'Papel toalha interfolhado Ipel folha dupla 30g cx. com 2000', 'Papel toalha interfolhado folha dupla, indicado para empresas, comércios e banheiros de alto uso.', 'assets/cloths.jpg', 'R$ 79,00', 'PAP-003', true, true, 24),
    ('aromatizadores', 'agua-perfumada-via-aroma', 'Água perfumada Via Aroma', 'Água perfumada Via Aroma para deixar ambientes com fragrância agradável.', 'assets/product-spray.png', 'R$ 41,00', 'ARO-001', true, true, 25),
    ('aromatizadores', 'essencias-via-aroma', 'Essências Via Aroma', 'Essências Via Aroma para aromatização de ambientes.', 'assets/category-aromatizadores.jpg', 'R$ 17,90', 'ARO-002', false, true, 26),
    ('aromatizadores', 'aromatizador-puro-ar-400ml', 'Aromatizador Puro Ar 400ml', 'Aromatizador em spray para ambientes.', 'assets/category-aromatizadores.jpg', 'R$ 11,55', 'ARO-003', false, true, 27),
    ('descartaveis', 'touca-tnt-descartavel-100-unidades', 'Touca TNT descartável 100 unidades', 'Touca TNT descartável em pacote com 100 unidades.', 'assets/category-descartaveis.jpg', 'R$ 39,90', 'DESC-002', false, true, 28),
    ('descartaveis', 'mexedor-cafe-grande-500-unidades', 'Mexedor para café grande 11cm 500 unidades', 'Mexedor para café grande de 11cm em pacote com 500 unidades.', 'assets/category-descartaveis.jpg', 'R$ 11,20', 'DESC-003', false, true, 29),
    ('descartaveis', 'luva-plastica-descartavel-100-unidades', 'Luva plástica descartável com 100 unidades', 'Luva plástica descartável para manipulação e proteção simples.', 'assets/category-descartaveis.jpg', 'R$ 4,99', 'DESC-004', false, true, 30),
    ('diversos', 'acucar-sache-caravelas-cx-1000', 'Açúcar sachê Caravelas cx. com 1000', 'Açúcar em sachê, caixa com 1000 unidades para atendimento, cafeterias e empresas.', 'assets/category-diversos.jpg', 'R$ 51,20', 'DIV-001', false, true, 31)
) as v(category_slug, slug, name, description, image_url, price_label, code, featured, active, sort_order)
join public.categories c on c.slug = v.category_slug
on conflict (slug) do update set
  category_id = excluded.category_id,
  name = excluded.name,
  description = excluded.description,
  image_url = excluded.image_url,
  price_label = excluded.price_label,
  code = excluded.code,
  featured = excluded.featured,
  active = excluded.active,
  sort_order = excluded.sort_order;

commit;
