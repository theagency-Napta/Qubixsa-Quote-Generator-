# Developer SOP (Standard Operating Procedure)

This guide documents the procedures for coding, testing, branching, and releasing updates for the Qubixsa Quote Generator.

---

## 1. Local Development Setup
Since GitHub Pages is completely disabled for security reasons, development must happen locally.
1.  Clone the repository to your local PC.
2.  Install dependencies for the test scripts:
    ```bash
    npm install
    ```
3.  Open HTML files locally (`generator.html`, `admin.html`) to test interactions.

---

## 2. Git Branching Strategy
Never commit directly to the `main` branch. Follow these steps for any new update or bugfix:

### Step 1: Create a Feature/Bugfix Branch
Create a branch off `main` with a descriptive name:
```bash
# For new features
git checkout -b feature/your-feature-name

# For bug fixes
git checkout -b bugfix/what-you-are-fixing
```

### Step 2: Write Code and Test Locally
Keep commits small and focused. Always test changes locally in Chrome and Safari.

### Step 3: Run Validation Scripts
Before staging any changes, run the validation tool kit:
```bash
# Check Javascript syntax integrity inside HTML
node scripts/syntax_check.js

# Validate database security locks are intact
node scripts/verify_security_lockdown.js
```
Ensure all tests print `[PASS]`. Fix any errors before proceeding.

### Step 4: Push Branch & Create Pull Request
Stage, commit, and push your changes to GitHub:
```bash
git add .
git commit -m "feat(scope): descriptive commit message"
git push origin feature/your-feature-name
```
Open GitHub, submit a **Pull Request (PR)** from your branch into `main`, and follow the PR Template check items.

---

## 3. Code Standards & Integrity
*   **Bilingual Styling**: Maintain English/Arabic support on all visual elements. Adjust layouts using `direction: rtl` and logical margins (`margin-inline-start`, etc.).
*   **Vanilla CSS**: Write all custom styling within `<style>` tags. Do not use external CSS engines.
*   **Clean Javascript**: Do not leave commented-out blocks of old code. Clean up debugger tools and unused console logs before committing.
*   **Preserve Print Templates**: When modifying `generator.html`, verify that the print preview `@media print` rules are preserved. Ensure tables paginate properly in PDF print view with `page-break-inside: avoid`.
