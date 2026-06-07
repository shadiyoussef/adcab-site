# AdCab Website — Lessons

Patterns learned from corrections on this project. Review at the start of each session.

- **Ship the delivered design exactly.** The visual design is produced in Claude and
  handed over as finished static files. Integrate and deploy as-is — don't rebuild it in
  a framework or restyle it unless explicitly asked. (Origin: the plan assumed
  Vite+React; the user instead delivered a complete static HTML/CSS/JS design and asked
  for the *exact* design to be shipped.)

- **Headless Chrome clamps the viewport to a 500px minimum.** Both `--headless` and
  `--headless=new` render at >=500px CSS width even with `--window-size=390`, but still
  write the image at the requested width — so content looks "cut off" when it's really
  just a 500px render cropped to 390. Verify mobile overflow with an on-page check
  (`document.documentElement.scrollWidth > innerWidth`), not by eyeballing a sub-500
  screenshot. (Origin: the SOM funnel "overflow" was a screenshot artifact, not a bug.)

- **CSS grid/flex overflow fix = `minmax(0, 1fr)` + `min-width: 0`.** A `1fr` track and
  flex items default to `min-width: auto` (min-content), so a `white-space: nowrap` child
  refuses to shrink and overflows instead of letting siblings wrap. Use `minmax(0,1fr)`
  on the track and `min-width:0` on the flex container. Also prefer `min-height` over a
  fixed `height` on bars/cards so wrapped content grows instead of spilling out.

- **wrangler v4 needs Node >= 22; cloudflare/wrangler-action defaults to wrangler v3.**
  For an assets-only Worker (no `main` entry), v3 fails with "Missing entry-point" — pin
  `wranglerVersion` to the local v4 in the action AND set `node-version: 22` in
  setup-node. (Origin: two CI run failures before the deploy step was reachable.)

- **In CI, wrangler needs `CLOUDFLARE_API_TOKEN` (non-interactive).** `wrangler login`
  OAuth only works locally. CI auth = an API token as a repo secret; account id can be a
  secret too (or inferred). The "Edit Cloudflare Workers" token template must include the
  custom-domain zone so `routes: custom_domain` can be re-applied on deploy.
