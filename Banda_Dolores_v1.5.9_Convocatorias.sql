-- Migración ya aplicada al proyecto Banda-dolores el 30/08/2026.
alter table public.events add column if not exists invite_mode text;
update public.events set invite_mode='legacy' where invite_mode is null;
alter table public.events alter column invite_mode set default 'legacy';
alter table public.events alter column invite_mode set not null;
alter table public.events drop constraint if exists events_invite_mode_check;
alter table public.events add constraint events_invite_mode_check
check (invite_mode in ('legacy','all','wind','percussion','school','official','individual'));

create table if not exists public.event_invitees(
  event_id uuid not null references public.events(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  invited_at timestamptz not null default now(),
  primary key(event_id,user_id)
);
alter table public.event_invitees enable row level security;
drop policy if exists event_invitees_read on public.event_invitees;
drop policy if exists event_invitees_admin_all on public.event_invitees;
create policy event_invitees_read on public.event_invitees for select to authenticated
using(user_id=auth.uid() or public.is_admin());
create policy event_invitees_admin_all on public.event_invitees for all to authenticated
using(public.is_admin()) with check(public.is_admin());
grant select,insert,update,delete on public.event_invitees to authenticated;
