create table if not exists public.app_data(
 user_id uuid primary key references auth.users(id) on delete cascade,
 data jsonb not null default '{}'::jsonb,
 updated_at timestamptz not null default now()
);
alter table public.app_data enable row level security;
drop policy if exists "users can read own app data" on public.app_data;
create policy "users can read own app data" on public.app_data for select to authenticated using(auth.uid()=user_id);
drop policy if exists "users can insert own app data" on public.app_data;
create policy "users can insert own app data" on public.app_data for insert to authenticated with check(auth.uid()=user_id);
drop policy if exists "users can update own app data" on public.app_data;
create policy "users can update own app data" on public.app_data for update to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
grant select,insert,update on public.app_data to authenticated;
