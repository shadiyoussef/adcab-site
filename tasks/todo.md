# AdCab Website — TODO

## 1. General Work Plan
Build and ship a single-page investor / marketing website for AdCab to the
Cloudflare-hosted domain **adcab.org**. The finished visual design (plain static
HTML/CSS/JS) was produced in Claude and is shipped exactly as delivered. Content is
sourced from the investor deck. No build step, no backend.

## 2. Implementation by Stages
- **Stage 1 — Integrate (MVP):** bring the static design into the project, add
  Cloudflare deploy config + project conventions. ✅
- **Stage 2 — Ship:** authenticate wrangler, deploy to Cloudflare, attach `adcab.org`
  custom domain, verify live (HTTPS, assets, fonts).
- **Stage 3 — Polish:** replace Cerullo monogram with a headshot; swap illustrative PoC
  charts for exact figures if required; optional SEO (OG image, favicon, sitemap),
  analytics, and a real contact form if desired.

## 3. Checklist
- [x] Inspect the delivered design zip
- [x] Copy exact design into `adcab-site/public/` (unchanged)
- [x] Add `wrangler.jsonc` (assets-only Worker, `not_found_handling: single-page-application`)
- [x] Add `package.json` (wrangler dev dep + deploy/preview scripts)
- [x] Add project `CLAUDE.md` + `tasks/`
- [x] Local verify: served `public/`, all assets + page return 200, refs resolve
- [x] `npm install` (wrangler 4.98.0)
- [x] `wrangler login` (user authenticated)
- [x] `npm run deploy` → deployed to Cloudflare
- [x] Attach custom domain `adcab.org` + `www.adcab.org` (via wrangler routes)
- [x] Verify live site: adcab.org + www both HTTP 200, valid SSL, correct page + assets
- [x] Add favicon (white mark on navy tile: .ico + PNG set + apple-touch + manifest)
- [x] Add OG/social preview image (1200x630 card + OG/Twitter meta)
- [ ] Replace Cerullo monogram with headshot
- [ ] Decide: keep illustrative PoC charts or swap for exact deck figures
- [ ] (Optional) re-enable workers.dev URL as fallback (`workers_dev: true`)
- [x] git init + push to GitHub (private repo shadiyoussef/adcab-site)
- [x] Invite collaborator fh230 (Write access) — invite pending acceptance

## 4. Progress
Progress: 85% (SHIPPED — live at https://adcab.org and https://www.adcab.org; remaining items are polish)

## 5. Next Actions
1. Add a favicon + OG/social preview image (link tags in `public/index.html`).
2. Source a Cerullo headshot → swap the `.member__mono` "VC" block for an `<img>`.
3. Decide whether to replace illustrative PoC charts with exact deck figures.
4. (Optional) re-enable the workers.dev URL as a fallback (`workers_dev: true`).
5. (Optional) git init + push to GitHub for version history.
