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
  custom domain, verify live (HTTPS, assets, fonts). ✅
- **Stage 3 — Polish:** favicon + OG/social card ✅; git repo + collaborator ✅;
  SOM funnel formatting fix ✅. Remaining: Cerullo headshot, decide on PoC charts,
  optional CI auto-deploy / analytics / contact form.

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
- [x] Add OG/social preview image (1200x630 card + OG/Twitter meta + canonical)
- [x] git init + push to GitHub (private repo shadiyoussef/adcab-site)
- [x] Invite collaborator fh230 (Write access) — invite pending acceptance
- [x] Fix SOM `$481M–1.2B` overflow in market funnel (verified headless, overflow=false)
- [ ] Cousin (fh230) accepts the GitHub invite
- [ ] Replace Cerullo monogram with headshot
- [ ] Decide: keep illustrative PoC charts or swap for exact deck figures
- [x] GitHub Actions auto-deploy workflow (.github/workflows/deploy.yml) + ACCOUNT_ID secret
- [ ] Add `CLOUDFLARE_API_TOKEN` repo secret to activate auto-deploy (user-created token)
- [ ] (Optional) re-enable workers.dev URL as fallback (`workers_dev: true`)
- [ ] (Optional) analytics + real contact form

## 4. Progress
Progress: 95% (SHIPPED & polished — live at https://adcab.org / www, favicon + social
card, in version control with a collaborator. Remaining items are optional/content.)

## 5. Next Actions
1. Have fh230 accept the GitHub collaborator invite, then clone + `npm run preview`.
2. Source a Prof. Cerullo headshot → swap the `.member__mono` "VC" block for an `<img>`.
3. Decide whether to replace the illustrative PoC charts with exact deck figures.
4. (Optional) set up GitHub Actions auto-deploy so contributor merges publish themselves.
5. (Optional) add analytics and/or a real contact form.
