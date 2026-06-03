# Codebase Architecture Map

This document outlines the file layout and boundaries of the Qubixsa Quote Generator repository.

---

## 1. Directory Structure

```
Qubixsa/Quote Generator/
├── admin.html                     ← Management dashboard (local execution)
├── generator.html                 ← Core quote generator tool (local execution)
├── portal.html                    ← Public client signing portal (browser load)
├── database_migration.sql         ← Database hardening SQL queries
├── package.json                   ← Project dependencies & scripts
├── package-lock.json              ← Dependency lockfile
├── .ai-instructions.md            ← Instructions and rules for AI assistants
├── .gitignore                     ← Files excluded from Git tracking
│
├── docs/                          ← System documentation & guidelines
│   ├── ARCHITECTURE-MAP.md        ← This file
│   ├── DATABASE-SCHEMA.sql        ← Database tables structure & metadata
│   ├── DEVELOPER-SOP.md           ← SOP guidelines
│   └── HOUSEKEEPING-CHECKLIST.md  ← Housekeeping list
│
├── scripts/                       ← Code validation & developer utilities
│   ├── syntax_check.js            ← HTML Javascript syntax checker
│   ├── verify_security_lockdown.js← Database lockdown testing script
│   └── generate-qub-pdf.sh        ← Shell helper for generating quote PDFs
│
└── legacy/                        ← Outdated backup files (READ ONLY)
    ├── Qubixsa-Invoice-Template.html
    ├── qubixsa-quote-generator (1).html
    ├── qubixsa-quote-generator.backup.html
    └── qubixsa-quote-generator.html
```

---

## 2. File Roles & Access Classifications

### 🌐 Client Facing (Public)
*   **`portal.html`**: Must remain clean and secure. It only reads specific quote data using `get_quote_by_number` and handles quote signatures via `approve_and_sign_quote`. It **must not** contain administrative actions, cogs inputs, or customer database lists.

### 🛡️ Admin Facing (Local Execution)
*   **`admin.html`**: The sales analytics dashboard. Displays pipeline metrics, sales volumes, leaderboards, and quote registry. Requires passcode validation.
*   **`generator.html`**: The template authoring tool. Fetches the products catalog and searches the customer library. All write actions are passcode-validated.

### ⚙️ Developer Utilities
*   **`scripts/`**: Houses automation and testing scripts. These files do not run in production and are used only for quality assurance.

### 📁 Legacy Directory (No Modification Area)
*   **`legacy/`**: Outdated files. They serve as historical reference points. **Never modify any files in this directory.**
