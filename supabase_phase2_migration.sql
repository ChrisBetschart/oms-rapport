-- ============================================================
-- Phase 2 Migration — Vorlagen, Lager-Verknüpfungen
-- Ausführen im Supabase SQL Editor (Dashboard → SQL Editor)
-- ============================================================

-- Tabelle: Wareneingang-Vorlagen
create table if not exists we_vorlagen (
  id           uuid default gen_random_uuid() primary key,
  name         text not null,
  positionen   jsonb,
  erstellt_am  timestamptz default now(),
  erstellt_von text
);

-- Row Level Security deaktivieren
alter table we_vorlagen disable row level security;

-- Lager-Verknüpfung für RMA-Fälle
alter table rma_faelle
  add column if not exists lager_id uuid;

-- Lager-Verknüpfung für Wareneingang-Positionen
alter table wareneingang_positionen
  add column if not exists lager_id uuid;

-- Index für Vorlagen-Suche
create index if not exists idx_we_vorlagen_name on we_vorlagen(name);
