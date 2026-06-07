# AdCab — Investor / Marketing Website

Single-page static site for **AdCab** (oncolytic immunotherapy). Plain HTML/CSS/JS —
no build step, no dependencies, no backend. Deployed to **Cloudflare** at **adcab.org**.

## Structure
```
adcab-site/
├── public/             # the site (exact design — deploy root)
│   ├── index.html      # all 15 sections, inline content
│   ├── adcab.css       # design system + component styles (:root brand tokens)
│   ├── adcab.js        # hero particles, scroll reveals, count-ups, nav state
│   └── assets/         # logo, diagrams, team photos, partner logos
├── wrangler.jsonc      # Cloudflare Workers static-assets config
├── package.json        # wrangler scripts
├── CLAUDE.md           # project instructions
└── tasks/              # todo.md, lessons.md
```

## Run locally
```
npm run preview          # serves public/ at http://localhost:8000
# or
npm run dev              # wrangler dev (emulates the Cloudflare runtime)
```

## Deploy to Cloudflare
```
npm install              # installs wrangler
npx wrangler login       # one-time auth (interactive) — or set CLOUDFLARE_API_TOKEN
npm run deploy           # wrangler deploy → https://adcab.<account>.workers.dev
```
Then attach the custom domain **adcab.org** in the Cloudflare dashboard
(Workers & Pages → adcab → Settings → Domains & Routes → Add custom domain),
or via `wrangler`. DNS is already on Cloudflare since the domain was purchased there.

## Auto-deploy (CI)
Every push to `main` auto-deploys to Cloudflare via GitHub Actions
(`.github/workflows/deploy.yml`, using `cloudflare/wrangler-action`). It can also be
triggered manually from the repo's **Actions** tab ("Run workflow").

Required repo secrets (Settings → Secrets and variables → Actions):
- `CLOUDFLARE_ACCOUNT_ID` — already set.
- `CLOUDFLARE_API_TOKEN` — create in Cloudflare (My Profile → API Tokens →
  **Edit Cloudflare Workers** template; scope it to this account, and ensure the zone
  `adcab.org` is included so custom-domain routes can be (re)applied). Add it with:
  ```
  gh secret set CLOUDFLARE_API_TOKEN --repo shadiyoussef/adcab-site
  ```
  Contributors no longer need their own Cloudflare login — merging to `main` ships it.

## Editing content
All copy/data is inline in `public/index.html`, grouped by `<section id="…">`
(`#problem`, `#solution`, `#technology`, `#data`, `#market`, `#team`, `#contact`, …).
Brand tokens are CSS variables at the top of `public/adcab.css`.

## Known placeholders
- Prof. Vincenzo Cerullo shows a "VC" monogram — swap for a headshot when available.
- Proof-of-concept charts are illustrative SVG recreations of the deck figures.
- Contact is a `mailto:` to `Firas.hamdanhissaoui@helsinki.fi`.
