# Supabase

Arquivos desta pasta:

- `schema.sql`: cria tabelas, politicas de seguranca e bucket de imagens.
- `seed.sql`: insere dados iniciais da Brava para demonstracao.

## Ordem De Execucao

1. Abrir o projeto no Supabase.
2. Ir em `SQL Editor`.
3. Executar `schema.sql`.
4. Executar `seed.sql`.

## Liberar Um Usuario Como Administrador

Depois de criar um usuario em `Authentication > Users`, copie o `User UID` e rode:

```sql
insert into public.admin_profiles (id, name)
values ('COLE_AQUI_O_USER_UID', 'Administrador Brava');
```

Sem isso, o usuario pode ate existir no Auth, mas nao tera permissao de editar produtos, categorias, banners e dados da empresa.
