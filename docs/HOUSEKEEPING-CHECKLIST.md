# Housekeeping & Maintenance Checklist

To keep the Qubixsa Quote Generator secure, perform these housekeeping tasks periodically.

---

## 📅 Monthly Maintenance Tasks

### 1. Database Backup & Export
Although Supabase has automated backups, keeping an offline copy of your CRM and quote history is highly recommended.
- [ ] Log in to the **Supabase Dashboard**.
- [ ] Navigate to the **Table Editor**.
- [ ] Open the `quotes` table and click **Export to CSV**. Save this file securely in your company's backup folder.
- [ ] Open the `customers` table and click **Export to CSV**.
- [ ] Open the `products` table and click **Export to CSV**.

### 2. Dependency Audit & Package Check
- [ ] Open your terminal and navigate to the project directory.
- [ ] Run `npm audit` to check for security vulnerabilities in the Node.js developer tools SDK.
- [ ] If vulnerabilities are reported, run `npm audit fix` to apply security updates.

---

## 📅 Quarterly Maintenance Tasks

### 1. Security & RLS Audit
Ensure database rules remain locked down and haven't drifted.
- [ ] Run the validation test script locally:
  ```bash
  node scripts/verify_security_lockdown.js
  ```
- [ ] Verify that Tests 1, 2, and 3 report `[PASS] Direct query blocked`.
- [ ] Log into the **Supabase SQL Editor** and verify that no new tables have been added without enabling RLS policies.

### 2. Local Storage Cleanup Test
Check that local storage usage is healthy and doesn't crash browser cache.
- [ ] Open the Quote Generator locally.
- [ ] Clear browser cache/local storage and confirm the generator gracefully defaults to standard product samples instead of crashing.
- [ ] Verify the autosave warning is functional if `localStorage` is disabled.

---

## 📅 Annual Maintenance Tasks

### 1. API Credentials Rotation
- [ ] Log into Supabase and check if the `anon` key needs to be rotated.
- [ ] If rotated, update `SUPABASE_KEY` at the top of:
  * `generator.html`
  * `admin.html`
  * `portal.html`
  * `scripts/verify_security_lockdown.js`
  * `scripts/syntax_check.js`
- [ ] Verify all pages still load correctly.
