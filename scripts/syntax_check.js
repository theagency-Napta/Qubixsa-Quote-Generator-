const fs = require('fs');
const vm = require('vm');
const path = require('path');

const targetFiles = [
  'portal.html',
  'admin.html',
  'generator.html'
];

let allPassed = true;

console.log('====================================================');
console.log('Checking HTML files for JavaScript syntax errors...');
console.log('====================================================\n');

targetFiles.forEach(file => {
  const filePath = path.join(__dirname, '..', file);
  if (!fs.existsSync(filePath)) {
    console.error(`[ERROR] File not found: ${file}`);
    allPassed = false;
    return;
  }

  try {
    const html = fs.readFileSync(filePath, 'utf8');
    const scriptRegex = /<script>([\s\S]*?)<\/script>/gi;
    let match;
    let blockCount = 0;
    let filePassed = true;

    while ((match = scriptRegex.exec(html)) !== null) {
      const scriptContent = match[1];
      blockCount++;
      try {
        new vm.Script(scriptContent, { filename: `${file}#script-block-${blockCount}.js` });
      } catch (err) {
        console.error(`  [FAIL] Syntax error in ${file} script block ${blockCount}:`);
        console.error(`  Error message: ${err.message}`);
        console.error(`  Stack trace: ${err.stack}\n`);
        filePassed = false;
        allPassed = false;
      }
    }

    if (filePassed) {
      console.log(`  [PASS] ${file}: Checked ${blockCount} script block(s) successfully.`);
    }
  } catch (e) {
    console.error(`  [ERROR] Failed reading ${file}:`, e.message);
    allPassed = false;
  }
});

console.log('\n====================================================');
if (allPassed) {
  console.log('ALL JAVASCRIPT SYNTAX CHECKS PASSED SUCCESSFULLY!');
} else {
  console.log('SYNTAX CHECKS FAILED. PLEASE CORRECT ERRORS ABOVE.');
}
console.log('====================================================');
process.exit(allPassed ? 0 : 1);
