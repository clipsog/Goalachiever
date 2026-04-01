-- Run this once in Supabase: Dashboard → SQL → New query → Run
-- Fixes: PGRST205 "Could not find the table 'public.goal_app_state'"

create table if not exists public.goal_app_state (
  id text primary key,
  goals jsonb not null default '[]'::jsonb,
  tasks jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.goal_app_state enable row level security;

-- Browser app uses the anon key; allow it to read/write this single table.
-- Tighten later (e.g. auth.uid()) when you add login.
drop policy if exists "goal_app_state_anon_all" on public.goal_app_state;
create policy "goal_app_state_anon_all"
  on public.goal_app_state
  for all
  to anon
  using (true)
  with check (true);

grant usage on schema public to anon;
grant select, insert, update, delete on table public.goal_app_state to anon;
