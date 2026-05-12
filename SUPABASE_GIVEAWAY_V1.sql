-- Rev-N-Rip Giveaway V1 Supabase SQL
-- Run this in Supabase SQL Editor when ready.

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
create policy "active giveaways are viewable" on public.giveaways for select to authenticated using (status in ('active','closed'));

drop policy if exists "users can view own giveaway entries" on public.giveaway_entries;
create policy "users can view own giveaway entries" on public.giveaway_entries for select to authenticated using (user_id = auth.uid());

drop policy if exists "users can enter giveaways once" on public.giveaway_entries;
create policy "users can enter giveaways once" on public.giveaway_entries for insert to authenticated with check (user_id = auth.uid());

insert into public.giveaways (slug, title, prize_title, description, status)
values ('launch-beta-pack','Beta Garage Pack Giveaway','Mystery TCG pack bundle','Help test Rev-N-Rip and enter the beta-only giveaway.','active')
on conflict (slug) do nothing;

-- Admin tracking query:
-- select ge.entered_at, g.title, p.username, p.full_name, p.mailing_address_line_1, p.mailing_city, p.mailing_state, p.mailing_postal_code
-- from public.giveaway_entries ge
-- join public.giveaways g on g.id = ge.giveaway_id
-- left join public.profiles p on p.id = ge.user_id
-- order by ge.entered_at desc;
