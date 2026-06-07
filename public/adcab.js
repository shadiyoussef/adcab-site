/* ============================================================
   AdCab site — interactions
   ============================================================ */
(function () {
  "use strict";

  /* ---------- Nav scroll state ---------- */
  var nav = document.querySelector(".nav");
  function onScroll() {
    if (window.scrollY > 24) nav.classList.add("is-scrolled");
    else nav.classList.remove("is-scrolled");
  }
  window.addEventListener("scroll", onScroll, { passive: true });
  onScroll();

  /* ---------- Reveal on scroll (bulletproof) ---------- */
  var reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  var revealEls = [].slice.call(document.querySelectorAll(".reveal, .reveal-stagger"));
  function revealAll() { revealEls.forEach(function (el) { el.classList.add("in"); }); }

  if (reduce || !("IntersectionObserver" in window)) {
    revealAll();
  } else {
    // Only now do we allow content to start hidden — if JS fails, content stays visible.
    document.documentElement.classList.add("reveal-on");
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) { e.target.classList.add("in"); io.unobserve(e.target); }
      });
    }, { threshold: 0.12, rootMargin: "0px 0px -6% 0px" });
    revealEls.forEach(function (el) { io.observe(el); });

    // Reveal anything already within the viewport at load.
    function revealInView() {
      var vh = window.innerHeight || document.documentElement.clientHeight;
      revealEls.forEach(function (el) {
        if (el.classList.contains("in")) return;
        var r = el.getBoundingClientRect();
        if (r.top < vh * 0.94 && r.bottom > 0) el.classList.add("in");
      });
    }
    requestAnimationFrame(revealInView);
    window.addEventListener("scroll", revealInView, { passive: true });
    // Ultimate safety net: never leave content hidden.
    setTimeout(revealAll, 2600);
  }

  /* ---------- Count-up numbers ---------- */
  function animateCount(el) {
    var target = parseFloat(el.getAttribute("data-count"));
    var dec = parseInt(el.getAttribute("data-dec") || "0", 10);
    var dur = 1400, start = null;
    var prefix = el.getAttribute("data-prefix") || "";
    var suffix = el.getAttribute("data-suffix") || "";
    function step(ts) {
      if (!start) start = ts;
      var p = Math.min((ts - start) / dur, 1);
      var eased = 1 - Math.pow(1 - p, 3);
      var val = target * eased;
      el.textContent = prefix + (dec ? val.toFixed(dec) : Math.round(val).toLocaleString("en-US")) + suffix;
      if (p < 1) requestAnimationFrame(step);
      else el.textContent = prefix + (dec ? target.toFixed(dec) : Math.round(target).toLocaleString("en-US")) + suffix;
    }
    requestAnimationFrame(step);
  }
  if (!reduce && "IntersectionObserver" in window) {
    var cio = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) { animateCount(e.target); cio.unobserve(e.target); }
      });
    }, { threshold: 0.6 });
    document.querySelectorAll("[data-count]").forEach(function (el) { cio.observe(el); });
  }

  /* ---------- Hero particle field ---------- */
  var canvas = document.getElementById("heroCanvas");
  if (canvas && !reduce) {
    var ctx = canvas.getContext("2d");
    var dpr = Math.min(window.devicePixelRatio || 1, 2);
    var W, H, particles, mouse = { x: -9999, y: -9999 };
    var COLORS = ["#E5197D", "#0F9ED5", "#7FB5D8", "#ffffff"];

    function resize() {
      W = canvas.clientWidth; H = canvas.clientHeight;
      canvas.width = W * dpr; canvas.height = H * dpr;
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      build();
    }
    function build() {
      var count = Math.min(Math.floor((W * H) / 13000), 120);
      particles = [];
      for (var i = 0; i < count; i++) {
        particles.push({
          x: Math.random() * W,
          y: Math.random() * H,
          vx: (Math.random() - 0.5) * 0.25,
          vy: (Math.random() - 0.5) * 0.25,
          r: Math.random() * 1.8 + 0.6,
          c: COLORS[Math.random() < 0.18 ? 0 : (Math.random() < 0.3 ? 1 : (Math.random() < 0.5 ? 2 : 3))],
          a: Math.random() * 0.5 + 0.25
        });
      }
    }
    function tick() {
      ctx.clearRect(0, 0, W, H);
      // connections
      for (var i = 0; i < particles.length; i++) {
        var p = particles[i];
        p.x += p.vx; p.y += p.vy;
        // gentle mouse drift
        var mdx = p.x - mouse.x, mdy = p.y - mouse.y;
        var md2 = mdx * mdx + mdy * mdy;
        if (md2 < 14000) {
          var f = (14000 - md2) / 14000 * 0.4;
          p.x += (mdx) / Math.sqrt(md2 + 0.1) * f;
          p.y += (mdy) / Math.sqrt(md2 + 0.1) * f;
        }
        if (p.x < -20) p.x = W + 20; if (p.x > W + 20) p.x = -20;
        if (p.y < -20) p.y = H + 20; if (p.y > H + 20) p.y = -20;

        for (var j = i + 1; j < particles.length; j++) {
          var q = particles[j];
          var dx = p.x - q.x, dy = p.y - q.y;
          var d2 = dx * dx + dy * dy;
          if (d2 < 12000) {
            var op = (1 - d2 / 12000) * 0.16;
            ctx.strokeStyle = "rgba(150,190,225," + op + ")";
            ctx.lineWidth = 0.6;
            ctx.beginPath(); ctx.moveTo(p.x, p.y); ctx.lineTo(q.x, q.y); ctx.stroke();
          }
        }
      }
      // dots
      for (var k = 0; k < particles.length; k++) {
        var pt = particles[k];
        ctx.globalAlpha = pt.a;
        ctx.fillStyle = pt.c;
        ctx.beginPath(); ctx.arc(pt.x, pt.y, pt.r, 0, Math.PI * 2); ctx.fill();
        if (pt.c === "#E5197D") {
          ctx.globalAlpha = pt.a * 0.5;
          ctx.beginPath(); ctx.arc(pt.x, pt.y, pt.r * 3, 0, Math.PI * 2); ctx.fill();
        }
      }
      ctx.globalAlpha = 1;
      raf = requestAnimationFrame(tick);
    }
    var raf;
    window.addEventListener("resize", resize);
    canvas.addEventListener("pointermove", function (e) {
      var rect = canvas.getBoundingClientRect();
      mouse.x = e.clientX - rect.left; mouse.y = e.clientY - rect.top;
    });
    canvas.addEventListener("pointerleave", function () { mouse.x = -9999; mouse.y = -9999; });
    resize(); tick();

    // pause when hero off-screen
    var hero = document.querySelector(".hero");
    if ("IntersectionObserver" in window) {
      new IntersectionObserver(function (es) {
        es.forEach(function (e) {
          if (e.isIntersecting) { if (!raf) tick(); }
          else { cancelAnimationFrame(raf); raf = null; }
        });
      }, { threshold: 0 }).observe(hero);
    }
  }

  /* ---------- Active nav link on scroll ---------- */
  var sections = document.querySelectorAll("section[id]");
  var links = {};
  document.querySelectorAll(".nav__links a.nav-link").forEach(function (a) {
    links[a.getAttribute("href").slice(1)] = a;
  });
  if ("IntersectionObserver" in window) {
    var sio = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        var id = e.target.id;
        if (links[id] && e.isIntersecting) {
          Object.values(links).forEach(function (l) { l.style.color = ""; });
          links[id].style.color = "var(--magenta)";
        }
      });
    }, { rootMargin: "-45% 0px -50% 0px" });
    sections.forEach(function (s) { sio.observe(s); });
  }
})();
