-- Migración ya aplicada el 30/08/2026.
create table if not exists public.event_exclusions (
  event_id uuid not null references public.events(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  excluded_by uuid null references public.profiles(id) on delete set null,
  excluded_at timestamptz not null default now(),
  primary key(event_id,user_id)
);
alter table public.event_exclusions enable row level security;
drop policy if exists event_exclusions_read on public.event_exclusions;
drop policy if exists event_exclusions_admin_all on public.event_exclusions;
create policy event_exclusions_read on public.event_exclusions for select to authenticated
using(user_id=auth.uid() or public.is_admin());
create policy event_exclusions_admin_all on public.event_exclusions for all to authenticated
using(public.is_admin()) with check(public.is_admin());
grant select,insert,update,delete on public.event_exclusions to authenticated;
