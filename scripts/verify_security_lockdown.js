const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = 'https://ylmalaszyhltwklqfhhs.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlsbWFsYXN6eWhsdHdrbHFmaGhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ5NDY4ODUsImV4cCI6MjA5MDUyMjg4NX0.tDT94RNca_XliAZhqbAKWcam9m1NSjkR3ftZUznL3ts';

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function runTests() {
  console.log('====================================================');
  console.log('QUBIXSA SECURITY LOCKDOWN & RPC VERIFICATION SYSTEM');
  console.log('====================================================\n');

  // Test 1: Direct SELECT on quotes table
  console.log('Test 1: Querying "quotes" table directly...');
  const { data: quotesData, error: quotesError } = await supabase
    .from('quotes')
    .select('*')
    .limit(1);
  if (quotesError || (quotesData && quotesData.length === 0)) {
    console.log('  [PASS] Direct query blocked or returned empty (Security is working!). Error:', quotesError ? quotesError.message : 'No records');
  } else {
    console.log('  [WARNING] Direct select succeeded! Please verify you executed database_migration.sql to enable RLS and revoke public permissions.');
  }

  // Test 2: Direct SELECT on customers table
  console.log('\nTest 2: Querying "customers" table directly...');
  const { data: custData, error: custError } = await supabase
    .from('customers')
    .select('*')
    .limit(1);
  if (custError || (custData && custData.length === 0)) {
    console.log('  [PASS] Direct query blocked or returned empty (Security is working!). Error:', custError ? custError.message : 'No records');
  } else {
    console.log('  [WARNING] Direct select succeeded! Please verify you executed database_migration.sql.');
  }

  // Test 3: Direct SELECT on products table
  console.log('\nTest 3: Querying "products" table directly...');
  const { data: prodData, error: prodError } = await supabase
    .from('products')
    .select('*')
    .limit(1);
  if (prodError || (prodData && prodData.length === 0)) {
    console.log('  [PASS] Direct query blocked or returned empty (Security is working!). Error:', prodError ? prodError.message : 'No records');
  } else {
    console.log('  [WARNING] Direct select succeeded! Please verify you executed database_migration.sql.');
  }

  // Test 4: Secure Admin RPC with INVALID passcode
  console.log('\nTest 4: Accessing admin dashboard data with INVALID passcode ("0000")...');
  const { data: adminBadData, error: adminBadError } = await supabase
    .rpc('get_admin_dashboard_data', { input_passcode: '0000' });
  if (adminBadError) {
    console.log('  [PASS] Access denied database-side! Error message:', adminBadError.message);
  } else {
    console.log('  [FAIL] Database-side passcode protection failed! It returned:', adminBadData);
  }

  // Test 5: Secure Admin RPC with VALID passcode
  console.log('\nTest 5: Accessing admin dashboard data with VALID passcode ("1055")...');
  const { data: adminGoodData, error: adminGoodError } = await supabase
    .rpc('get_admin_dashboard_data', { input_passcode: '1055' });
  if (adminGoodError) {
    console.log('  [FAIL/WAIT] RPC failed. Make sure you run database_migration.sql in the Supabase SQL editor. Error:', adminGoodError.message);
  } else {
    console.log('  [PASS] Successfully retrieved quotes list using valid passcode! Total records retrieved:', adminGoodData.length);
  }

  // Test 6: Secure Products RPC with VALID passcode
  console.log('\nTest 6: Accessing secure products catalog with VALID passcode ("1055")...');
  const { data: prodGoodData, error: prodGoodError } = await supabase
    .rpc('get_products_secure', { input_passcode: '1055' });
  if (prodGoodError) {
    console.log('  [FAIL/WAIT] RPC failed. Error:', prodGoodError.message);
  } else {
    console.log('  [PASS] Successfully retrieved products catalog! Total records:', prodGoodData.length);
  }

  console.log('\n====================================================');
  console.log('VERIFICATION COMPLETE.');
  console.log('====================================================');
}

runTests();
