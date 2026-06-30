-- Brava Materiais de Limpeza
-- Recategorizacao dos produtos atuais para permitir multiplas categorias.
-- Execute depois de supabase/product-categories.sql.

begin;

with assignments as (
  select *
  from jsonb_to_recordset($$[
  {
    "product_slug": "refil-difusor-de-varetas-250ml",
    "category_slug": "aromatizadores",
    "sort_order": 1
  },
  {
    "product_slug": "vassoura-rodo-esfregao-flat-mop-slim-balde-espremedor-nobre",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "shampoo-automotivo-com-cera-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "preteador-de-pneu-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "limpa-pedras-quimak-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "desengraxante-quimak-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "desengraxante-quimak-5l",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "agua-perfumada-via-aroma",
    "category_slug": "aromatizadores",
    "sort_order": 1
  },
  {
    "product_slug": "essencias-via-aroma",
    "category_slug": "aromatizadores",
    "sort_order": 1
  },
  {
    "product_slug": "lustra-moveis-jasmin-mr-keep-750ml",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "sabonete-liquido-dove-5l",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "pasta-multiuso-rosa-500g-sany",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "pasta-multiuso-rosa-500g-sany",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "saponaceo-cremoso-lavanda-sany-300ml",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "saponaceo-cremoso-lavanda-sany-300ml",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "saponaceo-cremoso-lavanda-sany-300ml",
    "category_slug": "banheiro",
    "sort_order": 3
  },
  {
    "product_slug": "naftalina-30g-sany",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "multi-inseticida-proinset-350ml",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "brilha-inox-spray-super-dom-300ml-acao-duradoura-brilho-dom-line",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "brilha-inox-spray-super-dom-300ml-acao-duradoura-brilho-dom-line",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "aromatizador-puro-ar-400ml",
    "category_slug": "aromatizadores",
    "sort_order": 1
  },
  {
    "product_slug": "acucar-sache-caravelas-cx-1000",
    "category_slug": "diversos",
    "sort_order": 1
  },
  {
    "product_slug": "suporte-papel-higienico-rolao",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "suporte-papel-higienico-rolao",
    "category_slug": "equipamentos",
    "sort_order": 2
  },
  {
    "product_slug": "suporte-papel-higienico-rolao",
    "category_slug": "papeis-e-panos",
    "sort_order": 3
  },
  {
    "product_slug": "toalheiro-para-toalha-bobina",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "toalheiro-para-toalha-bobina",
    "category_slug": "equipamentos",
    "sort_order": 2
  },
  {
    "product_slug": "toalheiro-para-toalha-bobina",
    "category_slug": "papeis-e-panos",
    "sort_order": 3
  },
  {
    "product_slug": "saboneteira-spray-para-alcool-e-sabonete-liquido",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "saboneteira-spray-para-alcool-e-sabonete-liquido",
    "category_slug": "equipamentos",
    "sort_order": 2
  },
  {
    "product_slug": "suporte-papel-higienico-cai-cai-branco-e-preto",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "suporte-papel-higienico-cai-cai-branco-e-preto",
    "category_slug": "equipamentos",
    "sort_order": 2
  },
  {
    "product_slug": "suporte-papel-higienico-cai-cai-branco-e-preto",
    "category_slug": "papeis-e-panos",
    "sort_order": 3
  },
  {
    "product_slug": "saboneteira-pop-branca-ou-preta-com-reservatorio-de-800ml",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "saboneteira-pop-branca-ou-preta-com-reservatorio-de-800ml",
    "category_slug": "equipamentos",
    "sort_order": 2
  },
  {
    "product_slug": "refil-sabonete-proteinas-do-leite-para-saboneteira-spray-800ml",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "aromatizante-para-limpeza-asa",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "aromatizante-para-limpeza-asa",
    "category_slug": "aromatizadores",
    "sort_order": 2
  },
  {
    "product_slug": "vassouras-color-mais-sanches-com-cabo",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "vassoura-classica-sanches-com-cabo",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "touca-tnt-descartavel-100-unidades",
    "category_slug": "descartaveis",
    "sort_order": 1
  },
  {
    "product_slug": "tela-perfumada-para-mictorio",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "tela-perfumada-para-mictorio",
    "category_slug": "aromatizadores",
    "sort_order": 2
  },
  {
    "product_slug": "suporte-p-fibraco-manual",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "super-cloro-besser-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "super-cloro-besser-5l",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "super-cloro-besser-5l",
    "category_slug": "banheiro",
    "sort_order": 3
  },
  {
    "product_slug": "suporte-para-fibra-26cm",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "secante-para-lava-loucas-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "secante-para-lava-loucas-5l",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "sacos-de-lixo-de-todas-micras-tamanhos-e-cores",
    "category_slug": "descartaveis",
    "sort_order": 1
  },
  {
    "product_slug": "rodo-de-plastico-40cm-e-60cm",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "refil-de-mop-umido",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "refil-para-mop-giratorio-360",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "pulverizador-500ml",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "pratico-desengordurante-1l-e-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "pratico-desengordurante-1l-e-5l",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "pedra-sanitarias-sany-25g",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "pastilhas-adesivas-sanitarias-cx-com-3",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "pastilha-para-caixa-acoplada-50g",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "papel-toalha-interfolhas-ipel-fit-caixa-com-5000-folhas-27g",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "papel-toalha-interfolhas-luxo-fardao-19g-5000-folhas",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "papel-toalha-interfolhas-caixa-com-5000-folhas-soft-28g",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "papel-toalha-interfolhado-ipel",
    "category_slug": "descartaveis",
    "sort_order": 1
  },
  {
    "product_slug": "papel-toalha-interfolhado-ipel",
    "category_slug": "papeis-e-panos",
    "sort_order": 2
  },
  {
    "product_slug": "papel-toalha-bobina-premium-38g-fardo-com-6-rolos-200m",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "papel-toalha-bobina-28g-fardo-com-6-rolos",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "papel-toalha-bobina-ipel-28g-fardo-com-6-rolos",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "papel-higienico-rolao-200mt-folha-dupla-caixa-com-8-rolos",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "papel-higienico-rolao-200mt-folha-dupla-caixa-com-8-rolos",
    "category_slug": "papeis-e-panos",
    "sort_order": 2
  },
  {
    "product_slug": "papel-higienico-cai-cai-ipel",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "papel-higienico-cai-cai-ipel",
    "category_slug": "equipamentos",
    "sort_order": 2
  },
  {
    "product_slug": "papel-higienico-cai-cai-ipel",
    "category_slug": "papeis-e-panos",
    "sort_order": 3
  },
  {
    "product_slug": "pano-multiuso-600-unidades",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "pano-multiuso-60-unidades",
    "category_slug": "descartaveis",
    "sort_order": 1
  },
  {
    "product_slug": "pano-multiuso-60-unidades",
    "category_slug": "papeis-e-panos",
    "sort_order": 2
  },
  {
    "product_slug": "pano-multiuso-nobre-5-unidades",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "pano-fraldina-para-limpeza",
    "category_slug": "cozinha",
    "sort_order": 1
  },
  {
    "product_slug": "pano-fraldina-para-limpeza",
    "category_slug": "equipamentos",
    "sort_order": 2
  },
  {
    "product_slug": "pano-de-prato-branco",
    "category_slug": "cozinha",
    "sort_order": 1
  },
  {
    "product_slug": "pano-de-prato-branco",
    "category_slug": "descartaveis",
    "sort_order": 2
  },
  {
    "product_slug": "pano-de-prato-branco",
    "category_slug": "papeis-e-panos",
    "sort_order": 3
  },
  {
    "product_slug": "pano-de-chao-saco-alvejado-mesclado-35x65",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "pano-de-chao-saco-alvejado-branco-40x70",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "pano-de-chao-economico-saco-alvejado",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "pa-jeitosa-com-cabo",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "pa-de-lixo-coletora",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "pa-de-lixo-cabo-longo",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "pa-para-lixo-cabo-curto",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "detergente-para-maquina-de-lavar-louca",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "detergente-para-maquina-de-lavar-louca",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "multiuso-pink-5-litros-e-1-litro-4-em-1",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "multiuso-pink-5-litros-e-1-litro-4-em-1",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "cera-liquida-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "desinfetante-hospitalar-bactgerm",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "desinfetante-hospitalar-bactgerm",
    "category_slug": "banheiro",
    "sort_order": 2
  },
  {
    "product_slug": "mult-espuma-desincrustante-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "mult-espuma-desincrustante-5l",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "mop-spray-com-reservatorio-flash-limp",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "mexedor-cafe-grande-500-unidades",
    "category_slug": "cozinha",
    "sort_order": 1
  },
  {
    "product_slug": "mexedor-cafe-grande-500-unidades",
    "category_slug": "descartaveis",
    "sort_order": 2
  },
  {
    "product_slug": "mexedor-de-cafe-8-5-cm-500-unidades",
    "category_slug": "cozinha",
    "sort_order": 1
  },
  {
    "product_slug": "mexedor-de-cafe-8-5-cm-500-unidades",
    "category_slug": "descartaveis",
    "sort_order": 2
  },
  {
    "product_slug": "mascara-cirurgica-tripla-bompack-50-unidades",
    "category_slug": "descartaveis",
    "sort_order": 1
  },
  {
    "product_slug": "luva-bompack-verniz-azul-5-pares",
    "category_slug": "descartaveis",
    "sort_order": 1
  },
  {
    "product_slug": "luva-plastica-descartavel-100-unidades",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "luva-plastica-descartavel-100-unidades",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "luva-plastica-descartavel-100-unidades",
    "category_slug": "descartaveis",
    "sort_order": 3
  },
  {
    "product_slug": "luva-nitrilica-bompack-preta-sem-po-100-unidades",
    "category_slug": "descartaveis",
    "sort_order": 1
  },
  {
    "product_slug": "luva-latex-ranhurada-antiderrapante-bompack",
    "category_slug": "descartaveis",
    "sort_order": 1
  },
  {
    "product_slug": "luva-latex-bompack-1000-unidades",
    "category_slug": "descartaveis",
    "sort_order": 1
  },
  {
    "product_slug": "luva-latex-bompack-1000-unidades",
    "category_slug": "papeis-e-panos",
    "sort_order": 2
  },
  {
    "product_slug": "lustra-moveis-nobre-200ml",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "limpa-vidros-up-pro-500ml",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "limpa-vidros-up-pro-500ml",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "limpa-vidros-up-pro-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "limpa-vidros-up-pro-5l",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "limpa-aluminio-quimak-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "limpa-aluminio-quimak-5l",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "lava-roupas-besser-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "guardanapo-sache-caixa-com-1000-unidades",
    "category_slug": "cozinha",
    "sort_order": 1
  },
  {
    "product_slug": "guardanapo-sache-caixa-com-1000-unidades",
    "category_slug": "descartaveis",
    "sort_order": 2
  },
  {
    "product_slug": "guardanapo-sache-caixa-com-1000-unidades",
    "category_slug": "papeis-e-panos",
    "sort_order": 3
  },
  {
    "product_slug": "guardanapo-coty-29-5-x-29-5cm-50-unidades",
    "category_slug": "cozinha",
    "sort_order": 1
  },
  {
    "product_slug": "guardanapo-coty-29-5-x-29-5cm-50-unidades",
    "category_slug": "descartaveis",
    "sort_order": 2
  },
  {
    "product_slug": "guardanapo-coty-29-5-x-29-5cm-50-unidades",
    "category_slug": "papeis-e-panos",
    "sort_order": 3
  },
  {
    "product_slug": "guardanapo-coty-19-5-x-19-5-cm-50-unidades",
    "category_slug": "cozinha",
    "sort_order": 1
  },
  {
    "product_slug": "guardanapo-coty-19-5-x-19-5-cm-50-unidades",
    "category_slug": "descartaveis",
    "sort_order": 2
  },
  {
    "product_slug": "guardanapo-coty-19-5-x-19-5-cm-50-unidades",
    "category_slug": "papeis-e-panos",
    "sort_order": 3
  },
  {
    "product_slug": "gel-adesivo-sanitario-sany-mix-com-aplicador",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "garra-haste-para-mop-umido",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "flanela-de-algodao-laranja",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "flanela-de-algodao-branca",
    "category_slug": "papeis-e-panos",
    "sort_order": 1
  },
  {
    "product_slug": "fibraco-para-limpeza-pesada",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "fibraco-branco-leve",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "fibraco-10cm",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "aromatizador-eletrico",
    "category_slug": "aromatizadores",
    "sort_order": 1
  },
  {
    "product_slug": "esponja-passa-cera-com-cabo",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "esponja-passa-cera-com-cabo",
    "category_slug": "equipamentos",
    "sort_order": 2
  },
  {
    "product_slug": "esponja-limpa-azulejo-com-cabo",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "esponja-dupla-face",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "esponja-dupla-face",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "esponja-dupla-face",
    "category_slug": "equipamentos",
    "sort_order": 3
  },
  {
    "product_slug": "espanador-de-po-30cm",
    "category_slug": "diversos",
    "sort_order": 1
  },
  {
    "product_slug": "escova-sanitaria-com-suporte",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "escova-sanitaria-com-suporte",
    "category_slug": "equipamentos",
    "sort_order": 2
  },
  {
    "product_slug": "escova-oval",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "escova-multiuso-cabo-longo",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "detergente-neutro-besser-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "detergente-neutro-besser-5l",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "detergente-clorado-besser-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "detergente-clorado-besser-5l",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "detergente-clorado-besser-5l",
    "category_slug": "banheiro",
    "sort_order": 3
  },
  {
    "product_slug": "detergente-ype-500ml",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "detergente-ype-500ml",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "desinfetante-besser-5l-lavanda",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "desinfetante-besser-5l-lavanda",
    "category_slug": "banheiro",
    "sort_order": 2
  },
  {
    "product_slug": "desinfetante-concentrado-quimak-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "desinfetante-concentrado-quimak-5l",
    "category_slug": "banheiro",
    "sort_order": 2
  },
  {
    "product_slug": "desinfetante-besser-5l-brisa-do-mar",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "desinfetante-besser-5l-brisa-do-mar",
    "category_slug": "banheiro",
    "sort_order": 2
  },
  {
    "product_slug": "desincrustante-e-desengraxante-quimak-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "desincrustante-e-desengraxante-quimak-5l",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "desengraxante-concentrado-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "desengraxante-concentrado-5l",
    "category_slug": "cozinha",
    "sort_order": 2
  },
  {
    "product_slug": "copo-descartavel-180ml-agua-100-unidades",
    "category_slug": "cozinha",
    "sort_order": 1
  },
  {
    "product_slug": "copo-descartavel-180ml-agua-100-unidades",
    "category_slug": "descartaveis",
    "sort_order": 2
  },
  {
    "product_slug": "copos-80ml-cha-100-unidades",
    "category_slug": "cozinha",
    "sort_order": 1
  },
  {
    "product_slug": "copos-80ml-cha-100-unidades",
    "category_slug": "descartaveis",
    "sort_order": 2
  },
  {
    "product_slug": "copos-50ml-cafe-100-unidades",
    "category_slug": "cozinha",
    "sort_order": 1
  },
  {
    "product_slug": "copos-50ml-cafe-100-unidades",
    "category_slug": "descartaveis",
    "sort_order": 2
  },
  {
    "product_slug": "refil-de-mop-po-40cm",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "balde-mop-360",
    "category_slug": "equipamentos",
    "sort_order": 1
  },
  {
    "product_slug": "amaciante-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "alvejante-sem-cloro-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "alvejante-sem-cloro-5l",
    "category_slug": "banheiro",
    "sort_order": 2
  },
  {
    "product_slug": "alvejante-sem-cloro-5l",
    "category_slug": "descartaveis",
    "sort_order": 3
  },
  {
    "product_slug": "alcool-para-rechaud",
    "category_slug": "cozinha",
    "sort_order": 1
  },
  {
    "product_slug": "alcool-liquido-1l-e-5l-70",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "alcool-gel-pump-500ml",
    "category_slug": "banheiro",
    "sort_order": 1
  },
  {
    "product_slug": "alcool-gel-pump-500ml",
    "category_slug": "equipamentos",
    "sort_order": 2
  },
  {
    "product_slug": "alcool-gel-5l-70",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "alcool-gel-5l-70",
    "category_slug": "banheiro",
    "sort_order": 2
  },
  {
    "product_slug": "agua-sanitaria-besser-5l",
    "category_slug": "produtos-de-limpeza",
    "sort_order": 1
  },
  {
    "product_slug": "agua-sanitaria-besser-5l",
    "category_slug": "banheiro",
    "sort_order": 2
  }
]$$::jsonb)
    as x(product_slug text, category_slug text, sort_order integer)
), affected_products as (
  select distinct p.id
  from public.products p
  join assignments a on a.product_slug = p.slug
), removed_links as (
  delete from public.product_categories pc
  using affected_products ap
  where pc.product_id = ap.id
  returning pc.product_id
), inserted_links as (
  insert into public.product_categories (product_id, category_id, sort_order)
  select p.id, c.id, a.sort_order
  from assignments a
  join public.products p on p.slug = a.product_slug
  join public.categories c on c.slug = a.category_slug
  on conflict (product_id, category_id) do update set
    sort_order = excluded.sort_order
  returning product_id, category_id
), primary_assignments as (
  select distinct on (a.product_slug) a.product_slug, a.category_slug
  from assignments a
  order by a.product_slug, a.sort_order
)
update public.products p
set category_id = c.id,
    updated_at = now()
from primary_assignments pa
join public.categories c on c.slug = pa.category_slug
where p.slug = pa.product_slug;

commit;
