-- =========================================================================
-- DATABASE HARDENING: REVOKE PUBLIC DIRECT TABLE ACCESS & SETUP SECURE RPCs
-- Qubixsa Quote Generator — Database Security Migration
-- =========================================================================

-- 1. REVOKE DIRECT TABLE PRIVILEGES FROM PUBLIC ROLE (anon)
revoke select, insert, update, delete on public.quotes from anon, authenticated;
revoke select, insert, update, delete on public.customers from anon, authenticated;
revoke select, insert, update, delete on public.products from anon, authenticated;

-- 2. ENABLE ROW LEVEL SECURITY (RLS) ON ALL TABLES
alter table public.quotes enable row level security;
alter table public.customers enable row level security;
alter table public.products enable row level security;

-- 3. DROP ANY EXISTING PERMISSIVE RLS POLICIES TO DENY DIRECT QUERIES
drop policy if exists "Enable read access for all users" on public.quotes;
drop policy if exists "Enable insert for anonymous users" on public.quotes;
drop policy if exists "Enable update for anonymous users" on public.quotes;
drop policy if exists "Enable read access for all users" on public.customers;
drop policy if exists "Enable insert for anonymous users" on public.customers;
drop policy if exists "Enable update for anonymous users" on public.customers;
drop policy if exists "Enable read access for all users" on public.products;

-- 4. CREATE SECURE RPC FUNCTIONS WITH "SECURITY DEFINER"

-- A. portal.html: Load a quote by its quote number
create or replace function public.get_quote_by_number(q_number text)
returns setof public.quotes
language plpgsql
security definer
as $$
begin
  return query
  select * from public.quotes
  where upper(quote_number) = upper(trim(q_number));
end;
$$;

-- B. portal.html: Mark quote as viewed when loaded
create or replace function public.view_quote_by_number(q_number text)
returns void
language plpgsql
security definer
as $$
begin
  update public.quotes
  set status = 'viewed', viewed_at = now()
  where upper(quote_number) = upper(trim(q_number)) and status = 'sent';
end;
$$;

-- C. portal.html: Approve and sign quote
create or replace function public.approve_and_sign_quote(
  q_id uuid,
  q_signer text,
  q_signature text,
  q_payload jsonb,
  q_total_price numeric,
  q_total_cost numeric,
  q_margin_percent numeric
)
returns void
language plpgsql
security definer
as $$
begin
  update public.quotes
  set
    status = 'approved',
    signature_base64 = q_signature,
    signed_at = now(),
    signed_by = q_signer,
    payload = q_payload,
    total_price = q_total_price,
    total_cost = q_total_cost,
    margin_percent = q_margin_percent
  where id = q_id;
end;
$$;

-- D. admin.html: Read all quotes for dashboard (Passcode protected)
create or replace function public.get_admin_dashboard_data(input_passcode text)
returns setof public.quotes
language plpgsql
security definer
as $$
begin
  if input_passcode <> '1055' then
    raise exception 'Unauthorized access: Invalid passcode.';
  end if;

  return query
  select * from public.quotes
  order by created_at desc;
end;
$$;

-- E. admin.html: Delete a quote (Passcode protected)
create or replace function public.delete_quote_by_id(input_passcode text, q_id uuid)
returns void
language plpgsql
security definer
as $$
begin
  if input_passcode <> '1055' then
    raise exception 'Unauthorized access: Invalid passcode.';
  end if;

  delete from public.quotes
  where id = q_id;
end;
$$;

-- F. generator.html: Fetch all product presets (Passcode protected)
create or replace function public.get_products_secure(input_passcode text)
returns setof public.products
language plpgsql
security definer
as $$
begin
  if input_passcode <> '1055' then
    raise exception 'Unauthorized access: Invalid passcode.';
  end if;

  return query
  select * from public.products
  order by code asc;
end;
$$;

-- G. generator.html: Sync/save client details (Passcode protected)
create or replace function public.upsert_customer_secure(input_passcode text, c_record jsonb)
returns void
language plpgsql
security definer
as $$
declare
  v_id uuid;
begin
  if input_passcode <> '1055' then
    raise exception 'Unauthorized access: Invalid passcode.';
  end if;

  -- Check if customer exists by company_name or rep_name
  if (c_record->>'company_name') is not null and (c_record->>'company_name') <> '' then
    select id into v_id from public.customers where company_name = (c_record->>'company_name') limit 1;
  elsif (c_record->>'rep_name') is not null and (c_record->>'rep_name') <> '' then
    select id into v_id from public.customers where rep_name = (c_record->>'rep_name') limit 1;
  else
    return;
  end if;

  if v_id is not null then
    update public.customers
    set
      rep_name = coalesce(c_record->>'rep_name', rep_name),
      phone = coalesce(c_record->>'phone', phone),
      email = coalesce(c_record->>'email', email),
      tax_number = coalesce(c_record->>'tax_number', tax_number),
      cr_number = coalesce(c_record->>'cr_number', cr_number),
      address = coalesce(c_record->>'address', address),
      project_name = coalesce(c_record->>'project_name', project_name)
    where id = v_id;
  else
    insert into public.customers (
      company_name, rep_name, phone, email, tax_number, cr_number, address, project_name
    ) values (
      c_record->>'company_name',
      c_record->>'rep_name',
      c_record->>'phone',
      c_record->>'email',
      c_record->>'tax_number',
      c_record->>'cr_number',
      c_record->>'address',
      c_record->>'project_name'
    );
  end if;
end;
$$;

-- H. generator.html: Search customers autocomplete (Passcode protected)
create or replace function public.search_customers_secure(input_passcode text, search_query text)
returns setof public.customers
language plpgsql
security definer
as $$
begin
  if input_passcode <> '1055' then
    raise exception 'Unauthorized access: Invalid passcode.';
  end if;

  return query
  select * from public.customers
  where company_name ilike '%' || search_query || '%'
     or rep_name ilike '%' || search_query || '%'
  limit 5;
end;
$$;

-- I. generator.html: Fetch customer drawer list (Passcode protected)
create or replace function public.fetch_crm_clients_secure(input_passcode text, search_query text)
returns setof public.customers
language plpgsql
security definer
as $$
begin
  if input_passcode <> '1055' then
    raise exception 'Unauthorized access: Invalid passcode.';
  end if;

  if search_query = '' or search_query is null then
    return query
    select * from public.customers
    order by company_name asc
    limit 20;
  else
    return query
    select * from public.customers
    where company_name ilike '%' || search_query || '%'
       or rep_name ilike '%' || search_query || '%'
       or phone ilike '%' || search_query || '%'
       or email ilike '%' || search_query || '%'
    order by company_name asc
    limit 20;
  end if;
end;
$$;

-- J. generator.html: Publish quote (Passcode protected)
create or replace function public.publish_quote_secure(input_passcode text, q_record jsonb)
returns void
language plpgsql
security definer
as $$
begin
  if input_passcode <> '1055' then
    raise exception 'Unauthorized access: Invalid passcode.';
  end if;

  insert into public.quotes (
    quote_number,
    client_name,
    representative_name,
    project_name,
    status,
    payload,
    total_price,
    total_cost,
    margin_percent,
    viewed_at,
    signed_at,
    signed_by,
    signature_base64
  ) values (
    (q_record->>'quote_number'),
    (q_record->>'client_name'),
    (q_record->>'representative_name'),
    (q_record->>'project_name'),
    (q_record->>'status'),
    (q_record->'payload'),
    (q_record->>'total_price')::numeric,
    (q_record->>'total_cost')::numeric,
    (q_record->>'margin_percent')::numeric,
    null,
    null,
    null,
    null
  )
  on conflict (quote_number) do update set
    client_name = excluded.client_name,
    representative_name = excluded.representative_name,
    project_name = excluded.project_name,
    status = excluded.status,
    payload = excluded.payload,
    total_price = excluded.total_price,
    total_cost = excluded.total_cost,
    margin_percent = excluded.margin_percent,
    viewed_at = null,
    signed_at = null,
    signed_by = null,
    signature_base64 = null;
end;
$$;

-- 5. GRANT EXECUTION ON ALL FUNCTIONS TO PUBLIC
grant execute on function public.get_quote_by_number(text) to anon, authenticated;
grant execute on function public.view_quote_by_number(text) to anon, authenticated;
grant execute on function public.approve_and_sign_quote(uuid, text, text, jsonb, numeric, numeric, numeric) to anon, authenticated;
grant execute on function public.get_admin_dashboard_data(text) to anon, authenticated;
grant execute on function public.delete_quote_by_id(text, uuid) to anon, authenticated;
grant execute on function public.get_products_secure(text) to anon, authenticated;
grant execute on function public.upsert_customer_secure(text, jsonb) to anon, authenticated;
grant execute on function public.search_customers_secure(text, text) to anon, authenticated;
grant execute on function public.fetch_crm_clients_secure(text, text) to anon, authenticated;
grant execute on function public.publish_quote_secure(text, jsonb) to anon, authenticated;
