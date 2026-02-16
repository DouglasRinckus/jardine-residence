# Domínio personalizado — GitHub Pages + Registro.br

Este guia explica como configurar **imoveis.silvanaduarteimoveis.com.br** (ou o domínio raiz) para o site no repositório **jardine-residence**.

---

## Opção recomendada: subdomínio (imoveis.silvanaduarteimoveis.com.br)

Usar o **subdomínio** costuma ser mais simples e evita conflito com o site principal em silvanaduarteimoveis.com.br.

### 1. No Registro.br (DNS)

No **modo avançado** do DNS, configure **apenas** o subdomínio:

| TIPO  | NOME (host) | DADOS (valor)              |
|-------|-------------|----------------------------|
| CNAME | **imoveis** | **douglasrinckus.github.io** |

- **NOME:** em muitos painéis você digita só `imoveis` (o Registro.br completa com `.silvanaduarteimoveis.com.br`).
- Se o Registro.br pedir o nome completo, use: `imoveis.silvanaduarteimoveis.com.br`.
- **Não** use `www` no valor. O valor deve ser exatamente `douglasrinckus.github.io` (sem https, sem barra).

Remova ou não crie CNAME para **www** ou para o domínio raiz se estiverem apontando para o GitHub neste mesmo projeto.

### 2. No GitHub

1. Repositório **jardine-residence** → **Settings** → **Pages**.
2. Em **Custom domain**, coloque exatamente:  
   **imoveis.silvanaduarteimoveis.com.br**
3. Clique em **Save**.
4. Aguarde alguns minutos (até 24–48 h em casos de propagação lenta). O GitHub vai mostrar “DNS check successful” quando estiver correto.
5. Depois que o DNS estiver OK, marque **Enforce HTTPS**.

### 3. Arquivo CNAME no repositório

O arquivo **CNAME** na raiz do repositório (já criado) deve conter **apenas** uma linha:

```
imoveis.silvanaduarteimoveis.com.br
```

Sem `http://`, sem `https://`, sem barra no final. Isso mantém o domínio customizado mesmo após novos deploys.

---

## Se quiser usar o domínio raiz (silvanaduarteimoveis.com.br)

O domínio raiz **não** pode usar CNAME no Registro.br para o GitHub. É preciso usar **registros A** apontando para os IPs do GitHub Pages.

### 1. No Registro.br (DNS)

Configure os **4 registros A** para o **nome do domínio raiz** (ex.: `silvanaduarteimoveis.com.br` ou o host que o Registro.br usar para o apex):

| TIPO | NOME (host) | DADOS (IP)        |
|------|-------------|-------------------|
| A    | @ ou silvanaduarteimoveis.com.br | 185.199.108.153 |
| A    | @ ou silvanaduarteimoveis.com.br | 185.199.109.153 |
| A    | @ ou silvanaduarteimoveis.com.br | 185.199.110.153 |
| A    | @ ou silvanaduarteimoveis.com.br | 185.199.111.153 |

Alguns provedores permitem só um A por host; nesse caso use um dos IPs (ex.: 185.199.108.153). O ideal é ter os quatro para redundância.

**Subdomínio www (opcional):**

| TIPO  | NOME | DADOS                    |
|-------|------|--------------------------|
| CNAME | www  | douglasrinckus.github.io |

**Importante:** remova o A que hoje aponta para **144.22.157.65** no domínio raiz, senão o tráfego não vai para o GitHub Pages.

### 2. No GitHub

1. Em **Settings** → **Pages** → **Custom domain**, coloque:  
   **silvanaduarteimoveis.com.br**
2. Salve e aguarde a validação do DNS.
3. Depois, ative **Enforce HTTPS**.

### 3. Arquivo CNAME

Na raiz do repositório, o **CNAME** deve ter apenas:

```
silvanaduarteimoveis.com.br
```

---

## Erros que você viu e o que fazer

- **InvalidDNSError / "Domain's DNS record could not be retrieved"**  
  - DNS ainda não propagou, ou o registro está incorreto.  
  - Confirme no Registro.br: para o subdomínio **imoveis**, o CNAME deve ter valor **douglasrinckus.github.io**.  
  - Use ferramentas como [dnschecker.org](https://dnschecker.org) para ver se o CNAME já aparece no mundo todo.

- **NotServedByPagesError / "Domain does not resolve to the GitHub Pages server"**  
  - O domínio está apontando para outro IP (no seu caso, 144.22.157.65).  
  - Para o **domínio raiz**, troque os A para os IPs do GitHub (185.199.108.153, etc.).  
  - Para o **subdomínio**, use CNAME para **douglasrinckus.github.io** e não use A para o subdomínio.

---

## Resumo rápido (subdomínio imoveis)

1. **Registro.br:** CNAME `imoveis` → `douglasrinckus.github.io`.  
2. **GitHub:** Settings → Pages → Custom domain = `imoveis.silvanaduarteimoveis.com.br` → Save.  
3. **Repositório:** arquivo **CNAME** na raiz com: `imoveis.silvanaduarteimoveis.com.br`.  
4. Aguardar propagação (minutos a algumas horas).  
5. Quando o DNS estiver OK, marcar **Enforce HTTPS** no GitHub.

Depois disso, o site deve abrir em **https://imoveis.silvanaduarteimoveis.com.br/** (e o redirect para `/jardine/` continuará funcionando).
