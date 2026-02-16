# GitHub Pages: Jardine e Nilo — como subir e domínios

## Plano gratuito: dá para os dois?

**Sim.** Você pode ter os dois no plano gratuito, de dois jeitos:

---

### Opção 1: Mesmo repositório, mesmo domínio, URLs diferentes (recomendado)

Tudo continua no **mesmo repo** (ex.: `jardine-residence`). O GitHub Pages publica a pasta do repositório. Aí você usa **caminhos diferentes**:

| Site   | URL de acesso |
|--------|-------------------------------|
| Jardine | `https://seu-usuario.github.io/jardine-residence/site/` (ou seu domínio customizado + `/site/`) |
| Nilo    | `https://seu-usuario.github.io/jardine-residence/Nilo/` (ou seu domínio + `/Nilo/`) |

- **Vantagem:** um único repositório, uma única publicação, domínio único (se tiver customizado).
- **Como:** a raiz do repo já tem `index.html` que redireciona para `/site/`. A página do Nilo fica em `Nilo/index.html`. Depois do push, acesse `/Nilo/` no mesmo domínio do Pages.

---

### Opção 2: Dois repositórios = dois sites (e dois domínios possíveis)

Criar **outro repositório** só para o Nilo (ex.: `nilo-empreendimento`). Cada repositório pode ter **um** GitHub Pages e **um** domínio customizado.

| Site   | Repositório        | URL típica | Domínio customizado (ex.) |
|--------|---------------------|------------|----------------------------|
| Jardine | `jardine-residence` | `...github.io/jardine-residence` | `jardine.com` |
| Nilo   | `nilo-empreendimento` | `...github.io/nilo-empreendimento` | `nilo.com` |

- **Vantagem:** sites e domínios totalmente separados.
- **Como:** copiar a pasta `Nilo` (e o que mais fizer sentido) para um repo novo, configurar o Pages nesse repo e, se quiser, apontar outro domínio nas configurações do repositório.

---

## Resumo

- **Mais de um site no gratuito?** Sim: vários repos = vários sites; ou um repo com várias pastas = um site com várias URLs.
- **Mesmo domínio, URLs diferentes?** Sim: use **Opção 1** (um repo, pastas `site/` e `Nilo/`).
- **Domínios diferentes (ex.: jardine.com e nilo.com)?** Use **Opção 2** (dois repositórios e um domínio customizado por repo).

A página do Nilo foi feita para funcionar na **Opção 1** (acesso por `.../Nilo/` no mesmo repo). Se depois você criar um repo só para o Nilo, basta ajustar os caminhos dos assets (CSS, imagens) para o novo contexto.
