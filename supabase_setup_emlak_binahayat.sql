-- ============================================
-- املاک بینهایت | Supabase Cloud Setup
-- این فایل را کامل در SQL Editor پروژه Supabase اجرا کن.
-- ============================================

create table if not exists public.app_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.app_data enable row level security;

revoke all on table public.app_data from anon;
grant select, insert, update, delete on table public.app_data to authenticated;

drop policy if exists "app_data_select_own" on public.app_data;
drop policy if exists "app_data_insert_own" on public.app_data;
drop policy if exists "app_data_update_own" on public.app_data;
drop policy if exists "app_data_delete_own" on public.app_data;

create policy "app_data_select_own"
on public.app_data
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "app_data_insert_own"
on public.app_data
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "app_data_update_own"
on public.app_data
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "app_data_delete_own"
on public.app_data
for delete
to authenticated
using ((select auth.uid()) = user_id);

-- کتابخانه فایل‌های ابری
insert into storage.buckets (id, name, public)
values ('property-files', 'property-files', false)
on conflict (id) do nothing;

drop policy if exists "property_files_select_own" on storage.objects;
drop policy if exists "property_files_insert_own" on storage.objects;
drop policy if exists "property_files_update_own" on storage.objects;
drop policy if exists "property_files_delete_own" on storage.objects;

create policy "property_files_select_own"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'property-files'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

create policy "property_files_insert_own"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'property-files'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

create policy "property_files_update_own"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'property-files'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
)
with check (
  bucket_id = 'property-files'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

create policy "property_files_delete_own"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'property-files'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);
