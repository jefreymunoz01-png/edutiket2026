-- Eduticket schema for Supabase
-- Ejecuta este SQL en el SQL editor de tu proyecto Supabase.

create extension if not exists pgcrypto;

create table if not exists public.config (
  id integer generated always as identity primary key,
  saldo integer not null default 4800,
  updated_at timestamptz default now()
);

create table if not exists public.rutas (
  id text primary key,
  nombre text not null,
  precio integer not null default 300,
  tiempo text not null,
  distancia text not null,
  bus text not null,
  created_at timestamptz default now()
);

create table if not exists public.historial (
  id uuid primary key default gen_random_uuid(),
  fecha text,
  hora text,
  ruta text,
  monto integer default 0,
  tipo text default 'tiquete',
  created_at timestamptz default now()
);

create table if not exists public.tiquetes (
  id uuid primary key default gen_random_uuid(),
  codigo text unique,
  ruta text,
  monto integer default 0,
  estado text default 'activo',
  fecha text,
  fecha_key text,
  cobrado boolean default false,
  created_at timestamptz default now()
);

create table if not exists public.estudiantes (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  ruta text,
  saldo integer default 0,
  created_at timestamptz default now()
);

create table if not exists public.validaciones (
  id uuid primary key default gen_random_uuid(),
  nombre text,
  hora text,
  ruta text,
  metodo text default 'QR',
  valido boolean default true,
  created_at timestamptz default now()
);

insert into public.config (saldo)
values (4800)
on conflict (id) do nothing;

insert into public.rutas (id, nombre, precio, tiempo, distancia, bus)
values
  ('r1','Parcelas',300,'15 min','6 km','Bus 01'),
  ('r2','Damas',300,'20 min','9 km','Bus 02'),
  ('r3','Costanare',300,'25 min','11 km','Bus 03'),
  ('r4','Inmaculada',300,'25 min','12 km','Bus 04'),
  ('r5','Boca Vieja',300,'30 min','14 km','Bus 05'),
  ('r6','Quepos',300,'20 min','8 km','Bus 06'),
  ('r7','Naranjito',300,'30 min','15 km','Bus 07'),
  ('r8','Villa Nueva',300,'35 min','18 km','Bus 08'),
  ('r9','Paquita',300,'35 min','17 km','Bus 09'),
  ('r10','Cerros',600,'55 min','30 km','Bus 10'),
  ('r11','Manuel',600,'50 min','28 km','Bus 11')
on conflict (id) do nothing;

insert into public.historial (fecha, hora, ruta, monto, tipo)
values
  ('09/05/2025','07:15','Quepos',300,'tiquete'),
  ('08/05/2025','07:20','Manuel y Cerros',600,'tiquete'),
  ('07/05/2025','18:00','Recarga SINPE',3000,'recarga')
on conflict do nothing;

insert into public.estudiantes (nombre, ruta, saldo)
values
  ('Bienvenido Estudiante','Quepos',4800),
  ('Estudiante 02','San Isidro',1500),
  ('Estudiante 03','Manuel y Cerros',900),
  ('Estudiante 04','Quepos',300),
  ('Estudiante 05','Dominical',2100),
  ('Estudiante 06','San Isidro',600),
  ('Estudiante 07','Quepos',3300),
  ('Estudiante 08','Manuel y Cerros',150)
on conflict do nothing;

insert into public.validaciones (nombre, hora, ruta, metodo, valido)
values
  ('Bienvenido Estudiante','06:48','Quepos','QR',true),
  ('Estudiante 02','06:52','San Isidro','NFC',true)
on conflict do nothing;

alter table public.config enable row level security;
alter table public.rutas enable row level security;
alter table public.historial enable row level security;
alter table public.tiquetes enable row level security;
alter table public.estudiantes enable row level security;
alter table public.validaciones enable row level security;

drop policy if exists "Config public read" on public.config;
create policy "Config public read" on public.config
for select
using (true);

drop policy if exists "Rutas public read" on public.rutas;
create policy "Rutas public read" on public.rutas
for select
using (true);

drop policy if exists "Historial public read" on public.historial;
create policy "Historial public read" on public.historial
for select
using (true);

drop policy if exists "Tiquetes public read" on public.tiquetes;
create policy "Tiquetes public read" on public.tiquetes
for select
using (true);

drop policy if exists "Estudiantes public read" on public.estudiantes;
create policy "Estudiantes public read" on public.estudiantes
for select
using (true);

drop policy if exists "Validaciones public read" on public.validaciones;
create policy "Validaciones public read" on public.validaciones
for select
using (true);

drop policy if exists "Config public insert" on public.config;
create policy "Config public insert" on public.config
for insert
with check (true);

drop policy if exists "Rutas public insert" on public.rutas;
create policy "Rutas public insert" on public.rutas
for insert
with check (true);

drop policy if exists "Historial public insert" on public.historial;
create policy "Historial public insert" on public.historial
for insert
with check (true);

drop policy if exists "Tiquetes public insert" on public.tiquetes;
create policy "Tiquetes public insert" on public.tiquetes
for insert
with check (true);

drop policy if exists "Estudiantes public insert" on public.estudiantes;
create policy "Estudiantes public insert" on public.estudiantes
for insert
with check (true);

drop policy if exists "Validaciones public insert" on public.validaciones;
create policy "Validaciones public insert" on public.validaciones
for insert
with check (true);

drop policy if exists "Config public update" on public.config;
create policy "Config public update" on public.config
for update
using (true)
with check (true);

drop policy if exists "Rutas public update" on public.rutas;
create policy "Rutas public update" on public.rutas
for update
using (true)
with check (true);

drop policy if exists "Historial public update" on public.historial;
create policy "Historial public update" on public.historial
for update
using (true)
with check (true);

drop policy if exists "Tiquetes public update" on public.tiquetes;
create policy "Tiquetes public update" on public.tiquetes
for update
using (true)
with check (true);

drop policy if exists "Estudiantes public update" on public.estudiantes;
create policy "Estudiantes public update" on public.estudiantes
for update
using (true)
with check (true);

drop policy if exists "Validaciones public update" on public.validaciones;
create policy "Validaciones public update" on public.validaciones
for update
using (true)
with check (true);

drop policy if exists "Config public delete" on public.config;
create policy "Config public delete" on public.config
for delete
using (true);

drop policy if exists "Rutas public delete" on public.rutas;
create policy "Rutas public delete" on public.rutas
for delete
using (true);

drop policy if exists "Historial public delete" on public.historial;
create policy "Historial public delete" on public.historial
for delete
using (true);

drop policy if exists "Tiquetes public delete" on public.tiquetes;
create policy "Tiquetes public delete" on public.tiquetes
for delete
using (true);

drop policy if exists "Estudiantes public delete" on public.estudiantes;
create policy "Estudiantes public delete" on public.estudiantes
for delete
using (true);

drop policy if exists "Validaciones public delete" on public.validaciones;
create policy "Validaciones public delete" on public.validaciones
for delete
using (true);

select 'Supabase schema ready' as status;
