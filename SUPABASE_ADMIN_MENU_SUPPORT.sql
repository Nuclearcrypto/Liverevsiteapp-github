-- Rev-N-Rip Admin Menu Support SQL
-- Optional but recommended.
-- Run this in Supabase SQL Editor if your profiles table does not already have admin fields.

alter table if exists public.profiles
add column if not exists is_admin boolean default false,
add column if not exists role text default 'user';

-- Make Jessie/admin email an admin if that profile exists.
update public.profiles
set is_admin = true,
    role = 'admin'
where lower(email) in ('xflight1125@gmail.com', 'info.revnrip@gmail.com');

-- To make another user admin later:
-- update public.profiles
-- set is_admin = true, role = 'admin'
-- where lower(email) = 'their-email@example.com';
