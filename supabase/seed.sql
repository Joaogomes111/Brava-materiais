-- Dados iniciais extraidos do site atual da Brava.
-- Execute depois de supabase/schema.sql.

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
  'materiais.brava@gmail.com',
  'https://www.instagram.com/brava_materiais_de_limpeza/',
  'Av. Osvaldo Reis, 2980 Praia Brava, Itajaí - SC',
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
  cnpj = excluded.cnpj,
  hours = excluded.hours;

insert into public.categories (slug, name, description, image_url, sort_order)
values
  ('produtos-de-limpeza', 'Produtos de Limpeza', 'Químicos, desinfetantes, detergentes, limpadores e soluções profissionais.', 'https://static.wixstatic.com/media/11062b_51935b9926aa4c939cb7ba228603c8db~mv2.jpg/v1/fill/w_760,h_520,al_c,q_85,enc_avif,quality_auto/11062b_51935b9926aa4c939cb7ba228603c8db~mv2.jpg', 1),
  ('descartaveis', 'Descartáveis', 'Luvas, máscaras, toucas, mexedores, guardanapos e itens de uso único.', 'https://static.wixstatic.com/media/8469f3_5bdd242bc323483f97cebb038053763f~mv2.jpg/v1/fill/w_760,h_520,al_c,q_85,enc_avif,quality_auto/8469f3_5bdd242bc323483f97cebb038053763f~mv2.jpg', 2),
  ('equipamentos', 'Equipamentos', 'Mops, rodos, vassouras, pás, suportes, dispensers e acessórios.', 'https://static.wixstatic.com/media/fe42c46e27b745ad8d007f01c5e495b1.jpg/v1/fill/w_760,h_520,al_c,q_85,enc_avif,quality_auto/fe42c46e27b745ad8d007f01c5e495b1.jpg', 3),
  ('papeis-e-panos', 'Papéis e Panos', 'Papéis toalha, papéis higiênicos, panos multiuso e panos de limpeza.', 'https://static.wixstatic.com/media/11062b_cfcf71e0ef1b4d1fb672d568f774eef6~mv2_d_5023_3349_s_4_2.jpg/v1/fill/w_760,h_520,al_c,q_85,enc_avif,quality_auto/11062b_cfcf71e0ef1b4d1fb672d568f774eef6~mv2_d_5023_3349_s_4_2.jpg', 4),
  ('aromatizadores', 'Aromatizadores', 'Aromatizadores, essências, águas perfumadas e itens para ambientes.', 'https://static.wixstatic.com/media/8469f3_49b74e06adf44f7799a49bd395c4fac2~mv2.webp/v1/fill/w_760,h_520,al_c,q_85,enc_avif,quality_auto/8469f3_49b74e06adf44f7799a49bd395c4fac2~mv2.webp', 5),
  ('banheiro', 'Banheiro', 'Sabonetes, saboneteiras, papéis, suportes, refis e itens sanitários.', 'https://static.wixstatic.com/media/8469f3_b54cea9ff0c64a27bff608caddb79d89~mv2.png/v1/fill/w_760,h_520,al_c,q_90,enc_avif,quality_auto/8469f3_b54cea9ff0c64a27bff608caddb79d89~mv2.png', 6),
  ('cozinha', 'Cozinha', 'Desengordurantes, detergentes, limpa-alumínio e produtos para lava-louças.', 'https://static.wixstatic.com/media/e857c88665e244a1bab05993b74ee772.jpg/v1/fill/w_760,h_520,al_c,q_85,enc_avif,quality_auto/e857c88665e244a1bab05993b74ee772.jpg', 7),
  ('diversos', 'Diversos', 'Itens complementares para limpeza, organização e reposição do dia a dia.', 'https://static.wixstatic.com/media/8469f3_42274b4142ef402f95da4168883fb642~mv2.jpg/v1/fill/w_760,h_520,al_c,q_85,enc_avif,quality_auto/8469f3_42274b4142ef402f95da4168883fb642~mv2.jpg', 8)
on conflict (slug) do update set
  name = excluded.name,
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

insert into public.banners (title, subtitle, body, cta_label, cta_url, image_url, sort_order)
values
  ('Brava Materiais de Limpeza', 'De tudo para facilitar sua vida', 'Produtos de limpeza, descartáveis, papéis, higiene e equipamentos para casas, empresas, comércios e condomínios.', 'Pedir orçamento', 'https://wa.me/5547999118317', 'https://static.wixstatic.com/media/e857c88665e244a1bab05993b74ee772.jpg/v1/fill/w_1200,h_720,al_c,q_85,enc_avif,quality_auto/e857c88665e244a1bab05993b74ee772.jpg', 1);

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
  true,
  v.sort_order
from (
  values
    ('produtos-de-limpeza', 'shampoo-automotivo-com-cera-5l', 'Shampoo automotivo com cera 5L', 'Produto para limpeza automotiva com cera, indicado para brilho e proteção no uso frequente.', 'https://static.wixstatic.com/media/8469f3_42274b4142ef402f95da4168883fb642~mv2.jpg/v1/fill/w_640,h_640,al_c,q_85,enc_avif,quality_auto/8469f3_42274b4142ef402f95da4168883fb642~mv2.jpg', 'R$ 31,00', 'LIMP-001', true, 1),
    ('produtos-de-limpeza', 'preteador-de-pneu-5l', 'Preteador de pneu 5L', 'Preteador para pneus em embalagem de 5 litros, ideal para acabamento e conservação visual.', 'https://static.wixstatic.com/media/8469f3_74650e299587435193af640de49dc71f~mv2.jpg/v1/fill/w_640,h_640,al_c,q_85,enc_avif,quality_auto/8469f3_74650e299587435193af640de49dc71f~mv2.jpg', 'R$ 39,90', 'LIMP-002', true, 2),
    ('produtos-de-limpeza', 'limpa-pedras-quimak-5l', 'Limpa Pedras Quimak 5L', 'Limpador para pedras e pisos resistentes, indicado para limpezas pesadas conforme orientação de uso.', 'https://static.wixstatic.com/media/8469f3_5bdd242bc323483f97cebb038053763f~mv2.jpg/v1/fill/w_640,h_640,al_c,q_85,enc_avif,quality_auto/8469f3_5bdd242bc323483f97cebb038053763f~mv2.jpg', 'R$ 49,90', 'LIMP-003', true, 3),
    ('produtos-de-limpeza', 'desengraxante-quimak-5l', 'Desengraxante Quimak 5L', 'Desengraxante para remoção de sujeiras pesadas, graxa e resíduos oleosos.', 'https://static.wixstatic.com/media/8469f3_b3fcc775f0e94ac39db53230a55f2c05~mv2.jpeg/v1/fill/w_640,h_640,al_c,q_85,enc_avif,quality_auto/8469f3_b3fcc775f0e94ac39db53230a55f2c05~mv2.jpeg', 'R$ 59,90', 'LIMP-004', true, 4),
    ('banheiro', 'sabonete-liquido-dove-5l', 'Sabonete líquido Dove 5L', 'Sabonete líquido em galão de 5 litros, indicado para reposição em ambientes com alto fluxo.', 'https://static.wixstatic.com/media/8469f3_b54cea9ff0c64a27bff608caddb79d89~mv2.png/v1/fill/w_640,h_640,al_c,q_90,enc_avif,quality_auto/8469f3_b54cea9ff0c64a27bff608caddb79d89~mv2.png', 'R$ 21,90', 'HIG-001', true, 5),
    ('cozinha', 'pasta-multiuso-rosa-500g-sany', 'Pasta Multiuso Rosa 500g - Sany', 'Pasta multiuso para limpeza de superfícies, utensílios e remoção de sujeiras do dia a dia.', 'https://static.wixstatic.com/media/8469f3_ad835897a01f4cf0acccd48752d4c6b8~mv2.jpg/v1/fill/w_640,h_640,al_c,q_85,enc_avif,quality_auto/8469f3_ad835897a01f4cf0acccd48752d4c6b8~mv2.jpg', 'R$ 5,90', 'COZ-001', false, 6),
    ('equipamentos', 'vassoura-rodo-esfregao-flat-mop-slim', 'Vassoura, rodo e esfregão Flat Mop Slim balde espremedor Nobre', 'Kit flat mop com balde espremedor, ideal para limpeza prática em pisos.', 'https://static.wixstatic.com/media/fe42c46e27b745ad8d007f01c5e495b1.jpg/v1/fill/w_640,h_640,al_c,q_85,enc_avif,quality_auto/fe42c46e27b745ad8d007f01c5e495b1.jpg', 'R$ 148,95', 'EQP-001', true, 7),
    ('papeis-e-panos', 'papel-toalha-interfolhado-ipel', 'Papel toalha interfolhado Ipel folha dupla 30g cx. com 2000', 'Papel toalha interfolhado folha dupla, indicado para empresas, comércios e banheiros de alto uso.', 'https://static.wixstatic.com/media/8469f3_dde1176ec9814311828b672442b4db36~mv2.png/v1/fill/w_640,h_640,al_c,q_90,enc_avif,quality_auto/8469f3_dde1176ec9814311828b672442b4db36~mv2.png', 'R$ 79,00', 'PAP-003', true, 8),
    ('aromatizadores', 'agua-perfumada-via-aroma', 'Água perfumada Via Aroma', 'Água perfumada Via Aroma para deixar ambientes com fragrância agradável.', 'https://static.wixstatic.com/media/8469f3_49b74e06adf44f7799a49bd395c4fac2~mv2.webp/v1/fill/w_640,h_640,al_c,q_85,enc_avif,quality_auto/8469f3_49b74e06adf44f7799a49bd395c4fac2~mv2.webp', 'R$ 41,00', 'ARO-001', true, 9),
    ('descartaveis', 'touca-tnt-descartavel-100-unidades', 'Touca TNT descartável 100 unidades', 'Touca TNT descartável em pacote com 100 unidades.', 'https://static.wixstatic.com/media/8469f3_938755f54a24400fac40a7ade32afe13~mv2.png/v1/fill/w_640,h_640,al_c,q_90,enc_avif,quality_auto/8469f3_938755f54a24400fac40a7ade32afe13~mv2.png', 'R$ 39,90', 'DESC-002', false, 10)
) as v(category_slug, slug, name, description, image_url, price_label, code, featured, sort_order)
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
