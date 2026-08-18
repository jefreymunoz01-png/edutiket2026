# Eduticket — flujo de negocio y arquitectura

## Objetivo
Crear un sistema donde:
- un usuario estudiante compra tiquetes
- esos tiquetes quedan asociados a ese usuario
- un chofer escanea el QR del tiquete
- si es válido, el tiquete pasa a usado
- el evento queda en el historial de ese usuario

## Roles
- student
- driver
- admin

## Entidades principales

### 1) profiles
id uuid pk default gen_random_uuid()
email text unique not null
full_name text not null
role text not null default 'student'
created_at timestamptz default now()

### 2) routes
id uuid pk default gen_random_uuid()
name text not null
price integer not null default 300
time text
distance text
bus text
created_at timestamptz default now()

### 3) tickets
id uuid pk default gen_random_uuid()
user_id uuid not null references public.profiles(id) on delete cascade
route_id uuid references public.routes(id)
amount integer not null
status text not null default 'paid' -- paid | used | expired
code text unique not null
qr_code text
created_at timestamptz default now()
used_at timestamptz

### 4) history
id uuid pk default gen_random_uuid()
user_id uuid not null references public.profiles(id) on delete cascade
ticket_id uuid references public.tickets(id) on delete set null
action text not null -- purchase | scan | used
route_name text
amount integer default 0
created_at timestamptz default now()

### 5) validations
id uuid pk default gen_random_uuid()
driver_id uuid references public.profiles(id)
user_id uuid not null references public.profiles(id)
ticket_id uuid not null references public.tickets(id)
status text not null default 'valid' -- valid | invalid
scanned_at timestamptz default now()

## Flujo de usuario
1. El usuario inicia sesión como student.
2. Compra un tiquete.
3. Se crea un registro en tickets con user_id del estudiante.
4. El ticket queda visible solo para ese usuario.
5. Se registra la compra en history.

## Flujo del chofer
1. El chofer inicia sesión como driver.
2. Escanea el QR del tiquete.
3. Busca el ticket por code.
4. Verifica que el ticket existe y pertenece al usuario correcto.
5. Verifica que el ticket está en estado paid.
6. Cambia el estado a used.
7. Guarda un registro en validations.
8. Guarda un evento en history con la acción used.

## Regla clave
Los tiquetes deben estar asociados a user_id.
Nunca deben ser globales ni compartidos entre usuarios.
El historial debe filtrarse por user_id.
La validación del chofer debe revisar el ticket del usuario escaneado.

## SQL base recomendado
```sql
create table public.profiles (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  full_name text not null,
  role text not null default 'student',
  created_at timestamptz default now()
);

create table public.routes (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  price integer not null default 300,
  time text,
  distance text,
  bus text,
  created_at timestamptz default now()
);

create table public.tickets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  route_id uuid references public.routes(id),
  amount integer not null,
  status text not null default 'paid',
  code text unique not null,
  qr_code text,
  created_at timestamptz default now(),
  used_at timestamptz
);

create table public.history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  ticket_id uuid references public.tickets(id) on delete set null,
  action text not null,
  route_name text,
  amount integer default 0,
  created_at timestamptz default now()
);

create table public.validations (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid references public.profiles(id),
  user_id uuid not null references public.profiles(id),
  ticket_id uuid not null references public.tickets(id),
  status text not null default 'valid',
  scanned_at timestamptz default now()
);
```

## Política recomendada
- Permitir lectura pública solo para rutas.
- Permitir lectura/escritura por usuario a sus propios tickets e historial.
- Permitir validación al chofer para escanear tickets.
- Usar RLS real, no anon open access para todos.

## Pendientes del proyecto
- Implementar login real por perfil.
- Asociar tiquetes a user_id.
- Mostrar solo tickets y historial del usuario actual.
- Hacer scan QR desde chofer.
- Actualizar ticket a used.
- Guardar evento de validación en history.

## Regla de trabajo
No se debe mostrar información global del sistema. Todo debe filtrarse por user_id o role.
