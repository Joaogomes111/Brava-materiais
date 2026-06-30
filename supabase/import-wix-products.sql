-- Brava Materiais de Limpeza
-- Importação dos produtos do site Wix antigo.
-- Fonte: https://joaoghg4.wixsite.com/my-site/produtos
-- Gerado em 2026-06-30.
-- Observação: preços não foram importados; produtos existentes mantêm os preços que já estiverem no Supabase.

begin;

with category_source as (
  select *
  from jsonb_to_recordset($$[
  {
    "slug": "produtos-de-limpeza",
    "name": "Produtos de Limpeza",
    "description": "Químicos, desinfetantes, detergentes, limpadores e soluções profissionais.",
    "image_url": "assets/category-produtos-limpeza.jpg",
    "sort_order": 10
  },
  {
    "slug": "descartaveis",
    "name": "Descartáveis",
    "description": "Luvas, máscaras, toucas, mexedores, guardanapos e itens de uso único.",
    "image_url": "assets/category-descartaveis.jpg",
    "sort_order": 20
  },
  {
    "slug": "equipamentos",
    "name": "Equipamentos",
    "description": "Mops, rodos, vassouras, pás, suportes, dispensers e acessórios.",
    "image_url": "assets/category-equipamentos.jpg",
    "sort_order": 30
  },
  {
    "slug": "papeis-e-panos",
    "name": "Papéis e Panos",
    "description": "Papéis toalha, papéis higiênicos, panos multiuso e panos de limpeza.",
    "image_url": "assets/category-papeis-panos.jpg",
    "sort_order": 40
  },
  {
    "slug": "aromatizadores",
    "name": "Aromatizadores",
    "description": "Aromatizadores, essências, águas perfumadas e itens para ambientes.",
    "image_url": "assets/category-aromatizadores.jpg",
    "sort_order": 50
  },
  {
    "slug": "banheiro",
    "name": "Banheiro",
    "description": "Sabonetes, saboneteiras, papéis, suportes, refis e itens sanitários.",
    "image_url": "assets/category-banheiro.jpg",
    "sort_order": 60
  },
  {
    "slug": "cozinha",
    "name": "Cozinha",
    "description": "Desengordurantes, detergentes, limpa-alumínio e produtos para lava-louças.",
    "image_url": "assets/category-cozinha.jpg",
    "sort_order": 70
  },
  {
    "slug": "diversos",
    "name": "Diversos",
    "description": "Itens complementares para limpeza, organização e reposição do dia a dia.",
    "image_url": "assets/category-diversos.jpg",
    "sort_order": 80
  }
]$$::jsonb)
    as x(slug text, name text, description text, image_url text, sort_order integer)
)
insert into public.categories (slug, name, description, image_url, sort_order, is_active)
select slug, name, description, image_url, sort_order, true
from category_source
on conflict (slug) do update set
  name = excluded.name,
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order,
  is_active = true,
  updated_at = now();

with product_source as (
  select *
  from jsonb_to_recordset($$[
  {
    "slug": "refil-difusor-de-varetas-250ml",
    "name": "Refil Difusor De Varetas 250ml",
    "description": "Os refis Via Aroma foram desenvolvidos para repor a sua fragrância favorita com facilidade e para nunca te deixar sem o seu produto preferido.",
    "image_url": "https://static.wixstatic.com/media/8469f3_9e7acd5a15774841a582d98ec69779da~mv2.jpg",
    "category_slug": "aromatizadores",
    "code": null,
    "featured": false,
    "sort_order": 100
  },
  {
    "slug": "vassoura-rodo-esfregao-flat-mop-slim-balde-espremedor-nobre",
    "name": "Vassoura Rodo Esfregão Flat Mop Slim Balde Espremedor Nobre",
    "description": "Flat Mop Slim (balde cinza, c/espremedor, e 1 refil de microfibra) - Nobre\nIdeal para limpar vidros, pisos, paredes, móveis e rodapés. pisos lisos de vinil, laminados, porcelanatos, madeira, cerâmicas, azulejos e mármores. Limpa sem riscar e levantar poeira. Seu refil de microfibra absorve melhor a sujeira, é removível e pode ser lavado em máquina de lavar. Fácil de montar e prático para a limpeza. Seu balde, com capacidade de 6 litros, possui sistema de dreno para remover a água após o uso. Com cabo emborrachado, muito mais conforto para suas mãos. Com espremedor para secagem rápida e trava lateral. Prática lavagem e troca do refil.",
    "image_url": "https://static.wixstatic.com/media/8469f3_aa534c2265c24a4184652767e1d34c85~mv2.png",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 101
  },
  {
    "slug": "shampoo-automotivo-com-cera-5l",
    "name": "Shampoo Automotivo Com Cera 5L",
    "description": "Super Concentrado Com Cera",
    "image_url": "https://static.wixstatic.com/media/8469f3_dde1176ec9814311828b672442b4db36~mv2.png",
    "category_slug": "produtos-de-limpeza",
    "code": "LIMP-001",
    "featured": true,
    "sort_order": 102
  },
  {
    "slug": "preteador-de-pneu-5l",
    "name": "Preteador De Pneu 5L",
    "description": "Brilho intenso, super concentrado.",
    "image_url": "https://static.wixstatic.com/media/8469f3_938755f54a24400fac40a7ade32afe13~mv2.png",
    "category_slug": "produtos-de-limpeza",
    "code": "LIMP-002",
    "featured": true,
    "sort_order": 103
  },
  {
    "slug": "limpa-pedras-quimak-5l",
    "name": "Limpa Pedras Quimak 5L",
    "description": "O Desincrustante Ácido Limpa Pedra é usado para realizar a limpeza de área que contenha pedras. Pode ser utilizado em áreas com piscinas, muros, calçadas etc.",
    "image_url": "https://static.wixstatic.com/media/8469f3_36d6bd529bc441a5835690270a948a97~mv2.png",
    "category_slug": "produtos-de-limpeza",
    "code": "LIMP-003",
    "featured": true,
    "sort_order": 104
  },
  {
    "slug": "desengraxante-quimak-5l",
    "name": "Desengraxante Quimak 5L",
    "description": "É indicado para limpeza em geral. Muito utilizado na indústria para limpeza de máquinas, motores e equipamentos, implementos agrícolas, instalações industriais, pisos cerâmicos e cimentados.",
    "image_url": "https://static.wixstatic.com/media/8469f3_772b3cc7385b45e0a32c562c00284a9a~mv2.png",
    "category_slug": "produtos-de-limpeza",
    "code": "LIMP-004",
    "featured": true,
    "sort_order": 105
  },
  {
    "slug": "agua-perfumada-via-aroma",
    "name": "Água Perfumada Via Aroma",
    "description": "Água Perfumada para Tecidos Via Aroma foi desenvolvida especialmente para criar sensações de bem-estar no seu lar.",
    "image_url": "https://static.wixstatic.com/media/8469f3_cac4fd814fce4f6ca14d81f667908c42~mv2.png",
    "category_slug": "aromatizadores",
    "code": "ARO-001",
    "featured": true,
    "sort_order": 106
  },
  {
    "slug": "essencias-via-aroma",
    "name": "Essências Via Aroma",
    "description": "- Essências com perfume presente e forte\n- Ajuda a relaxar\n- Ideal para perfumar o ambiente",
    "image_url": "https://static.wixstatic.com/media/8469f3_45a74a1269e544fabc3eec931470307a~mv2.jpg",
    "category_slug": "aromatizadores",
    "code": "ARO-002",
    "featured": false,
    "sort_order": 107
  },
  {
    "slug": "lustra-moveis-jasmin-mr-keep-750ml",
    "name": "Lustra Móveis Jasmin Mr. Keep - 750ml",
    "description": "Keep Indicado para garantir aos seus móveis proteção e brilho natural sem engordurar. Diminui a incidência de poeira, deixando no ambiente um agradável aroma de jasmim.",
    "image_url": "https://static.wixstatic.com/media/8469f3_91ab9bc42a97447a9f858b8908254778~mv2.png",
    "category_slug": "produtos-de-limpeza",
    "code": "LIMP-005",
    "featured": false,
    "sort_order": 108
  },
  {
    "slug": "sabonete-liquido-dove-5l",
    "name": "Sabonete Líquido Dove 5L",
    "description": "Sabonete Líquido Bactericida 5L\nÓtimo para banheiros comerciais",
    "image_url": "https://static.wixstatic.com/media/8469f3_42274b4142ef402f95da4168883fb642~mv2.jpg",
    "category_slug": "banheiro",
    "code": "HIG-001",
    "featured": true,
    "sort_order": 109
  },
  {
    "slug": "pasta-multiuso-rosa-500g-sany",
    "name": "Pasta Multiuso Rosa 500g - Sany",
    "description": "Pasta rosa multiuso 500G - sany mix A Pasta Multiuso Rosa é o poderoso desengordurante da linha Sany Mix! Indicado para limpeza pesada em geral, principalmente em mármores, pisos e azulejos, a Pasta Multiuso Rosa tem ação desengraxante e polidora.",
    "image_url": "https://static.wixstatic.com/media/8469f3_49b74e06adf44f7799a49bd395c4fac2~mv2.webp",
    "category_slug": "cozinha",
    "code": "COZ-001",
    "featured": false,
    "sort_order": 110
  },
  {
    "slug": "saponaceo-cremoso-lavanda-sany-300ml",
    "name": "Saponáceo Cremoso Lavanda Sany - 300ml",
    "description": "- Auxiliam na remoção da sujeira mais difícil, facilitando a limpeza. Ideal para limpar pisos, lajotas, mármores, granitos, azulejos, cubas, pias, torneiras, balcões. Também recomendado para louças sanitárias e boxes.",
    "image_url": "https://static.wixstatic.com/media/8469f3_fb7b8ce2512e4cb4b9b0a15c38f21d54~mv2.webp",
    "category_slug": "cozinha",
    "code": "COZ-002",
    "featured": false,
    "sort_order": 111
  },
  {
    "slug": "naftalina-30g-sany",
    "name": "Naftalina 30g - Sany",
    "description": "A naftalina Sany Mix foi desenvolvida para cuidar dos seus armários, gavetas, estantes e sapateiras. Mantém o ambiente livre de alguns insetos. 30g | Em bolas",
    "image_url": "https://static.wixstatic.com/media/8469f3_baa1f058483f4ff9b94992247ca4d8aa~mv2.webp",
    "category_slug": "produtos-de-limpeza",
    "code": null,
    "featured": false,
    "sort_order": 112
  },
  {
    "slug": "multi-inseticida-proinset-350ml",
    "name": "Multi Inseticida Proinset 350ml",
    "description": "o multi inseticida pro inset, de uso doméstico, é eficaz contra moscas, mosquitos e baratas. também mata o mosquito da dengue. desenvolvido em base aquosa, utiliza a mais moderna tecnologia.ação/ativos:indicação: eficaz contra insetos em ambientes abertos ou fechados.",
    "image_url": "https://static.wixstatic.com/media/8469f3_33e376ae945745e3b895b65872a01e05~mv2.webp",
    "category_slug": "produtos-de-limpeza",
    "code": null,
    "featured": false,
    "sort_order": 113
  },
  {
    "slug": "brilha-inox-spray-super-dom-300ml-acao-duradoura-brilho-dom-line",
    "name": "Brilha Inox Spray Super Dom 300ml Ação Duradoura Brilho Dom Line",
    "description": "Brilha Inox Spray Super Dom 300ml Ação Duradoura Brilho Brilha Inox Spray Super Dom 300ml Ação Duradoura Brilho O Brilho Inox Domline foi desenvolvido para o uso diário na limpeza de superfícies e utensílios de inox, alumínio, plásticos e peças esmaltadas Com uma única operação, limpa, dá brilho e protege a superfície através de uma película protetora que evita a oxidação e facilita a limpeza e a manutenção com alto rendimento Pode ser aplicado em elevadores, geladeiras, fogões, bandejas, churrasqueiras, puxadores, barras de apoio, grades, corrimões, mesas, entre outros",
    "image_url": "https://static.wixstatic.com/media/8469f3_51e57c32f6aa46ce819be89effa4d1b9~mv2.png",
    "category_slug": "cozinha",
    "code": null,
    "featured": false,
    "sort_order": 114
  },
  {
    "slug": "aromatizador-puro-ar-400ml",
    "name": "Aromatizador Puro Ar 400ml",
    "description": "O Odorizador de Ambiente Puro Ar traz praticidade e facilidade para o seu dia a dia Desenvolvido e formulado com exclusivas fragrâncias, refresca os ambientes, deixando os locais suavemente perfumados É recomendado o uso em locais como banheiros, quartos, salas e escritórios\nAromas Disponíveis -Capim e limão -Citrus -Cravo e Canela -Erva Doce -Eucalipto -Lavanda -Pétalas de rosas -Talco -Vanilla -Vinólia",
    "image_url": "https://static.wixstatic.com/media/8469f3_521e93fb36a649d6a3759fd2ff62f633~mv2.jpeg",
    "category_slug": "aromatizadores",
    "code": "ARO-003",
    "featured": false,
    "sort_order": 115
  },
  {
    "slug": "acucar-sache-caravelas-cx-1000",
    "name": "Açúcar Sache Caravelas Cx Com 1000",
    "description": "É o açúcar refinado granulado tipo exportação. Grãos menores e mais uniformes lhe conferem aparência nobre e cristalina, como pequenos diamantes. Absorve menos umidade e fica soltinho por mais tempo.",
    "image_url": "https://static.wixstatic.com/media/8469f3_b446d1684f27424898a3337d50b08e65~mv2.png",
    "category_slug": "diversos",
    "code": "DIV-001",
    "featured": false,
    "sort_order": 116
  },
  {
    "slug": "suporte-papel-higienico-rolao",
    "name": "Suporte Papel Higiênico Rolão 300m - Branco e Preto",
    "description": "Feito com materiais resistentes, duráveis e com acabamento de alto padrão, a Exaccta se torna peça-chave na composição de um ambiente moderno e requintado.- Fabricado em ABS de alta resistência ao impacto\nDisponível nas cores branco e preta",
    "image_url": "https://static.wixstatic.com/media/8469f3_f01361cf54c44eb88bac8dcdacb084bd~mv2.jpeg",
    "category_slug": "banheiro",
    "code": "HIG-003",
    "featured": false,
    "sort_order": 117
  },
  {
    "slug": "toalheiro-para-toalha-bobina",
    "name": "Toalheiro Para Toalha Bobina - Branco e Preto",
    "description": "Desenvolvido para suprir a atual necessidade dos estabelecimentos em proporcionar aos seus usuários uma experiência única a partir de um ambiente com mais personalidade e estilo próprio, sem deixar de lado, é claro, a qualidade e segurança.\nDisponível na cor branca e preta.",
    "image_url": "https://static.wixstatic.com/media/8469f3_e840303f4d0345e18480c847dd0ea210~mv2.jpeg",
    "category_slug": "banheiro",
    "code": "HIG-004",
    "featured": false,
    "sort_order": 118
  },
  {
    "slug": "saboneteira-spray-para-alcool-e-sabonete-liquido",
    "name": "Saboneteira Spray Para Álcool e Sabonete Líquido",
    "description": "O sistema spray ejeta apenas 0,25ml de sabonete a cada acionamento, garantindo até 1.600 lavagens de mão por refil. Para um perfeito processo de higiene das mãos são necessários dois acionamentos, o que resulta em 0,5ml de produto.",
    "image_url": "https://static.wixstatic.com/media/8469f3_9828e485773449f38aadde09c5167408~mv2.jpeg",
    "category_slug": "banheiro",
    "code": null,
    "featured": false,
    "sort_order": 119
  },
  {
    "slug": "suporte-papel-higienico-cai-cai-branco-e-preto",
    "name": "Suporte Papel Higiênico Cai Cai - Branco e Preto",
    "description": "Dispenser Para Papel Higiênico Interfolhado CaiCai Cipla Qualidade e Praticidade em uma linha completa Mais higiene e praticidade Uso prático sem contato com os reservatórios\nDisponível nas cores Branco e Preta",
    "image_url": "https://static.wixstatic.com/media/8469f3_ca61f14daa6f49d4b9d26c0ce50b5d61~mv2.jpeg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 120
  },
  {
    "slug": "saboneteira-pop-branca-ou-preta-com-reservatorio-de-800ml",
    "name": "Saboneteira Pop branca ou preta com reservatório de 800ml",
    "description": "Desenvolvido e fabricado com tecnologia de ponta, utilizando materiais de alta resistência. Altamente Resistente! Confeccionado em plástico ABS\nDisponível Na Cor Braca e Preta",
    "image_url": "https://static.wixstatic.com/media/8469f3_0c2e17cc01654aac8c0a5a5a4d5ad501~mv2.jpeg",
    "category_slug": "banheiro",
    "code": null,
    "featured": false,
    "sort_order": 121
  },
  {
    "slug": "refil-sabonete-proteinas-do-leite-para-saboneteira-spray-800ml",
    "name": "Refil Sabonete Proteínas do Leite Para Saboneteira Spray 800ml",
    "description": "Sua formulação equilibrada deixa a pele macia mesmo com o uso constante e repetido, possui agradável perfume de proteinas do leite. O mecanismo do spray diminui o desperdício e entupimento, com maior pulverização",
    "image_url": "https://static.wixstatic.com/media/8469f3_b3fcc775f0e94ac39db53230a55f2c05~mv2.jpeg",
    "category_slug": "banheiro",
    "code": null,
    "featured": false,
    "sort_order": 122
  },
  {
    "slug": "aromatizante-para-limpeza-asa",
    "name": "Aromatizante para limpeza Asa",
    "description": "Os aromatizadores da Linha Laranja e Canela trazem a sensação de aconchego, carinho e relaxamento.Um aroma cítrico com especiarias que promove relaxamento, ajudando o controle da ansiedade e insônia.\nAromas Disponíveis: floral, Lavanda, Talco e Laranja com canela",
    "image_url": "https://static.wixstatic.com/media/8469f3_b6584d36b47c4dd5b7f7e0363e1a709f~mv2.jpeg",
    "category_slug": "aromatizadores",
    "code": null,
    "featured": false,
    "sort_order": 123
  },
  {
    "slug": "vassouras-color-mais-sanches-com-cabo",
    "name": "Vassouras Color Mais Sanches Com Cabo",
    "description": "Traz com ela toda a praticidade da limpeza do dia a dia. Uma vassoura que contém cerdas plumadas que capturam melhor a sujeira, cerdas com aparação curva, facilitando o carregamento da sujeira.",
    "image_url": "https://static.wixstatic.com/media/8469f3_e71323cc2bf24b79ba257968372bdbfe~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 124
  },
  {
    "slug": "vassoura-classica-sanches-com-cabo",
    "name": "Vassoura Clássica Sanches Com Cabo",
    "description": "Uma vassoura que contém cerdas plumadas que capturam melhor a sujeira, cerdas com aparação curva, facilitando o carregamento da sujeira",
    "image_url": "https://static.wixstatic.com/media/8469f3_cd5351f5b0994aedbe0a320799eac6e0~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 125
  },
  {
    "slug": "touca-tnt-descartavel-100-unidades",
    "name": "Touca Tnt Descartável 100 Unidades",
    "description": "Indicada para uso na área gastronômica, estética e industrial. Possui elástico para melhor vedação. Recomendado uso único. Armazenar este produto em local limpo, seco, arejado e protegido da luz solar, vapores químicos e umidade.",
    "image_url": "https://static.wixstatic.com/media/8469f3_43a170091a974d25a55d39f35a5681e1~mv2.png",
    "category_slug": "descartaveis",
    "code": "DESC-002",
    "featured": false,
    "sort_order": 126
  },
  {
    "slug": "tela-perfumada-para-mictorio",
    "name": "Tela Perfumada Para Mictório",
    "description": "Nobre As telas para mictório são confeccionadas em pvc, criando uma Barreira de retenção de sólidos, evitando o entupimento nas Tubulações dos sanitários. Ideais para qualquer tipo de mictório, Possuem fragrâncias de ação duradoura",
    "image_url": "https://static.wixstatic.com/media/8469f3_83ad9c3b29f7490ca67c56c231a31b32~mv2.png",
    "category_slug": "aromatizadores",
    "code": null,
    "featured": false,
    "sort_order": 127
  },
  {
    "slug": "suporte-p-fibraco-manual",
    "name": "Suporte P/ Fibraço Manual",
    "description": "onfeccionado em polipropileno este produto é durável e é um aliado para a limpeza de superfícies, sem prejudicar suas mãos, pois seu cabo anatômico ajuda no seu manuseio livrando as mãos de sofrerem um machucado ou de entrarem com contato com produtos químicos no momento da limpeza.",
    "image_url": "https://static.wixstatic.com/media/8469f3_8ebcbccf3ab042e084e750ce5883214c~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 128
  },
  {
    "slug": "super-cloro-besser-5l",
    "name": "Super Cloro Besser 5L",
    "description": "Super Cloro Besser É um produto líquido a base de hipoclorito de sódio. Usado para higienização e desinfecção de banheiros, pisos, vasos sanitários, paredes, azulezos, pias, bancadas, equipamentos, utensílios, cozinhas, lixeiras, ralos e esgotos.",
    "image_url": "https://static.wixstatic.com/media/8469f3_b54cea9ff0c64a27bff608caddb79d89~mv2.png",
    "category_slug": "produtos-de-limpeza",
    "code": "LIMP-008",
    "featured": false,
    "sort_order": 129
  },
  {
    "slug": "suporte-para-fibra-26cm",
    "name": "Suporte Para Fibra 26cm",
    "description": "Suporte Para Bucha De Fibra Com Pinça Azul Suporte para buchas de fibra para Limpeza Leve Geral e Pesada, com cabo de alumínio. Ideal para limpar azulejos, paredes vidros e até mesmo para tirar o encardido de chãos.",
    "image_url": "https://static.wixstatic.com/media/8469f3_7e8563d90400477da5c113a4be6630de~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 130
  },
  {
    "slug": "secante-para-lava-loucas-5l",
    "name": "Secante Para Lava Louças 5L",
    "description": "Mult Dry é um aditivo secante líquido à base de tensoativos não iônicos, que reduzem a tensão superfi cial da água. Indicado para acelerar a secagem de utensílios lavados em máquinas automáticas. Uso em máquinas de lavar louças automáticas.",
    "image_url": "https://static.wixstatic.com/media/8469f3_ad835897a01f4cf0acccd48752d4c6b8~mv2.jpg",
    "category_slug": "cozinha",
    "code": "COZ-004",
    "featured": false,
    "sort_order": 131
  },
  {
    "slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "Sacos De Lixo De Todas Micras, Tamanhos e Cores",
    "description": "Os sacos de lixos possuem uma ótima resistência, são fabricados em polietileno. Recomendados para descartar resíduos em alta quantidade e pesados. Contamos com sacos de lixos infectante para hospitais e clínicas",
    "image_url": "https://static.wixstatic.com/media/8469f3_8d280ca1355f41aa9239118d2aab795c~mv2.jpg",
    "category_slug": "descartaveis",
    "code": null,
    "featured": false,
    "sort_order": 132
  },
  {
    "slug": "rodo-de-plastico-40cm-e-60cm",
    "name": "Rodo De Plástico 40cm e 60cm",
    "description": "Rodos plásticos 40cm, 60cm de ótima qualidade próprio para casas e banheiro e espaços maiores.",
    "image_url": "https://static.wixstatic.com/media/8469f3_b0465739a68e4169b3506f71a964ee0e~mv2.png",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 133
  },
  {
    "slug": "refil-de-mop-umido",
    "name": "Refil De Mop Umido",
    "description": "Refil para mop líquido com 85% de algodão e 15% de poliéster em sua composição. Tem alto poder de absorção e resistência. Suas pontas em Loop “arrastam” e seguram mais as sujidades otimizando a limpeza e o tempo despendido nas tarefas.",
    "image_url": "https://static.wixstatic.com/media/8469f3_6da241f33dab46b0b4fd30829f5bcfbf~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 134
  },
  {
    "slug": "refil-para-mop-giratorio-360",
    "name": "Refil Para Mop Giratório 360",
    "description": "Refil Para Mop Giratório Branco - Lavável e 100% microfibra. - Compatível com Mop Giratório de diversas marcas diferentes. Super resistente e durável, o Refil mop pode te ajudar em várias limpezas na sua casa, recomendado para limpeza de azulejo, janelas, pisos e superfícies lisas.",
    "image_url": "https://static.wixstatic.com/media/8469f3_c752f9e96c9545719e211b616e25fc29~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 135
  },
  {
    "slug": "pulverizador-500ml",
    "name": "Pulverizador 500ml",
    "description": "- Pulverizador/Borrifador Plástico para os mais variados fins\n- Uso profissional ou doméstico\n- Identificação no rótulo do conteúdo do frasco, lote e data de validade\n- Tamanho: 23cm de altura (c/ gatilho)\n- Capacidade: 500ml",
    "image_url": "https://static.wixstatic.com/media/8469f3_8b8044a4e1534524b957bc767f288341~mv2.jpg",
    "category_slug": "diversos",
    "code": null,
    "featured": false,
    "sort_order": 136
  },
  {
    "slug": "pratico-desengordurante-1l-e-5l",
    "name": "Prático Desengordurante 1L e 5L",
    "description": "O desengordurante prático é que o você precisa para auxiliar na sua limpeza. Eles limpam as sujeiras mais pesadas sem a necessidade de água. Ideal para utilização em cozinhas residenciais e industriais, pois retira com eficiência a oleosidade de fogões, pias, coifas, utensílios domésticos entre outros.",
    "image_url": "https://static.wixstatic.com/media/8469f3_14adb620f50643fc924f89c26aaa9bb6~mv2.jpg",
    "category_slug": "cozinha",
    "code": "COZ-005",
    "featured": false,
    "sort_order": 137
  },
  {
    "slug": "pedra-sanitarias-sany-25g",
    "name": "Pedra Sanitárias Sany 25g",
    "description": "O odorizante sanitário Sany Mix contém, em sua composição, substâncias capazes de perfumar o ambiente e deixar seu banheiro muito mais agradável. Você encontra o produto nas fragrâncias: Jasmin, Floral, Lavanda e Eucalipto. Versão em 25g. Composição: Aglutinante, Isotiazolinonas, Corante e Essência.",
    "image_url": "https://static.wixstatic.com/media/8469f3_71ea3912cda64e5d87ea92c91511782c~mv2.png",
    "category_slug": "aromatizadores",
    "code": null,
    "featured": false,
    "sort_order": 138
  },
  {
    "slug": "pastilhas-adesivas-sanitarias-cx-com-3",
    "name": "Pastilhas Adesivas Sanitárias Cx com 3",
    "description": "Sany Mix Pastilha Caixa Acoplada, mantém seu vaso sanitário limpo e com agradável perfume. A limpeza se inicia na caixa acoplada e se estende até as paredes do vaso sanitário, liberando uma agradável coloração na água a cada descarga.",
    "image_url": "https://static.wixstatic.com/media/8469f3_8e394f3c7b9b49e9825b293b1e993dd6~mv2.jpg",
    "category_slug": "banheiro",
    "code": null,
    "featured": false,
    "sort_order": 139
  },
  {
    "slug": "pastilha-para-caixa-acoplada-50g",
    "name": "Pastilha Para Caixa Acoplada 50g",
    "description": "Sany Mix Pastilha Caixa Acoplada, mantém seu vaso sanitário limpo e com agradável perfume. A limpeza se inicia na caixa acoplada e se estende até as paredes do vaso sanitário, liberando uma agradável coloração na água a cada descarga.",
    "image_url": "https://static.wixstatic.com/media/8469f3_69de790f8ee5491ba6164a8c575e4f58~mv2.jpg",
    "category_slug": "banheiro",
    "code": null,
    "featured": false,
    "sort_order": 140
  },
  {
    "slug": "papel-toalha-interfolhas-ipel-fit-caixa-com-5000-folhas-27g",
    "name": "Papel Toalha Interfolhas Ipel Fit Caixa com 5000 Folhas 27g",
    "description": "Toalha de Papel possui em sua formatação uma coloração extra branca e que, além de proporcionar aos usuários uma maior maciez, este produto também é superabsorvente. Portanto combate o desperdício e traz muito mais qualidade, economia e boa aparência para as empresas.",
    "image_url": "https://static.wixstatic.com/media/8469f3_15907c1fb3694e3fb0918de8f47ec5a0~mv2.png",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 141
  },
  {
    "slug": "papel-toalha-interfolhas-luxo-fardao-19g-5000-folhas",
    "name": "Papel Toalha Interfolhas luxo fardão 19g 5000 Folhas",
    "description": "Papel Toalha Interfolhas luxo fardão\nTamanho 20cm x 20cm\nToalha de Papel possui em sua formatação uma coloração extra branca e que, além de proporcionar aos usuários uma maior maciez, este produto também é superabsorvente. Portanto combate o desperdício e traz muito mais qualidade, economia e boa aparência para as empresas.",
    "image_url": "https://static.wixstatic.com/media/8469f3_4fe456e56fcf40069d20d32829977c02~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 142
  },
  {
    "slug": "papel-toalha-interfolhas-caixa-com-5000-folhas-soft-28g",
    "name": "Papel Toalha Interfolhas Caixa Com 5000 Folhas Soft 28g",
    "description": "Toalha de Papel possui em sua formatação uma coloração extra branca e que, além de proporcionar aos usuários uma maior maciez, este produto também é superabsorvente. Portanto combate o desperdício e traz muito mais qualidade, economia e boa aparência para as empresas.",
    "image_url": "https://static.wixstatic.com/media/8469f3_db1fa1cfe89d4789941adee66ea98b1b~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 143
  },
  {
    "slug": "papel-toalha-interfolhado-ipel",
    "name": "Papel Toalha Interfolhado Ipel Folha Dupla 30g Cx com 2000",
    "description": "áxima absorção e resistência. As folhas saem uma a uma da embalagem, aumentando a produtividade e diminuindo o desperdício. Toque macio, não esfarelam e não deixam resíduos nas mãos e no rosto.",
    "image_url": "https://static.wixstatic.com/media/8469f3_15907c1fb3694e3fb0918de8f47ec5a0~mv2.png",
    "category_slug": "papeis-e-panos",
    "code": "PAP-003",
    "featured": true,
    "sort_order": 144
  },
  {
    "slug": "papel-toalha-bobina-premium-38g-fardo-com-6-rolos-200m",
    "name": "Papel Toalha Bobina Premium 38g Fardo Com 6 rolos 200m",
    "description": "Papel de alta qualidade e R.U ( resistência a umidade ), não reciclado, indicado para uso em hospitais, clínicas, consultórios pois evita a contaminação após a lavagem das mãos",
    "image_url": "https://static.wixstatic.com/media/8469f3_ce7ba725a6e842589a203600ed12877b~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 145
  },
  {
    "slug": "papel-toalha-bobina-28g-fardo-com-6-rolos",
    "name": "Papel Toalha Bobina 28g Fardo Com 6 rolos",
    "description": "Papel de alta qualidade e R.U ( resistência a umidade ), não reciclado, indicado para uso em hospitais, clínicas, consultórios pois evita a contaminação após a lavagem das mãos",
    "image_url": "https://static.wixstatic.com/media/8469f3_4c81221d5d3e49198710093671503bc9~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 146
  },
  {
    "slug": "papel-toalha-bobina-ipel-28g-fardo-com-6-rolos",
    "name": "Papel Toalha Bobina Ipel 28g Fardo Com 6 rolos",
    "description": "Papel de alta qualidade e R.U ( resistência a umidade ), não reciclado, indicado para uso em hospitais, clínicas, consultórios pois evita a contaminação após a lavagem das mãos",
    "image_url": "https://static.wixstatic.com/media/8469f3_d1d5de4b321a46ba80434c67122951c9~mv2.png",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 147
  },
  {
    "slug": "papel-higienico-rolao-200mt-folha-dupla-caixa-com-8-rolos",
    "name": "Papel Higiênico Rolão 200mt Folha Dupla Caixa Com 8 rolos",
    "description": "Papel Higiênico Rolão 200mt Folha Dupla Caixa Com 8 rolos\nContém 8 rolos de 200m x 10cm",
    "image_url": "https://static.wixstatic.com/media/8469f3_26bf0b9c7b1b4cf1ae69fb4f007b69e0~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 148
  },
  {
    "slug": "papel-higienico-cai-cai-ipel",
    "name": "Papel Higiênico Cai Cai Folha Dupla Ipel Caixa com 8000 Folhas",
    "description": "Papel Higiênico Interfolhado Folha Dupla Caixa com 8000 Folhas Sulleg. Ideal para dispenser de papel higiênico, próprio para banheiros movimentados, o papel interfolha da marca Sulleg possui alto grau de alvura, alto poder de absorção, é gofrado, e macio, proporcionando conforto até para os usuários mais exigentes.",
    "image_url": "https://static.wixstatic.com/media/8469f3_a10f534734a94e84937381eb4c54b386~mv2.png",
    "category_slug": "descartaveis",
    "code": "DESC-001",
    "featured": false,
    "sort_order": 149
  },
  {
    "slug": "pano-multiuso-600-unidades",
    "name": "Pano Multiuso 600 Unidades",
    "description": "Uso geral para limpeza e secagem de superfícies e utensílios sendo direcionando para vários tipos de segmentos. Indicado para a limpeza rápida, prática e eficaz de indústrias, comércios, segmento alimentício e domiciliar. Ideal para locais onde é exigido o máximo de higiene.",
    "image_url": "https://static.wixstatic.com/media/8469f3_08e5d3a189e743f3aaa8470b0590eddf~mv2.png",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 150
  },
  {
    "slug": "pano-multiuso-60-unidades",
    "name": "Pano Multiuso 60 Unidades",
    "description": "Embalagem c/ 60 unidade. Cores: Azul; Dimensões: 30 metros X 30 cm picotado a cada 50cm; Composição: 50% Viscose e 50% Poliéster. Limpa, lava, seca e dá brilho",
    "image_url": "https://static.wixstatic.com/media/8469f3_e7cb39a03e03484280d8f9d90b4fc13a~mv2.png",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 151
  },
  {
    "slug": "pano-multiuso-nobre-5-unidades",
    "name": "Pano Multiuso Nobre 5 Unidades",
    "description": "Prático e resistente, o Pano Multiuso Nobre é ideal para a limpeza. Possui alta absorção, sendo um grande aliado para diversas necessidades. É um produto versátil, já que lava, seca, tira o pó e da brilho",
    "image_url": "https://static.wixstatic.com/media/8469f3_752a42d68bee4075b100f2afd853e288~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 152
  },
  {
    "slug": "pano-fraldina-para-limpeza",
    "name": "Pano Fraldina Para Limpeza",
    "description": "O Pano fraldinha pode ser usado tanto na cozinha quanto na limpeza da casa! É multifunção, serve como pano de copa e pia mas é bastante eficiente na limpeza de bancadas; mesas; eletrodomésticos etc.",
    "image_url": "https://static.wixstatic.com/media/8469f3_a157b79bb3de4ef1919d933b300ef782~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 153
  },
  {
    "slug": "pano-de-prato-branco",
    "name": "Pano De Prato Branco",
    "description": "Panos de prato são artigos que não pode faltar na sua cozinha para secar louças e auxiliar em alguns momentos de preparos de alimentos. -Os panos de prato são bem encorpados e reforçados garantindo a qualidade do produto",
    "image_url": "https://static.wixstatic.com/media/8469f3_b2b8a5dc826b4b2fb33e59c6491b2ffc~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 154
  },
  {
    "slug": "pano-de-chao-saco-alvejado-mesclado-35x65",
    "name": "Pano De Chão Saco Alvejado Mesclado 35X65",
    "description": "Pano para limpeza geral de pisos. CARACTERÍSTICAS DO PRODUTO: Saco para chão confeccionado com residuos testeis e algodão, pano com textura lisa. COR: Cinza",
    "image_url": "https://static.wixstatic.com/media/8469f3_c5010890dcc6444aaeedde1979a0575b~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 155
  },
  {
    "slug": "pano-de-chao-saco-alvejado-branco-40x70",
    "name": "Pano de chão saco alvejado branco 40x70",
    "description": "Panos para limpeza de chão sacos alvejados 100% algodão que é ideial para todo tipo de limpeza em geral sendo retulizavel é recomendado para os locais com todo tipo de fluxo de pessoas e que não abrem mão do padrão de qualidade. Como por exemplo: indústrias, hospitais, shoppings, aeroportos, etc.",
    "image_url": "https://static.wixstatic.com/media/8469f3_c0f74f6ea4ec418ba8aacf482d84c681~mv2.png",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 156
  },
  {
    "slug": "pano-de-chao-economico-saco-alvejado",
    "name": "Pano de chão econômico saco alvejado",
    "description": "Pano De Chão Branco Alvejado , feito com sacaria de excelente qualidade 100% algodão, super absorvente, não solta fiapos nem pelinhos, fácil de torcer, indicado para uso geral.",
    "image_url": "https://static.wixstatic.com/media/8469f3_dc188f89f5eb430c81df60654079f231~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": "PAP-002",
    "featured": false,
    "sort_order": 157
  },
  {
    "slug": "pa-jeitosa-com-cabo",
    "name": "Pá Jeitosa Com Cabo",
    "description": "á coletora para lixo com cabo de aço e lâmina flexível em PVC para ajuda na coleta de resíduos mais finos. Cabo se ajusta no corpo da pá conforme posição da coleta do lixo em relação ao solo. Com uma excelente ergonomia, evita lesões durante a limpeza, e sua manopla revestida ameniza o uso prolongado. Ideal para limpeza interna e externa, e para locais de alto tráfego que exija limpeza constante.",
    "image_url": "https://static.wixstatic.com/media/8469f3_141797d6232041148c0725bb6ec15acc~mv2.png",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 158
  },
  {
    "slug": "pa-de-lixo-coletora",
    "name": "Pá De Lixo Coletora",
    "description": "As pás coletoras possuem um design moderno que agrega eficiência, agilidade e conforto para as tarefas de limpeza.\nOutro importante diferencial do produto é a frente rebaixada, que facilita a captação da sujeira, e o encaixe angulado para o cabo, que proporciona maior ergonomia na hora da limpeza.",
    "image_url": "https://static.wixstatic.com/media/8469f3_7ee33a375c904f688330a46a7eaa9a07~mv2.png",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 159
  },
  {
    "slug": "pa-de-lixo-cabo-longo",
    "name": "Pá De Lixo Cabo Longo",
    "description": "Pá de Lixo C/ Cabo Santa Maria Pá de plástico com cabo, produto de alta resistência ideal para todos os tipos de lixo. Com cabo ergonômico fazendo com que o utilizador não precise se curvar ao pegar o lixo, prevenindo assim eventuais problemas de coluna e afastamento.",
    "image_url": "https://static.wixstatic.com/media/8469f3_c0142acc285e41f48b1b27e6e3e5e98d~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 160
  },
  {
    "slug": "pa-para-lixo-cabo-curto",
    "name": "Pá Para Lixo Cabo Curto",
    "description": "Pá para lixo plástica Cabo curto, com furo para pendurar. Disponível em várias cores. Indicado para retirar resíduos de sujeira após varrer os ambientes. Item indispensável em qualquer casa. Material de alta qualidade. Composição: Polipropileno.",
    "image_url": "https://static.wixstatic.com/media/8469f3_2883eb28e12f45dab1c0ea4482dcc09a~mv2.jpg",
    "category_slug": "diversos",
    "code": null,
    "featured": false,
    "sort_order": 161
  },
  {
    "slug": "detergente-para-maquina-de-lavar-louca",
    "name": "Detergente Para Máquina De lavar Louça",
    "description": "Detergente concentrado é especialmente indicado para utilização em máquinas de lavar louça . O produto possui baixa formação de espuma e alto poder de remoção de resíduos alimentares e gordurosos comuns em cozinhas como: gordura vegetal e animal, molhos, amidos, proteínas, etc., tudo por conter agentes desengordurantes e de limpeza especiais de alta tecnologia.",
    "image_url": "https://static.wixstatic.com/media/8469f3_d994adbfade2418ca14c1d16e9b57f51~mv2.png",
    "category_slug": "cozinha",
    "code": "COZ-006",
    "featured": false,
    "sort_order": 162
  },
  {
    "slug": "multiuso-pink-5-litros-e-1-litro-4-em-1",
    "name": "Multiuso Pink 5 litros e 1 Litro-4 em 1",
    "description": "Multiuso 4 em 1 Wave: limpa, desengordura, dá brilho e perfuma! Indicado para limpeza geral e pesada, tem o aspecto de detergente e pode ser diluído para maior rendimento: até 1 litro ou uma parte do produto com mais 10 litros ou 10 partes de água iguais.",
    "image_url": "https://static.wixstatic.com/media/8469f3_7d4dccf3fb174451a14eb0fb72c63f48~mv2.png",
    "category_slug": "cozinha",
    "code": null,
    "featured": false,
    "sort_order": 163
  },
  {
    "slug": "cera-liquida-5l",
    "name": "Cera Líquida 5L",
    "description": "Cera líquida Vermelha 5 litros Guanabara. Dá brilho em diversos tipos de piso. A base de água.",
    "image_url": "https://static.wixstatic.com/media/8469f3_5bdd242bc323483f97cebb038053763f~mv2.jpg",
    "category_slug": "produtos-de-limpeza",
    "code": "LIMP-007",
    "featured": false,
    "sort_order": 164
  },
  {
    "slug": "desinfetante-hospitalar-bactgerm",
    "name": "Desinfetante Hospitalar Bactgerm",
    "description": "Utilizado em pisos, paredes equipamentos e moveis. Produto com ação Bactericida, fungicida e virucida, seu poder tensoativo rompe as barreiras que protegem a colonia microbiana, agindo com eficiencia e rapidez. Tempo de contato 10 minutos.",
    "image_url": "https://static.wixstatic.com/media/8469f3_74650e299587435193af640de49dc71f~mv2.jpg",
    "category_slug": "produtos-de-limpeza",
    "code": "LIMP-006",
    "featured": true,
    "sort_order": 165
  },
  {
    "slug": "mult-espuma-desincrustante-5l",
    "name": "Mult Espuma Desincrustante 5L",
    "description": "Detergentes alcalinos para limpeza pesada. Indicados para remoção de gorduras carbonizadas ou não, em áreas de manipulação de alimentos em geral. Com fórmulas ricas em alcalinidade, atacam de forma eficiente as sujidades mais pesadas\nDetergentes alcalinos para limpeza pesada. Indicados para remoção de gorduras carbonizadas ou não, em áreas de manipulação de alimentos em geral. Com fórmulas ricas em alcalinidade, atacam de forma eficiente as sujidades mais pesadas",
    "image_url": "https://static.wixstatic.com/media/8469f3_b9d311d6d6f247b39722ef64460dd560~mv2.png",
    "category_slug": "cozinha",
    "code": null,
    "featured": false,
    "sort_order": 166
  },
  {
    "slug": "mop-spray-com-reservatorio-flash-limp",
    "name": "Mop Spray com reservatório Flash Limp",
    "description": "O Mop Spay da Flashlimp é indicado para limpeza rapida do dia dia. Ele substitui a vassoura, o pano, o balde e a pazinha. O Mop pode ser guardado montado e com reservatório abastecido com a solução de sua preferencia. Com isso, ele estará disponível para ser usado de maneira rápida e pratica sempre que necessário.",
    "image_url": "https://static.wixstatic.com/media/8469f3_246ea92ad6cc46c09e7b0328b105a009~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 167
  },
  {
    "slug": "mexedor-cafe-grande-500-unidades",
    "name": "Mexedor para café grande 11cm 500 unidades",
    "description": "Produzido com material convencional cristal transparente, descartável, ideal para ser utilizado como mexedor de bebidas com café, chás, chocolates e similares quentes ou frios. 11cm",
    "image_url": "https://static.wixstatic.com/media/8469f3_d01fcc23e75c4e2bb5375f420e94db63~mv2.png",
    "category_slug": "descartaveis",
    "code": "DESC-003",
    "featured": false,
    "sort_order": 168
  },
  {
    "slug": "mexedor-de-cafe-8-5-cm-500-unidades",
    "name": "Mexedor de Café 8,5 cm 500 Unidades",
    "description": "Mexedor descartável para café tipo colher, com design moderno e elegante. Ideal para misturar o cafezinho.",
    "image_url": "https://static.wixstatic.com/media/8469f3_fd792654dae34b02ae5a88dcbfeb52da~mv2.jpg",
    "category_slug": "descartaveis",
    "code": null,
    "featured": false,
    "sort_order": 169
  },
  {
    "slug": "mascara-cirurgica-tripla-bompack-50-unidades",
    "name": "Máscara Cirúrgica Tripla BomPack 50 Unidades",
    "description": "A Máscara Cirúrgica Tripla Nobre é indicada para proteção de profissionais e de pacientes durante o tratamento e procedimentos cirúrgicos e não cirúrgicos. Contém filtro para retenção bacteriológica, proporcionando segurança e conforto ao usuário. Tamanho único. Cor Branca. Contém 50 unidades.",
    "image_url": "https://static.wixstatic.com/media/8469f3_3453354fc40c4a849efa70ffce067be1~mv2.png",
    "category_slug": "diversos",
    "code": null,
    "featured": false,
    "sort_order": 170
  },
  {
    "slug": "luva-bompack-verniz-azul-5-pares",
    "name": "Luva Bompack Verniz Azul 5 Pares",
    "description": "Por não dispor de costuras, a Luva de Látex para limpeza é completamente impermeável, garantindo eficiente proteção as mãos do contato com produtos químicos – incluindo alguns abrasivos – e respingos. Confeccionada em látex, ela possui elevada aderência e palma antiderrapante que propicia mais segurança para tarefas que envolvem objetos lisos e frágeis",
    "image_url": "https://static.wixstatic.com/media/8469f3_53e5090005df41baaaec436393ee745f~mv2.jpg",
    "category_slug": "descartaveis",
    "code": null,
    "featured": false,
    "sort_order": 171
  },
  {
    "slug": "luva-plastica-descartavel-100-unidades",
    "name": "Luva Plástica Descartável Com 100 Unidades",
    "description": "Sua modelagem ambidestra garante ao produto maior versatilidade, e após um único uso, o descarte do produto deverá ser imediato. É um produto idealizado especialmente para você que merece maior cuidado para você que expõe sua mão à umidade com líquidos, principalmente detergente, água e sabão. É recomendada para operações de manipulação de alimentos em geral, seja seco ou molhado, limpeza doméstica, tinturas capitares entre outros.",
    "image_url": "https://static.wixstatic.com/media/8469f3_f9cd9aa182c5418e89cac65713acce18~mv2.jpg",
    "category_slug": "descartaveis",
    "code": "DESC-004",
    "featured": false,
    "sort_order": 172
  },
  {
    "slug": "luva-nitrilica-bompack-preta-sem-po-100-unidades",
    "name": "Luva Nitrílica BomPack Preta Sem Pó 100 Unidades",
    "description": "Luva para procedimentos não cirúrgicos, confeccionada em borracha sintética (nitrilo), palma lisa e ponta dos dedos texturizada, ambidestra, não estéril, sem pó. Pacote contém 100 unidades",
    "image_url": "https://static.wixstatic.com/media/8469f3_3160113aec364787afca95e926114892~mv2.jpg",
    "category_slug": "descartaveis",
    "code": null,
    "featured": false,
    "sort_order": 173
  },
  {
    "slug": "luva-latex-ranhurada-antiderrapante-bompack",
    "name": "Luva Latex Ranhurada Antiderrapante Bompack",
    "description": "A Luva Latex Cano Longo 37cm é indicado para trabalhos de conservação e limpeza, atividades agrícolas, manuseio com produto químico, indústria alimentícia dentre outras de uso industrial ou doméstico. Possui espessura em látex natural sem forro e conta com punho longo com detalhe sanfonado e virola, com encaixe perfeito no antebraço. É aprovada para proteção das mãos do usuário contra agentes abrasivos, escoriantes, cortantes e perfurantes.",
    "image_url": "https://static.wixstatic.com/media/8469f3_985f7e00900c40fbaa1b4bafc2206556~mv2.jpg",
    "category_slug": "descartaveis",
    "code": null,
    "featured": false,
    "sort_order": 174
  },
  {
    "slug": "luva-latex-bompack-1000-unidades",
    "name": "Luva Látex Bompack 1000 Unidades",
    "description": "As luvas descartáveis da Nobre são seguras para muitas aplicações: saúde, indústria, manuseio de alimentos, limpeza e muito mais. Elas protegem suas mãos e permitem que você trabalhe com segurança. Além disso, previnem doenças e protegem você do contato direto com todos os materiais nocivos. Luvas de látex descartáveis As luvas de látex são confortáveis de usar, higiênicas e oferecem um alto grau de flexibilidade e destreza.",
    "image_url": "https://static.wixstatic.com/media/8469f3_d084c5e6155940acb9a91dfedfd88bac~mv2.png",
    "category_slug": "descartaveis",
    "code": null,
    "featured": false,
    "sort_order": 175
  },
  {
    "slug": "lustra-moveis-nobre-200ml",
    "name": "Lustra Móveis Nobre 200ml",
    "description": "O Lustra Móveis Nobre limpa e dá brilho sem engordurar os seus móveis deixando um agradável perfume de longa duração. Sua fórmula com extra proteção forma uma camada que ajuda a proteger os seus móveis contra as indesejáveis manchas e ainda diminui a aderência da poeira.\nVolume: 200ml\nFragrância: Lavanda",
    "image_url": "https://static.wixstatic.com/media/8469f3_e7f40bb8f88044e58a686c1aae6697f9~mv2.png",
    "category_slug": "produtos-de-limpeza",
    "code": null,
    "featured": false,
    "sort_order": 176
  },
  {
    "slug": "limpa-vidros-up-pro-500ml",
    "name": "Limpa Vidros Up Pro 500ml",
    "description": "Up Glass é um detergente pronto para uso com alto poder desengordurante. Contém uma combinação detergente-solvente que promove uma total transparência, gerando o aspecto de superfície nova aos vidros e espelhos. Vidros e espelhos limpos e brilhantes para você!",
    "image_url": "https://static.wixstatic.com/media/8469f3_34e2ff9bacad4a8c9f399d2146274fa7~mv2.png",
    "category_slug": "cozinha",
    "code": null,
    "featured": false,
    "sort_order": 177
  },
  {
    "slug": "limpa-vidros-up-pro-5l",
    "name": "Limpa Vidros Up Pro 5L",
    "description": "Up Glass é um detergente pronto para uso com alto poder desengordurante. Contém uma combinação detergente-solvente que promove uma total transparência, gerando o aspecto de superfície nova aos vidros e espelhos. Vidros e espelhos limpos e brilhantes para você!",
    "image_url": "https://static.wixstatic.com/media/8469f3_800efb5c038740cbb94be0b9f1e1ce1e~mv2.png",
    "category_slug": "cozinha",
    "code": null,
    "featured": false,
    "sort_order": 178
  },
  {
    "slug": "limpa-aluminio-quimak-5l",
    "name": "Limpa Alumínio Quimak 5L",
    "description": "Produto indicado para limpar e renovar o brilho em utensílios de alumínio. Limpa e renova o brilho em uma única operação. Remove incrustações em panelas, assadeiras, bandejas, etc.",
    "image_url": "https://static.wixstatic.com/media/8469f3_14b8cf8432df4db792d1da17f42e1336~mv2.jpg",
    "category_slug": "cozinha",
    "code": null,
    "featured": false,
    "sort_order": 179
  },
  {
    "slug": "lava-roupas-besser-5l",
    "name": "Lava Roupas Besser 5L",
    "description": "Com o Sabão Líquido Concentrado, as suas roupas ficam definitivamente limpas, perfumadas e sem manchas. Esse produto é concentrado, portanto tem alta rentabilidade",
    "image_url": "https://static.wixstatic.com/media/8469f3_cfc03eb397d5449aa7e99aa42b4c75c3~mv2.png",
    "category_slug": "aromatizadores",
    "code": null,
    "featured": false,
    "sort_order": 180
  },
  {
    "slug": "guardanapo-sache-caixa-com-1000-unidades",
    "name": "Guardanapo Sachê Caixa Com 1000 Unidades",
    "description": "Guardanapos de Papel Brancos de Folhas Simples para Lanchonetes, Bares, Restaurantes e Muito Mais!\nGuardanapos brancos com folha simples. Macios e absorventes, ótimos para utilização em lanchonetes, bares, cafeterias e fast food. Conservar em local seco.",
    "image_url": "https://static.wixstatic.com/media/8469f3_f8d54ea76eff45b9b44f882b4e937a75~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 181
  },
  {
    "slug": "guardanapo-coty-29-5-x-29-5cm-50-unidades",
    "name": "Guardanapo Coty 29,5 x 29,5cm 50 Unidades",
    "description": "Guardanapos de Papel Brancos de Folhas Simples para Lanchonetes, Bares, Restaurantes e Muito Mais!\nGuardanapos brancos com folha simples. Macios e absorventes, ótimos para utilização em lanchonetes, bares, cafeterias e fast food. Conservar em local seco.",
    "image_url": "https://static.wixstatic.com/media/8469f3_f9b0912e7b024da28c22e6113369d2f1~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 182
  },
  {
    "slug": "guardanapo-coty-19-5-x-19-5-cm-50-unidades",
    "name": "Guardanapo Coty 19,5 X 19,5 Cm 50 Unidades",
    "description": "Guardanapos de Papel Brancos de Folhas Simples para Lanchonetes, Bares, Restaurantes e Muito Mais!\nGuardanapos brancos com folha simples. Macios e absorventes, ótimos para utilização em lanchonetes, bares, cafeterias e fast food. Conservar em local seco.",
    "image_url": "https://static.wixstatic.com/media/8469f3_06c6b329d1a64b6e857a3d323efc4032~mv2.jpg",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 183
  },
  {
    "slug": "gel-adesivo-sanitario-sany-mix-com-aplicador",
    "name": "Gel Adesivo Sanitário Sany Mix Com Aplicador",
    "description": "Gel Adesivo Sany Citrus Marine E Lavanda -\nFácil. Prático. Conveniente.\nEssas características fazem do Gel Adesivo da Sany Mix o seu melhor aliado na limpeza do banheiro. Seu aplicador evita que você precise tocar no produto e na parte interna do vaso sanitário.\nTudo isso de forma simples: é só colar a pastilha na parede do vaso e pronto Disponível nas fragrâncias Lavanda, Marine e Citrus, o gel é dissolvido a cada descarga e libera um agradável aroma, sem deixar nenhum resíduo.",
    "image_url": "https://static.wixstatic.com/media/8469f3_ae6d80cb97bf43d9a9827d7871a548a8~mv2.png",
    "category_slug": "aromatizadores",
    "code": null,
    "featured": false,
    "sort_order": 184
  },
  {
    "slug": "garra-haste-para-mop-umido",
    "name": "Garra / Haste Para Mop Úmido Multiuso",
    "description": "A Haste ou Garra Plástica é um acessório para fixar o refil de tecido (Mop) que será utilizado para limpeza de pisos. Para Utilização de Mop Úmido de Algodão ou Microfibra, ideal para uso comercial, hospitalar ou residências. Pode ser usado em qualquer tipo de piso que possa ser umedecido.",
    "image_url": "https://static.wixstatic.com/media/8469f3_e37696dc77024befb66ffce94f4e6ca9~mv2.png",
    "category_slug": "equipamentos",
    "code": "EQP-002",
    "featured": false,
    "sort_order": 185
  },
  {
    "slug": "flanela-de-algodao-laranja",
    "name": "Flanela De Algodão Laranja",
    "description": "Panos Flanelados para limpeza com a nova tecnologia que possui a capacidade de absorver três vezes mais que as flanelas comuns. Além de não riscar, não solta pelos e é indicado para limpeza rápida e eficaz.\nÓtima para ser utilizada em vidros, espelhos e partes internas de veículos, como pintura, faróis, cromados e etc.",
    "image_url": "https://static.wixstatic.com/media/8469f3_2a475e4bf31a49e387a9ddbbfbc210c9~mv2.png",
    "category_slug": "papeis-e-panos",
    "code": "PAP-001",
    "featured": false,
    "sort_order": 186
  },
  {
    "slug": "flanela-de-algodao-branca",
    "name": "Flanela De Algodão Branca",
    "description": "Panos Flanelados para limpeza com a nova tecnologia que possui a capacidade de absorver três vezes mais que as flanelas comuns. Além de não riscar, não solta pelos e é indicado para limpeza rápida e eficaz.",
    "image_url": "https://static.wixstatic.com/media/8469f3_80a4aed592a94bd2a3d243e416af55f1~mv2.png",
    "category_slug": "papeis-e-panos",
    "code": null,
    "featured": false,
    "sort_order": 187
  },
  {
    "slug": "fibraco-para-limpeza-pesada",
    "name": "Fibraço Para Limpeza Pesada",
    "description": "Indicado para: Limpeza pesada e ultrapesada.\nAplicar em: Chapas, grelhas, superfícies, pisos e utensílios.\nVersatilidade: Substitui com vantagens a lã e a palha de aço e pode ser usado até em superfícies quentes, o que aumenta seu poder de limpeza.",
    "image_url": "https://static.wixstatic.com/media/8469f3_6ef529ffc542489fb1c8f0404bc4c421~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 188
  },
  {
    "slug": "fibraco-branco-leve",
    "name": "Fibraço Branco Leve",
    "description": "Indicado para superfícies delicadas que exigem cuidado na sua limpeza. Por nao possuir abrasivo, ela não risca.\nProduto Sem Abrasivo,\nEvita A Formação De Biofilmes Que Tendem A Formar-Se Em Superfícies Irregulares Evitando A Ocorrências De Contaminação De Alimentos",
    "image_url": "https://static.wixstatic.com/media/8469f3_46d146c5d8e34f3b865933df9474514e~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 189
  },
  {
    "slug": "fibraco-10cm",
    "name": "Fibraço 10cm",
    "description": "Indicado para remoção da sujeira em chapas e grelhas, superfícies, pisos e utensílios, substituindo a lã e a palha de aço. É resistente quando utilizado sobre superfícies ainda quentes, o que aumenta seu poder de limpeza.",
    "image_url": "https://static.wixstatic.com/media/8469f3_74a8fd31720e418ea538da4163df40f4~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 190
  },
  {
    "slug": "aromatizador-eletrico",
    "name": "Aromatizador Elétrico",
    "description": "O Aromatizador Elétrico Original é um aparelho feito de porcelana e plastico resistente, desenvolvido e fabricado pela Via Aroma.\nEle viabiliza o uso de essências e óleos essenciais com praticidade, economia e segurança.",
    "image_url": "https://static.wixstatic.com/media/8469f3_1f386eb3910a42df9a1d494fe36e82b6~mv2.jpg",
    "category_slug": "aromatizadores",
    "code": null,
    "featured": false,
    "sort_order": 191
  },
  {
    "slug": "esponja-passa-cera-com-cabo",
    "name": "Esponja Passa Cera Com Cabo",
    "description": "Essa espuma é perfeita para dar brilho em sua cerâmica, deixando o chão muito mais bonito e brilhoso, além disso pode usar com tranquilidade pois não irá riscar ou danificar o piso.\nPode ser usada em cabos de vassoura ou rodo",
    "image_url": "https://static.wixstatic.com/media/8469f3_b95311ade2174b14a7c7c477b15005e9~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 192
  },
  {
    "slug": "esponja-limpa-azulejo-com-cabo",
    "name": "Esponja Limpa Azulejo Com Cabo",
    "description": "Esponja colada à base de plástico com cabo de madeira de 1,2m. Ideal para esfregar o chão ou superfícies sem precisar se agaixar ou colocar as mãos direto na esponja. Não possui refil de troca, a esponja é grudada...",
    "image_url": "https://static.wixstatic.com/media/8469f3_c7d94ef6c2d045f091e3c6b94710f7cd~mv2.jpg",
    "category_slug": "produtos-de-limpeza",
    "code": null,
    "featured": false,
    "sort_order": 193
  },
  {
    "slug": "esponja-dupla-face",
    "name": "Esponja Dupla Face",
    "description": "Esponja multiuso dupla face: verde e amarela. Com íons de prata, para lavar qualquer superfície. A face amarela é para limpeza delicada, para não arranhar. A face verde é para esfregação. Indicado usar com sabões e detergentes, evitar usar com produtos à base de álcool. Preço de uma unidade - medidas: 11x7,5x2cm.",
    "image_url": "https://static.wixstatic.com/media/8469f3_92303924dc3341a5acc384dc6d62f466~mv2.jpg",
    "category_slug": "cozinha",
    "code": null,
    "featured": false,
    "sort_order": 194
  },
  {
    "slug": "espanador-de-po-30cm",
    "name": "Espanador De Pó 30cm",
    "description": "Os espanadores são indicados para limpeza geral, podendo ser utilizados desde na simples limpeza de móveis, carros, computadores, até locais de difícil acesso como prateleiras de lojas, vitrines, limpeza de cristais, lustres, etc.",
    "image_url": "https://static.wixstatic.com/media/8469f3_0cce3b77a23f4b5a811e86ca2e7704c2~mv2.png",
    "category_slug": "diversos",
    "code": null,
    "featured": false,
    "sort_order": 195
  },
  {
    "slug": "escova-sanitaria-com-suporte",
    "name": "Escova Sanitária Com Suporte",
    "description": "Escova sanitária com cerdas de nylon, corpo de plástico. Acompanha suporte tipo \"potinho\" para apoio, em plástico.",
    "image_url": "https://static.wixstatic.com/media/8469f3_65b00cbadceb444da3a7dbb7567ae31d~mv2.jpg",
    "category_slug": "banheiro",
    "code": null,
    "featured": false,
    "sort_order": 196
  },
  {
    "slug": "escova-oval",
    "name": "Escova Oval",
    "description": "A Escova oval é um equipamento fundamental na lavanderia de toda casa, sendo perfeita para lavar e esfregar superfícies rústicas e semirrústicas como roupas, azulejos, pneus e todo o tipo de superfície.",
    "image_url": "https://static.wixstatic.com/media/8469f3_ff4cd0721ae343af9738e8bd37a018d7~mv2.jpg",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 197
  },
  {
    "slug": "escova-multiuso-cabo-longo",
    "name": "Escova Multiuso Cabo Longo",
    "description": "Escava Azul Bettanin SuperPro Cabo Longo com 48cm\nEscova com cabo longo e firme e cerdas duras e firmes para uso profissional e residencial em limpeza pesada.\nPode ser utilizada em pisos, paredes, madeiras, roupas grossas entre outros.",
    "image_url": "https://static.wixstatic.com/media/8469f3_02fd3407b2884ee980e8a054ea0fef57~mv2.png",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 198
  },
  {
    "slug": "detergente-neutro-besser-5l",
    "name": "Detergente Neutro Besser 5L",
    "description": "Detergente neutro galão de 5 litros. Para limpeza em geral e de louças. Por seu neutro, pode ser usado em diversas louças ou superfícies, sem danificar. Ação que limpa e desengordura. Produto de alto rendimento.",
    "image_url": "https://static.wixstatic.com/media/8469f3_7b0bf801abbe4386b9fc68dd230cb0af~mv2.png",
    "category_slug": "cozinha",
    "code": null,
    "featured": false,
    "sort_order": 199
  },
  {
    "slug": "detergente-clorado-besser-5l",
    "name": "Detergente Clorado Besser 5L",
    "description": "O Cloro Gel é poderoso para desinfecção do ambiente. Ele ajuda na prevenção do mofo, podendo ser usado por exemplo: em cozinhas, restaurantes, frigoríficos, indústrias de alimentação e afins. Ideal também para limpeza de sanitários e canis, pois, é um poderoso agente contra germes e bactérias.",
    "image_url": "https://static.wixstatic.com/media/8469f3_e015970e83134932b9745c37f4252f31~mv2.png",
    "category_slug": "banheiro",
    "code": null,
    "featured": false,
    "sort_order": 200
  },
  {
    "slug": "detergente-ype-500ml",
    "name": "Detergente Ypê 500ml",
    "description": "Detergente neutro 500ml Ypê. Para limpeza geral e de louças. Por seu neutro, pode ser usado em diversas louças ou superfícies, sem danificar.",
    "image_url": "https://static.wixstatic.com/media/8469f3_fd83710d5acb4de2ba3870316c2afca3~mv2.png",
    "category_slug": "cozinha",
    "code": null,
    "featured": false,
    "sort_order": 201
  },
  {
    "slug": "desinfetante-besser-5l-lavanda",
    "name": "Desinfetante Besser 5L Lavanda",
    "description": "Para limpeza, desinfecção e aromatização. Desinfetante perfumado, pode ser usado puro ou diluir em água até 1:10, ou seja, misturar 1 litro ou uma parte do produto com até mais 10 litros ou 10 partes de água iguais",
    "image_url": "https://static.wixstatic.com/media/8469f3_f387500d46af40c0a2cdc5c14ebfff81~mv2.png",
    "category_slug": "aromatizadores",
    "code": null,
    "featured": false,
    "sort_order": 202
  },
  {
    "slug": "desinfetante-concentrado-quimak-5l",
    "name": "Desinfetante Concentrado Quimak 5L",
    "description": "Desinfetante multiuso para uso geral, indicado para todos os tipos de piso, banheiros, e qualquer ambiente que necessite limpeza e aromatização. Super concentrado\nNão indicado usar puro, pois sua concentração pode manchar as superfícies, já que a consistência pura possui grande volume de corante e matérias primas. Como exemplo, pode-se misturar um copinho plástico de cafézinho (50ml) em uma bombona com 5 litros de água",
    "image_url": "https://static.wixstatic.com/media/8469f3_4a3703f0205a476db3f65d6422a928d6~mv2.jpg",
    "category_slug": "aromatizadores",
    "code": null,
    "featured": false,
    "sort_order": 203
  },
  {
    "slug": "desinfetante-besser-5l-brisa-do-mar",
    "name": "Desinfetante Besser 5L Brisa Do Mar",
    "description": "Para limpeza, desinfecção e aromatização. Desinfetante perfumado, pode ser usado puro ou diluir em água até 1:10, ou seja, misturar 1 litro ou uma parte do produto com até mais 10 litros ou 10 partes de água iguais.",
    "image_url": "https://static.wixstatic.com/media/8469f3_f05d8e3ea10c4a80a854e1a335fbdf45~mv2.jpg",
    "category_slug": "aromatizadores",
    "code": null,
    "featured": false,
    "sort_order": 204
  },
  {
    "slug": "desincrustante-e-desengraxante-quimak-5l",
    "name": "Desincrustante e Desengraxante Quimak 5L",
    "description": "Desengraxante para limpeza pesada em geral. Produto concentrado 1:400, ou seja, pode ser diluído 1 litro ou uma parte do produto com mais 400 litros ou 400 partes de água iguais. O produto pode ser utilizado puro, porém quanto maior a concentração de produto, mais ele vai clarear e limpar a superície que tiver contato, por isso é necessário espalhar ele homogeneamente sobre a superfície a ser limpa, para que fique todo o perímetro igualmente desengraxado. Indicado para pisos, paredes, peças de mecânica e qualquer superfície ou instrumento com alto grau de gordura, graxa, óleo, etc. Não contém ácidos. Gera espuma.",
    "image_url": "https://static.wixstatic.com/media/8469f3_9e9276a2a6b542b39a817fa71cc69f0d~mv2.jpg",
    "category_slug": "produtos-de-limpeza",
    "code": null,
    "featured": false,
    "sort_order": 205
  },
  {
    "slug": "desengraxante-concentrado-5l",
    "name": "Desengraxante Concentrado 5L",
    "description": "Desengraxante para limpeza pesada em geral. Produto concentrado 1:400, ou seja, pode ser diluído 1 litro ou uma parte do produto com mais 400 litros ou 400 partes de água iguais.",
    "image_url": "https://static.wixstatic.com/media/8469f3_0b2627cf38f64e80b31d11f01989e975~mv2.png",
    "category_slug": "produtos-de-limpeza",
    "code": null,
    "featured": false,
    "sort_order": 206
  },
  {
    "slug": "copo-descartavel-180ml-agua-100-unidades",
    "name": "Copo Descartável 180ml Água 100 Unidades",
    "description": "Copo descartável de água 180ml com 100 undiades (transparente). Uma caixa fechada contém 25 tiras de 100 unidades, ou seja, 2.500 copos. Para comprar uma caixa fechada, compre 25 unidades desta oferta.",
    "image_url": "https://static.wixstatic.com/media/8469f3_2182dbf4f5a94631b3b440e96d041247~mv2.jpg",
    "category_slug": "descartaveis",
    "code": null,
    "featured": false,
    "sort_order": 207
  },
  {
    "slug": "copos-80ml-cha-100-unidades",
    "name": "Copos 80ml Chá 100 Unidades",
    "description": "Copo descartável de 80ml cada (maior do que de cafézinho de 50ml), fabricado em PS (poliestireno), branco, pacote/tira com 100 unidades. Uma caixa fechada contém 25 tiras de 100 unidades, ou seja, 2.500 copos. Para comprar uma caixa fechada, compre 25 unidades desta oferta.",
    "image_url": "https://static.wixstatic.com/media/8469f3_1ac02edfec5349c78a8aa4cc314de5ff~mv2.jpg",
    "category_slug": "descartaveis",
    "code": null,
    "featured": false,
    "sort_order": 208
  },
  {
    "slug": "copos-50ml-cafe-100-unidades",
    "name": "Copos 50ml Café 100 Unidades",
    "description": "Copo descartável de 50ml cada, fabricado em PS (poliestireno), branco, pacote/tira com 100 unidades",
    "image_url": "https://static.wixstatic.com/media/8469f3_2ed34eae876d48e7be31c462e6e60796~mv2.jpg",
    "category_slug": "descartaveis",
    "code": null,
    "featured": false,
    "sort_order": 209
  },
  {
    "slug": "refil-de-mop-po-40cm",
    "name": "Refil De Mop Pó 40cm",
    "description": "Refil individual em acrílico de largura 40 cm. Para mop modelo Profi.",
    "image_url": "https://static.wixstatic.com/media/8469f3_2ade7d35c5054d2bb032e7a4cf08b367~mv2.png",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 210
  },
  {
    "slug": "balde-mop-360",
    "name": "Balde Mop 360º",
    "description": "Balde plástico de 12 litros com centrífuga que gira 360º + cabo 1,1m com armação + 1 refil. O balde não possui pedal. O cabo inclina 180º, faiciltando a limpeza em baixo de móveis. Indicado utilizar o balde com aprox. 7 litros de água ou solução; utilizar com produtos líquidos. Refil de microfibra substituível, pode ser usado seco ou molhado.",
    "image_url": "https://static.wixstatic.com/media/8469f3_de1754bad8f2433abe781184d5cf840d~mv2.png",
    "category_slug": "equipamentos",
    "code": null,
    "featured": false,
    "sort_order": 211
  },
  {
    "slug": "amaciante-5l",
    "name": "Amaciante 5L",
    "description": "Amaciante concentrado Tix de 5 litros. Amacia e perfuma todos os tipos de tecido. Proporciona um toque macio e sedoso, deixando as roupas macias e perfumadas, comfragrância suradoura e agradável.",
    "image_url": "https://static.wixstatic.com/media/8469f3_4787b9150c7c40a6a7ffbe0426af488c~mv2.png",
    "category_slug": "aromatizadores",
    "code": null,
    "featured": false,
    "sort_order": 212
  },
  {
    "slug": "alvejante-sem-cloro-5l",
    "name": "Alvejante Sem Cloro 5L",
    "description": "O Alvejante sem cloro é muito usado para clarear tecidos e roupas na lavagem. Pode ser aplicado direto na mancha. Não deixar secar no tecido. Indicado para roupas brancas e coloridas. Também pode ser usado na limpeza, pois sua ação clareadora limpa profundamente pisos, paredes e qualquer superfície lavável. Contém suave perfume. Embalagem com 5 litros.",
    "image_url": "https://static.wixstatic.com/media/8469f3_495dd13a37464f45857e578f6ca6d447~mv2.png",
    "category_slug": "produtos-de-limpeza",
    "code": null,
    "featured": false,
    "sort_order": 213
  },
  {
    "slug": "alcool-para-rechaud",
    "name": "Álcool Para Rechaud",
    "description": "Excelente para acender churrasqueiras, lareiras e fogueiras. Não explosivo.",
    "image_url": "https://static.wixstatic.com/media/8469f3_6cd812743350452384ae3ccaa8467c0c~mv2.jpg",
    "category_slug": "produtos-de-limpeza",
    "code": null,
    "featured": false,
    "sort_order": 214
  },
  {
    "slug": "alcool-liquido-1l-e-5l-70",
    "name": "Álcool Líquido 1L e 5L 70%",
    "description": "Álcool líquido 70% de 1 litro para uso geral. Conhecido como álcool hospitalar, indicado para limpeza e desinfecção.",
    "image_url": "https://static.wixstatic.com/media/8469f3_9d16589dd95c49b3bb813732e70dcb3e~mv2.jpg",
    "category_slug": "produtos-de-limpeza",
    "code": null,
    "featured": false,
    "sort_order": 215
  },
  {
    "slug": "alcool-gel-pump-500ml",
    "name": "Álcool Gel Pump 500ml",
    "description": "Suporte plástico 500ml com válvula pump + produto dentro. O Gel Antisséptico é indicado para a proteção e o cuidado das mãos de maneira fácil e rápida. Produto para uso em estabelecimentos de assistência à saúde.",
    "image_url": "https://static.wixstatic.com/media/8469f3_92399f79db744fd5a95713b62d683eb7~mv2.jpg",
    "category_slug": "produtos-de-limpeza",
    "code": null,
    "featured": false,
    "sort_order": 216
  },
  {
    "slug": "alcool-gel-5l-70",
    "name": "Álcool Gel 5L 70%",
    "description": "Álcool líquido 70% galão de 5 litros. Ideal para limpeza e desinfecção de qualquer superfície. Produto inflamável.",
    "image_url": "https://static.wixstatic.com/media/8469f3_4553de9557b24fe184b6fda0ed36f435~mv2.jpg",
    "category_slug": "produtos-de-limpeza",
    "code": null,
    "featured": false,
    "sort_order": 217
  },
  {
    "slug": "agua-sanitaria-besser-5l",
    "name": "Água Sanitária Besser 5L",
    "description": "Indicado para limpeza e desinfecção de sanitários, equipamentos, alvejamento de roupas, etc. A base de hipoclorito de sódio.",
    "image_url": "https://static.wixstatic.com/media/8469f3_23e05ba210dd4815a5f5909a4034e450~mv2.png",
    "category_slug": "banheiro",
    "code": null,
    "featured": false,
    "sort_order": 218
  }
]$$::jsonb)
    as x(slug text, name text, description text, image_url text, category_slug text, code text, featured boolean, sort_order integer)
)
insert into public.products (category_id, slug, name, description, image_url, price_label, code, featured, active, sort_order)
select c.id, p.slug, p.name, p.description, p.image_url, null, p.code, p.featured, true, p.sort_order
from product_source p
left join public.categories c on c.slug = p.category_slug
on conflict (slug) do update set
  category_id = coalesce(excluded.category_id, public.products.category_id),
  name = excluded.name,
  description = excluded.description,
  image_url = coalesce(nullif(excluded.image_url, ''), public.products.image_url),
  code = coalesce(public.products.code, excluded.code),
  price_label = public.products.price_label,
  featured = public.products.featured or excluded.featured,
  active = true,
  sort_order = excluded.sort_order,
  updated_at = now();

with variant_source as (
  select *
  from jsonb_to_recordset($$[
  {
    "product_slug": "refil-difusor-de-varetas-250ml",
    "name": "Baby",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 1
  },
  {
    "product_slug": "refil-difusor-de-varetas-250ml",
    "name": "Bamboo",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 2
  },
  {
    "product_slug": "refil-difusor-de-varetas-250ml",
    "name": "Black vanilla",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 3
  },
  {
    "product_slug": "refil-difusor-de-varetas-250ml",
    "name": "Buenos Aires",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 4
  },
  {
    "product_slug": "refil-difusor-de-varetas-250ml",
    "name": "Londres",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 5
  },
  {
    "product_slug": "agua-perfumada-via-aroma",
    "name": "Black vanilla",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 1
  },
  {
    "product_slug": "agua-perfumada-via-aroma",
    "name": "Baby",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 2
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Vanilla",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 1
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Black vanilla",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 2
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Canela",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 3
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Delicate",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 4
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Breeze",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 5
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Lavanda",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 6
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Macadamia",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 7
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Capim Limão",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 8
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Madeira Nobre",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 9
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Bamboo",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 10
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Baby",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 11
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Flor de Cerejeira",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 12
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Flor de Laranjeira",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 13
  },
  {
    "product_slug": "essencias-via-aroma",
    "name": "Flor de Algodão",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 14
  },
  {
    "product_slug": "aromatizador-puro-ar-400ml",
    "name": "Pétalas de rosas",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 1
  },
  {
    "product_slug": "aromatizador-puro-ar-400ml",
    "name": "Lavanda",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 2
  },
  {
    "product_slug": "aromatizador-puro-ar-400ml",
    "name": "Talco",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 3
  },
  {
    "product_slug": "aromatizador-puro-ar-400ml",
    "name": "Capim Limão",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 4
  },
  {
    "product_slug": "suporte-papel-higienico-rolao",
    "name": "Branco",
    "code": null,
    "price_label": null,
    "description": "Cor",
    "sort_order": 1
  },
  {
    "product_slug": "suporte-papel-higienico-rolao",
    "name": "Preto",
    "code": null,
    "price_label": null,
    "description": "Cor",
    "sort_order": 2
  },
  {
    "product_slug": "toalheiro-para-toalha-bobina",
    "name": "Branco",
    "code": null,
    "price_label": null,
    "description": "Cor",
    "sort_order": 1
  },
  {
    "product_slug": "toalheiro-para-toalha-bobina",
    "name": "Preto",
    "code": null,
    "price_label": null,
    "description": "Cor",
    "sort_order": 2
  },
  {
    "product_slug": "suporte-papel-higienico-cai-cai-branco-e-preto",
    "name": "Branco",
    "code": null,
    "price_label": null,
    "description": "Cor",
    "sort_order": 1
  },
  {
    "product_slug": "suporte-papel-higienico-cai-cai-branco-e-preto",
    "name": "Preto",
    "code": null,
    "price_label": null,
    "description": "Cor",
    "sort_order": 2
  },
  {
    "product_slug": "saboneteira-pop-branca-ou-preta-com-reservatorio-de-800ml",
    "name": "Branco",
    "code": null,
    "price_label": null,
    "description": "Cor",
    "sort_order": 1
  },
  {
    "product_slug": "saboneteira-pop-branca-ou-preta-com-reservatorio-de-800ml",
    "name": "Preto",
    "code": null,
    "price_label": null,
    "description": "Cor",
    "sort_order": 2
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "20l Preto C100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 1
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "20L Preto Reforçado",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 2
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "20L Branco C100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 3
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "20L Transparente c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 4
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "30l Hospitalar c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 5
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "40L Preto c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 6
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "40L Branco c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 7
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "40L Transparente c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 8
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "50L Hospitalar c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 9
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "60L Preto c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 10
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "60L Preto Reforçado",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 11
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "60L Branco c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 12
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "60L Transparente c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 13
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "100L Preto c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 14
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "100L Preto Reforçado",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 15
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "100L Preto Reforçado 012",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 16
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "100L Preto Reforçado 020",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 17
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "100L Branco c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 18
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "100L Transparente c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 19
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "100L Hospitalar Reforçado 08",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 20
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "150L Preto Reforçado 012",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 21
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "200L Preto Reforçado c100",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 22
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "200L Preto Reforçado c50",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 23
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "300L Preto Reforçado c50",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 24
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "name": "300L Preto Reforçado 012 c50",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 25
  },
  {
    "product_slug": "pratico-desengordurante-1l-e-5l",
    "name": "5l",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 1
  },
  {
    "product_slug": "pratico-desengordurante-1l-e-5l",
    "name": "1l",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 2
  },
  {
    "product_slug": "pastilha-para-caixa-acoplada-50g",
    "name": "Pinho",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 1
  },
  {
    "product_slug": "pano-multiuso-60-unidades",
    "name": "Azul",
    "code": null,
    "price_label": null,
    "description": "Cor",
    "sort_order": 1
  },
  {
    "product_slug": "pano-multiuso-60-unidades",
    "name": "Verde",
    "code": null,
    "price_label": null,
    "description": "Cor",
    "sort_order": 2
  },
  {
    "product_slug": "pano-de-chao-saco-alvejado-branco-40x70",
    "name": "xadrez",
    "code": null,
    "price_label": null,
    "description": "Cor",
    "sort_order": 1
  },
  {
    "product_slug": "multiuso-pink-5-litros-e-1-litro-4-em-1",
    "name": "1l",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 1
  },
  {
    "product_slug": "luva-bompack-verniz-azul-5-pares",
    "name": "p",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 1
  },
  {
    "product_slug": "luva-bompack-verniz-azul-5-pares",
    "name": "m",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 2
  },
  {
    "product_slug": "luva-bompack-verniz-azul-5-pares",
    "name": "g",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 3
  },
  {
    "product_slug": "luva-nitrilica-bompack-preta-sem-po-100-unidades",
    "name": "p",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 1
  },
  {
    "product_slug": "luva-nitrilica-bompack-preta-sem-po-100-unidades",
    "name": "m",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 2
  },
  {
    "product_slug": "luva-nitrilica-bompack-preta-sem-po-100-unidades",
    "name": "g",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 3
  },
  {
    "product_slug": "luva-latex-ranhurada-antiderrapante-bompack",
    "name": "p",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 1
  },
  {
    "product_slug": "luva-latex-ranhurada-antiderrapante-bompack",
    "name": "m",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 2
  },
  {
    "product_slug": "luva-latex-ranhurada-antiderrapante-bompack",
    "name": "g",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 3
  },
  {
    "product_slug": "luva-latex-bompack-1000-unidades",
    "name": "p",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 1
  },
  {
    "product_slug": "luva-latex-bompack-1000-unidades",
    "name": "m",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 2
  },
  {
    "product_slug": "luva-latex-bompack-1000-unidades",
    "name": "g",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 3
  },
  {
    "product_slug": "gel-adesivo-sanitario-sany-mix-com-aplicador",
    "name": "Pinho",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 1
  },
  {
    "product_slug": "gel-adesivo-sanitario-sany-mix-com-aplicador",
    "name": "Lavanda",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 2
  },
  {
    "product_slug": "gel-adesivo-sanitario-sany-mix-com-aplicador",
    "name": "Marine",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 3
  },
  {
    "product_slug": "aromatizador-eletrico",
    "name": "Plástico",
    "code": null,
    "price_label": null,
    "description": "Construção",
    "sort_order": 1
  },
  {
    "product_slug": "aromatizador-eletrico",
    "name": "Porcelana",
    "code": null,
    "price_label": null,
    "description": "Construção",
    "sort_order": 2
  },
  {
    "product_slug": "desinfetante-concentrado-quimak-5l",
    "name": "Lavanda",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 1
  },
  {
    "product_slug": "desinfetante-concentrado-quimak-5l",
    "name": "Talco",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 2
  },
  {
    "product_slug": "desinfetante-concentrado-quimak-5l",
    "name": "Eucalipto Limão",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 3
  },
  {
    "product_slug": "desinfetante-besser-5l-brisa-do-mar",
    "name": "Floral",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 1
  },
  {
    "product_slug": "refil-de-mop-po-40cm",
    "name": "40cm",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 1
  },
  {
    "product_slug": "refil-de-mop-po-40cm",
    "name": "80cm",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 2
  },
  {
    "product_slug": "refil-de-mop-po-40cm",
    "name": "60cm",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 3
  },
  {
    "product_slug": "amaciante-5l",
    "name": "Branco",
    "code": null,
    "price_label": null,
    "description": "Fragrância",
    "sort_order": 1
  },
  {
    "product_slug": "alvejante-sem-cloro-5l",
    "name": "Quimak",
    "code": null,
    "price_label": null,
    "description": "Concentrado",
    "sort_order": 1
  },
  {
    "product_slug": "alcool-liquido-1l-e-5l-70",
    "name": "5l",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 1
  },
  {
    "product_slug": "alcool-liquido-1l-e-5l-70",
    "name": "1l",
    "code": null,
    "price_label": null,
    "description": "Tamanho",
    "sort_order": 2
  }
]$$::jsonb)
    as x(product_slug text, name text, code text, price_label text, description text, sort_order integer)
)
insert into public.product_variants (product_id, name, code, price_label, description, active, sort_order)
select p.id, v.name, v.code, v.price_label, v.description, true, v.sort_order
from variant_source v
join public.products p on p.slug = v.product_slug
where not exists (
  select 1
  from public.product_variants existing
  where existing.product_id = p.id
    and lower(existing.name) = lower(v.name)
);

commit;
