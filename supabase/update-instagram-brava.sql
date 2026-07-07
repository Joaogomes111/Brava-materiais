-- Brava Materiais de Limpeza
-- Atualiza o link do Instagram da empresa.
-- Execute uma vez no SQL Editor do Supabase.

update public.company_settings
set
  instagram_url = 'https://www.instagram.com/bravamateriais/',
  updated_at = now()
where id = true;
