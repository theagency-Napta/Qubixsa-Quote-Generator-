# Qubixsa Quote Generator — Implementation Plan

**Goal:** Produce reliable, professional, outstanding quotations with ease — one HTML tool, one visual standard, PDF-ready every time.

**Source of truth (working files):**
- `Qubixsa-Invoice-Template.html` — design & structure reference
- `qubixsa-quote-generator (1).html` — primary build target (rename to `qubixsa-quote-generator.html` when stable)

**Success criteria (v1 complete):** Open → new quote → fill in &lt;5 min → full-width Arabic preview → print/PDF with all legal sections → blocked if required fields missing.

---

## Guiding principles

1. **Template drives output** — preview markup and print CSS match the invoice template.
2. **Print-first** — every change is validated in Print → Save as PDF (A4, background graphics on).
3. **One company profile** — bank, VAT, CR, beneficiary, footer: single canonical block, not retyped per quote.
4. **Progressive enhancement** — ship Phase 1 before adding libraries, servers, or CRM.
5. **Arabic RTL primary** — layout, borders, and alignment use logical properties (`inline-start`, etc.).

---

## Phase 0 — Prep & cleanup (0.5 day)

**Objective:** Clean baseline before feature work.

| # | Task | Files |
|---|------|--------|
| 0.1 | Rename working generator to `qubixsa-quote-generator.html` (keep backup of old name) | Qubixsa/ |
| 0.2 | Remove external S3 `<script>` tags from template & generator | both HTML |
| 0.3 | Remove `[page:1]` / AI artifact text from helper copy | generator |
| 0.4 | Document canonical company data (bank, IBAN, beneficiary, phones, VAT/CR placeholders) in a `COMPANY-DEFAULTS` comment block at top of generator JS | generator |
| 0.5 | Align known typos: footer currency, auth label (صادر عن), beneficiary name, IBAN — pick one source | template + generator |

**Deliverable:** Clean repo folder, no junk scripts, agreed default constants.

**Acceptance:** Both files open offline with no network dependency for core function.

---

## Phase 1 — Safe to send (2–3 days)

**Objective:** PDFs look professional; legal sections complete; no half-page layout.

### 1A — Full-page PDF & template alignment

| # | Task | Details |
|---|------|---------|
| 1.1 | Port template print CSS into generator | `@page A4`, `width: 100%`, `print-color-adjust: exact`, no `960px` cap on `.quote-page` |
| 1.2 | Screen vs print split | `@media screen` — optional centered `max-width: 210mm` preview card; `@media print` — full bleed content area |
| 1.3 | Unify class naming where low-risk | Map preview to template equivalents OR share one `<style>` block copied from template |
| 1.4 | Print test checklist | Document: A4, margins Default, scale 100%, background graphics ON |

**Acceptance:** PDF uses full page width; orange headers and table stripes print correctly.

### 1B — Detailed installation terms

| # | Task | Details |
|---|------|---------|
| 1.5 | Add HTML block after `📄 الشروط والأحكام` | Section: `📋 البنود والشروط التفصيلية — بنود وشروط تركيب الشاشات` |
| 1.6 | Add CSS `.detailed-terms-wrap`, numbered list, nested bullets for clause 6 | Match prior screenshot: bordered box, bold titles, ~0.78–0.82rem body |
| 1.7 | Mirror block in `Qubixsa-Invoice-Template.html` | Static content (no JS) |
| 1.8 | Print rules | `page-break-inside: avoid` on header; allow breaks between clauses 8–15 if needed |

**Acceptance:** 15 clauses visible in preview and PDF; clause 6 has 4 sub-bullets.

### 1C — Validation & pre-flight

| # | Task | Details |
|---|------|---------|
| 1.9 | Required fields | Client name, quote number, issue date, ≥1 line item with qty & price &gt; 0 |
| 1.10 | Pre-flight panel | Small checklist UI: Client ✓ Items ✓ Totals ✓ Terms ✓ |
| 1.11 | Block or warn on print | Modal or inline: “Complete required fields before PDF” |
| 1.12 | Math sanity | Warn if any row total ≠ qty × price (floating tolerance 0.01) |

**Acceptance:** Cannot print with empty client or zero items (warn minimum); checklist turns green when ready.

### Phase 1 deliverables

- [x] Generator PDF = full A4 professional layout  
- [x] Detailed terms in generator + template  
- [x] Print validation + pre-flight checklist  
- [x] `PRINT-CHECKLIST.md` (one-page internal note)

---

## Phase 2 — Fast daily use (2–3 days)

**Objective:** Less retyping; quotes don’t get lost; faster new quote flow.

### 2A — Persistence

| # | Task | Details |
|---|------|---------|
| 2.1 | Autosave | `localStorage` key `qubixsa-quote-draft` — debounced 500ms on `updateAll` |
| 2.2 | Restore on load | Prompt: “Resume last draft?” if draft exists |
| 2.3 | Clear draft | On successful “Export” or explicit “Discard draft” |

### 2B — Quote workflow

| # | Task | Details |
|---|------|---------|
| 2.4 | Auto quote number | Pattern `QUB-QTN-YYYY-{TYPE}-{SEQ}`; store last SEQ in `localStorage` |
| 2.5 | New quote | Today’s date (en-GB), default validity 3, VAT 15%, empty client, one empty item |
| 2.6 | Duplicate quote | Clone all fields + items; new quote number |
| 2.7 | Export standalone HTML | Button: download filled quote only (no form panel) — blob download |

### 2C — Product type presets (wire existing chips)

| # | Task | Details |
|---|------|---------|
| 2.8 | LED preset | LED spec grid visible; default sample items; detailed installation terms ON |
| 2.9 | LCD / signage preset | Alternate spec labels or simplified spec table; TV-friendly defaults |
| 2.10 | Custom preset | Minimal specs placeholder; optional hide detailed terms toggle |
| 2.11 | `data-style` handler | On chip click: show/hide sections, load preset field values |

**Acceptance:** Refresh browser → draft restores; New/Duplicate work; Export HTML opens as standalone quote; LED/LCD/Custom change visible defaults.

**Status:** Implemented in `qubixsa-quote-generator.html` (Phases 0–3 core).

---

## Phase 3 — Professional polish (3–4 days)

**Objective:** Richer quotes, fewer mistakes, stronger brand consistency.

### 3A — Line items & libraries

| # | Task | Details |
|---|------|---------|
| 3.1 | Item description templates | Dropdown: LED wall, Samsung TV, Installation, Novastar, Custom |
| 3.2 | SKU quick-add | Buttons for common codes (HG43, HG50, INST, etc.) |
| 3.3 | Client library | Save/load last 20 clients from `localStorage` |
| 3.4 | Item library | Save named bundles (e.g. “Hotel 16x Samsung pack”) |

### 3B — Optional sections & media

| # | Task | Details |
|---|------|---------|
| 3.5 | Section toggles | Checkboxes: Specs, Detailed terms, Bank, Product images |
| 3.6 | Product images in preview | 1–3 images below items or in specs; print-safe sizing |
| 3.7 | Rich text guard | Sanitize or restrict HTML in descriptions (avoid broken preview) |

### 3C — Commercial extras

| # | Task | Details |
|---|------|---------|
| 3.8 | Discount row | Optional % or fixed discount before VAT; show on totals table |
| 3.9 | Internal notes | Field marked “لا يظهر في الطباعة” — `display:none` in `@media print` |
| 3.10 | Quote revision | Optional `Rev 2` badge in quote meta table |

**Acceptance:** Template descriptions insert in one click; images appear in PDF; discount reflected in grand total.

---

## Phase 4 — Outstanding & scale (optional, 3–5 days)

**Objective:** Differentiators for growth — only after Phases 1–3 stable.

| # | Feature | Notes |
|---|---------|--------|
| 4.1 | Comparison quote | Option A / Option B tables on one document |
| 4.2 | Email helper | Copy-ready subject + body with quote # and total |
| 4.3 | CSV import | Paste rows → line items |
| 4.4 | ZATCA fields | VAT + CR when available; show in legal strip |
| 4.5 | PDF one-click | Headless Chrome script or improved print CSS only |
| 4.6 | Multi-user (future) | Only if needed: JSON files per quote or light backend |

---

## File & architecture map (end state)

```
Qubixsa/
├── IMPLEMENTATION-PLAN.md          ← this file
├── PRINT-CHECKLIST.md              ← Phase 1
├── Qubixsa-Invoice-Template.html   ← static reference + placeholders
├── qubixsa-quote-generator.html    ← main app (form + preview + JS)
├── exports/                        ← optional: saved HTML/PDF outputs
└── generate-pdf.sh                 ← optional Chrome headless helper
```

**JS modules (inline or split later):**
- `defaults.js` — company profile, presets
- `storage.js` — autosave, clients, items, quote counter
- `validation.js` — pre-flight, math checks
- `export.js` — standalone HTML download
- `render.js` — preview sync (existing `updateAll`)

---

## Testing matrix (every phase)

| Test | Phase |
|------|--------|
| Print PDF — full width, 2+ pages, Arabic readable | 1 |
| Detailed terms page break acceptable | 1 |
| New quote → fill → print with validation | 1 |
| Reload → draft restored | 2 |
| LED vs LCD preset changes specs | 2 |
| Export HTML → open → print identical | 2 |
| Discount math correct | 3 |
| Images print without clipping | 3 |

**Browsers:** Chrome (primary), Safari (secondary).

---

## Timeline summary

| Phase | Focus | Duration (estimate) |
|-------|--------|---------------------|
| **0** | Cleanup | 0.5 day |
| **1** | Safe to send (PDF + terms + validation) | 2–3 days |
| **2** | Fast daily use (save, numbering, presets, export) | 2–3 days |
| **3** | Professional polish (libraries, images, discount) | 3–4 days |
| **4** | Outstanding (optional) | 3–5 days |

**Total to v1 (Phases 0–2):** ~5–7 days  
**Total to “outstanding” (0–3):** ~8–11 days  

---

## Dependencies & risks

| Risk | Mitigation |
|------|------------|
| Print CSS differs Chrome vs Safari | Test both; use template rules as source |
| `localStorage` cleared by user | Export HTML as backup; optional “Download backup JSON” |
| Long quotes (many items) paginate badly | `page-break-inside: avoid` on rows selectively; smaller font on items table |
| Legal text wrong for non-install quotes | Phase 2 preset toggles detailed terms |
| Two files drift apart | After each phase, sync template ↔ generator preview block |

---

## Decision log (fill as you go)

| Decision | Options | Chosen |
|----------|---------|--------|
| Detailed terms default | Always on / LED only / toggle | TBD |
| Canonical IBAN | Template vs generator value | TBD |
| Quote number format | `QUB-QTN-2026-LED-###` | TBD |
| Primary filename | `qubixsa-quote-generator.html` | Recommended |

---

## Next action

**Start Phase 0 + Phase 1A** in `qubixsa-quote-generator (1).html`:
1. Remove S3 scripts and fix defaults  
2. Merge template print CSS (full-width A4)  
3. Add detailed terms section  
4. Add print validation  

When ready to implement, say **“Start Phase 1”** and work proceeds in the generator first, then template sync.
