-- ============================================================
-- QCV Landing — esquema de base de datos para Supabase
-- Pega este archivo completo en: Supabase > SQL Editor > New query > Run
-- ============================================================

-- Solicitudes que llegan desde el formulario de la landing page.
-- Las revisas directamente en Supabase > Table Editor > cv_requests.
create table if not exists cv_requests (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  email text not null,
  phone text not null,
  experience jsonb not null default '[]'::jsonb,  -- [{place, start_year, end_year}, ...]
  education text,
  certifications text,
  language text,          -- 'es' o 'en' — el idioma con el que llenó el formulario
  created_at timestamptz not null default now()
);

alter table cv_requests enable row level security;

-- Cualquiera puede enviar el formulario (insert), pero nadie puede leer
-- los datos de otros desde el navegador — solo tú, desde el dashboard
-- de Supabase (que usa permisos de administrador, no la anon key).
create policy "cualquiera puede enviar el formulario" on cv_requests
  for insert
  with check (true);

-- ============================================================
-- Testimonios — IGUAL a la tabla que usa CV Vault. Si conectas este
-- sitio al MISMO proyecto Supabase que ya usas para CV Vault, no hace
-- falta correr esto de nuevo (ya existe) y los testimonios se
-- comparten automáticamente entre ambos sitios.
-- ============================================================
create table if not exists testimonials (
  id uuid primary key default gen_random_uuid(),
  client_name text not null default 'Cliente',
  rating smallint not null check (rating between 1 and 5),
  comment text,
  created_at timestamptz not null default now()
);

alter table testimonials enable row level security;

create policy "cualquiera lee testimonios" on testimonials
  for select using (true);

create policy "cualquiera deja testimonio" on testimonials
  for insert with check (rating between 1 and 5);
