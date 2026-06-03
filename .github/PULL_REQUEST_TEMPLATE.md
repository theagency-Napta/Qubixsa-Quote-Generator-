## Description
Provide a clear summary of the changes made, the issue fixed, or the feature implemented.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Database Security / RPC modification

## Testing and Quality Checklist
Please run these steps before submitting this PR:

- [ ] **Syntax Verification**: I have run `node scripts/syntax_check.js` and confirmed there are no compilation errors in the HTML files.
- [ ] **Security Policy Verification**: I have run `node scripts/verify_security_lockdown.js` and confirmed that Test 1, Test 2, and Test 3 pass (`permission denied` for direct table queries).
- [ ] **Plaintext Passcode Check**: I have verified that the passcode `'1055'` is **not** hardcoded in plain text in any new code or comments.
- [ ] **Print/PDF Verification**: I have tested the quote generator print view (`Ctrl+P` or Cmd+P) and verified the layout, margins, and detailed terms fit clean A4 pages without overlaps.
- [ ] **Bilingual Layout**: I verified that both Arabic (RTL) and English (LTR) visual text alignments are correct on mobile and desktop views.
- [ ] **No Unused Code**: I cleared out any debug helpers, commented-out testing blocks, and stray console logs.
