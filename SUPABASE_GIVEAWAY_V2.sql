-- Rev-N-Rip Giveaway V2 SQL
-- Run this in Supabase SQL Editor.

alter table if exists public.profiles
add column if not exists full_name text,
add column if not exists phone text,
add column if not exists mailing_address_line_1 text,
add column if not exists mailing_address_line_2 text,
add column if not exists mailing_city text,
add column if not exists mailing_state text,
add column if not exists mailing_postal_code text,
add column if not exists mailing_country text default 'US',
add column if not exists mailing_address_updated_at timestamptz;

create table if not exists public.giveaways (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  title text not null,
  prize_title text not null,
  description text,
  status text not null default 'active' check (status in ('draft','active','closed','archived')),
  starts_at timestamptz default now(),
  ends_at timestamptz,
  max_entries_per_user integer not null default 1,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.giveaway_entries (
  id uuid primary key default gen_random_uuid(),
  giveaway_id uuid not null references public.giveaways(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  entry_source text default 'app',
  shipping_profile_snapshot jsonb,
  entered_at timestamptz default now(),
  unique (giveaway_id, user_id)
);

alter table public.giveaways enable row level security;
alter table public.giveaway_entries enable row level security;

drop policy if exists "active giveaways are viewable" on public.giveaways;
create policy "active giveaways are viewable" on public.giveaways
on public.giveaways for select to authenticated using (status in ('active','closed'));

drop policy if exists "users can view own giveaway entries" on public.giveaway_entries;
create policy "users can view own giveaway entries"
on public.giveaway_entries for select to authenticated using (user_id = auth.uid());

drop policy if exists "users can enter giveaways once" on public.giveaway_entries;
create policy "users can enter giveaways once"
on public.giveaway_entries for insert to authenticated with check (user_id = auth.uid());

create or replace view public.giveaway_entries_compiled as
select
  ge.id,
  ge.entered_at,
  ge.entry_source,
  g.slug as giveaway_slug,
  g.title as giveaway_title,
  g.prize_title,
  p.username,
  p.email,
  p.full_name,
  p.phone,
  p.mailing_address_line_1,
  p.mailing_address_line_2,
  p.mailing_city,
  p.mailing_state,
  p.mailing_postal_code,
  p.mailing_country,
  ge.shipping_profile_snapshot
from public.giveaway_entries ge
join public.giveaways g on g.id = ge.giveaway_id
left join public.profiles p on p.id = ge.user_id
order by ge.entered_at desc;

insert into public.giveaways (slug, title, prize_title, description, status)
values ('launch-beta-pack','Beta Garage Pack Giveaway','Rev-N-Rip Mystery Box','Enter the Rev-N-Rip beta giveaway for a mystery box prize.','active')
on conflict (slug) do update set
  title = excluded.title,
  prize_title = excluded.prize_title,
  description = excluded.description,
  status = excluded.status,
  updated_at = now();

-- To review entries later:
-- select * from public.giveaway_entries_compiled;
