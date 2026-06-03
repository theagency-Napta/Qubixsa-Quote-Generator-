-- =========================================================================
-- QUBIXSA QUOTE SYSTEM — STATIC DATABASE SCHEMA GUIDE FOR LLMs & AI AGENTS
-- =========================================================================

-- -------------------------------------------------------------------------
-- TABLE 1: public.products (Products Catalog)
-- -------------------------------------------------------------------------
create table public.products (
  id uuid default gen_random_uuid() primary key,
  code text unique not null,                  -- SKU Code (e.g. LED-P1.5-IND)
  name text not null,                         -- Product Name (Arabic/English)
  category text,                              -- 'led', 'kiosk', 'processor', 'service', 'accessory'
  price numeric default 0,                    -- Retail unit price
  unit text default 'م²',                     -- Sales unit ('م²', 'حبة', 'خدمة', etc)
  description text,                           -- Long HTML/Markdown product description
  pixel_pitch text,                           -- Pixel Pitch string (e.g., 'P1.5', 'P2.5')
  lamp_type text,                             -- Lamp Type (e.g., 'SMD1515')
  module_size text,                           -- Module dimensions (e.g., '240mm*120mm')
  module_resolution text,                     -- Module pixels (e.g., '160*80')
  density text,                               -- Pixels per m2 (e.g., '444,444 dots/m2')
  front_maintenance text,                     -- Yes/No
  panel_size text,                            -- Panel dimensions (e.g., '480mm*480mm')
  modules_panel text,                         -- Number of modules per panel (e.g., '2*4')
  panel_resolution text,                      -- Panel pixels (e.g., '320*320')
  panel_weight text,                          -- Panel weight in kg
  material text,                              -- Die-cast aluminum/Iron
  control_system text,                        -- Novastar/Colorlight
  brightness text,                            -- Brightness in nits (e.g., '800 cd/m²')
  refresh_rate text,                          -- Refresh rate in Hz (e.g., '3840 Hz')
  viewing_angle text,                         -- Angle (e.g., '140°/140°')
  lifespan text,                              -- Lifespan hours (e.g., '100,000 hours')
  average_power text,                         -- Avg wattage (e.g., '240 W/m²')
  max_power text,                             -- Max wattage (e.g., '720 W/m²')
  area_summary text,                          -- Calculated specs area
  area_note text,
  min_view_dist text,                         -- Min viewing distance in meters
  min_view_note text,
  ip_rating text,                             -- IP Rating (e.g., 'IP30')
  ip_rating_note text,
  grayscale text,                             -- Grayscale level (e.g., '14-16 bit')
  grayscale_note text,
  created_at timestamptz default now()
);

-- -------------------------------------------------------------------------
-- TABLE 2: public.customers (CRM Customer Directory)
-- -------------------------------------------------------------------------
create table public.customers (
  id uuid default gen_random_uuid() primary key,
  company_name text,                          -- Company/Client Name (Arabic/English)
  rep_name text,                              -- Representative Name
  phone text,                                 -- Phone number (+966...)
  email text,                                 -- Email Address
  tax_number text,                            -- VAT / Tax ID (15 digits)
  cr_number text,                             -- Commercial Registry ID
  address text,                               -- Billing/Installation address
  project_name text,                          -- Primary associated project
  created_at timestamptz default now()
);

-- -------------------------------------------------------------------------
-- TABLE 3: public.quotes (Active Quotations registry)
-- -------------------------------------------------------------------------
create table public.quotes (
  id uuid default gen_random_uuid() primary key,
  quote_number text unique not null,          -- Unique quote identifier (QUB-QTN-...)
  client_name text not null,                  -- Customer Company name
  representative_name text,                  -- Assigned sales rep
  project_name text,                          -- Project name description
  status text default 'sent',                 -- 'sent', 'viewed', 'approved'
  payload jsonb not null,                     -- Full form state JSON (items, specifications, bank, options)
  total_price numeric default 0,              -- Grand total price (including discount & VAT)
  total_cost numeric default 0,               -- COGS (total cost of items)
  margin_percent numeric default 0,           -- Calculated profit margin percent
  viewed_at timestamptz,                      -- Timestamp when client first loaded portal
  signed_at timestamptz,                      -- Timestamp when client signed
  signed_by text,                             -- Signer representative name
  signature_base64 text,                      -- Digital canvas signature data URL
  created_at timestamptz default now()
);
