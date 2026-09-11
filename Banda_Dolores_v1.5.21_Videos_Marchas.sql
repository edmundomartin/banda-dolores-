-- v1.5.21 · Vídeos de marchas con acceso individual
-- ESTA MIGRACIÓN YA ESTÁ APLICADA EN PRODUCCIÓN.
create table if not exists public.march_videos (
  id uuid primary key default gen_random_uuid(),
  march_id uuid not null references public.marches(id) on delete cascade,
  title text not null,
  video_url text not null,
  created_by uuid null references public.profiles(id) on delete set null,
  created_at timestamptz not null default now()
);
create table if not exists public.march_video_access (
  video_id uuid not null references public.march_videos(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  granted_by uuid null references public.profiles(id) on delete set null,
  granted_at timestamptz not null default now(),
  primary key (video_id,user_id)
);
