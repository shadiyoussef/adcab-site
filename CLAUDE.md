# AdCab Website — Project Instructions

Project-specific directives. See `~/.claude/CLAUDE.md` for global conventions.

## What this is
Single-page investor / marketing website for **AdCab** — a pre-clinical oncolytic
adenovirus armed with a novel Fc Dual Engager, spinning out of Prof. Vincenzo Cerullo's
IVT Lab (University of Helsinki). Raising €4M (matched 1:1 → €8M) toward Phase I.

## Stack & key decisions
- **Plain static site** — HTML + CSS + vanilla JS. **No build step, no framework, no
  backend.** The visual design was produced in Claude and is shipped *exactly as
  delivered*; do not restyle or re-architect it without explicit instruction.
  (The earlier Vite+React plan was superseded once the finished static design arrived.)
- **Single source of content:** all copy/data is inline in `public/index.html`, grouped
  by `<section id="…">`. Brand tokens (navy `#0E2841`, magenta `#E5197D`, type) are CSS
  variables in `:root` at the top of `public/adcab.css`.
- **JS** (`public/adcab.js`): canvas hero particles, scroll-reveal, count-ups, nav state.
- **Only external dependency:** Google Fonts (Schibsted Grotesk, IBM Plex Mono) via
  `<link>` in `index.html`.

## Hosting
- **Cloudflare Workers static assets** (assets-only Worker). Config: `wrangler.jsonc`,
  `assets.directory = ./public`.
- **Custom domain:** `adcab.org` (purchased on Cloudflare).
- Deploy: `npm run deploy` (`wrangler deploy`). Local preview: `npm run preview`
  (serves `public/` on :8000) or `npm run dev` (wrangler).

## Known placeholders to revisit
- **Prof. Vincenzo Cerullo** shows a "VC" monogram — swap `.member__mono` for an `<img>`
  in the Team section once a headshot is supplied.
- Proof-of-concept charts (§ `#data`) are clean *illustrative* SVG recreations of the
  deck figures, simplified. Replace with exact figures if precise values are required.
- Contact is a `mailto:` to `Firas.hamdanhissaoui@helsinki.fi`.

## Source material
The investor deck (`../AdCab Deck_to investors  (1) (2).pdf`), 5-minute pitch transcript,
and `Five minute.pptx` in the parent `firas adcab/` folder are the content source of truth.

## Guardrails
- Ship the design as-is; content edits happen in `public/index.html`.
- Ask before adding dependencies or build tooling (this is intentionally buildless).
- Confirm before deploying or changing DNS / custom-domain settings.
