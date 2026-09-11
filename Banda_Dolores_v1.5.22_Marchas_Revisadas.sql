-- v1.5.22 · Marchas revisadas
-- Aplicar SOLO si no existe la columna media_type.
alter table public.march_videos
  add column if not exists media_type text not null default 'video';

alter table public.march_videos
  drop constraint if exists march_videos_media_type_check;

alter table public.march_videos
  add constraint march_videos_media_type_check
  check (media_type in ('video','audio','semana_santa'));
