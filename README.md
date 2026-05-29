# Brava Materiais de Limpeza - Site Catalogo

Primeira versao do novo site catalogo da Brava Materiais de Limpeza, criada a partir do conteudo publicado no site Wix atual.

## O Que Esta Pronto

- Pagina inicial responsiva
- Banner principal editavel pelo painel demonstrativo
- Categorias de produtos
- Catalogo com busca, filtro por categoria e ordenacao
- Cards de produto com imagem, descricao, codigo, preco opcional e destaque
- Modal de detalhes do produto
- Botao de orcamento via WhatsApp por produto
- Pagina de contato
- Rodape completo com contatos, endereco e CNPJ
- Painel admin demonstrativo em `admin.html`
- Estrutura inicial do banco Supabase em `supabase/schema.sql`
- Dados iniciais em `supabase/seed.sql`
- Plano de implantacao em `docs/plano-implantacao.md`

## Como Abrir Localmente

Abra o arquivo `index.html` no navegador.

Paginas:

- `index.html`
- `catalogo.html`
- `contato.html`
- `admin.html`

Login demonstrativo do painel:

```text
E-mail: admin@brava.local
Senha: brava123
```

Nesta primeira versao, as alteracoes feitas no painel ficam salvas no navegador via `localStorage`. Isso permite validar a experiencia do cliente antes de conectar o Supabase.

## Stack Recomendada Para Producao

Versao inicial economica:

```text
HTML/CSS/JavaScript estatico + Vercel + Supabase
```

Evolucao recomendada quando o catalogo crescer:

```text
Next.js + Supabase + Vercel
```

O banco ja foi modelado pensando nessa evolucao futura, com campos para SKU, estoque e preco numerico.

## Proximos Passos

1. Subir estes arquivos para o GitHub.
2. Publicar o projeto na Vercel.
3. Criar projeto no Supabase.
4. Executar `supabase/schema.sql`.
5. Executar `supabase/seed.sql`.
6. Criar usuario administrador no Supabase Auth.
7. Conectar o painel ao Supabase.
8. Apontar o dominio da empresa para a Vercel.
