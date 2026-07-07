-- Brava Materiais de Limpeza
-- Define a logo da Brava como imagem dos produtos sem foto cadastrada.
-- Execute uma vez no SQL Editor do Supabase.

update public.products
set
  image_url = 'assets/brava-materiais-perfil-instagram.png',
  updated_at = now()
where nullif(trim(coalesce(image_url, '')), '') is null;

-- Tambem corrige produtos que receberam imagens genericas de categoria
-- como quebra-galho antes de terem foto propria.
update public.products
set
  image_url = 'assets/brava-materiais-perfil-instagram.png',
  updated_at = now()
where image_url in (
  'assets/cleaning-bottles.jpg',
  'assets/category-produtos-limpeza.jpg',
  'assets/category-descartaveis.jpg',
  'assets/category-equipamentos.jpg',
  'assets/category-papeis-panos.jpg',
  'assets/category-aromatizadores.jpg',
  'assets/category-banheiro.jpg',
  'assets/category-cozinha.jpg',
  'assets/category-diversos.jpg'
);
