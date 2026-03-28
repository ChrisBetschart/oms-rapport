-- ============================================================
-- RMA / Reparaturen Modul — Supabase Migration
-- Ausführen im Supabase SQL Editor (Dashboard → SQL Editor)
-- ============================================================

-- Tabelle: Reparatur-/RMA-Fälle
create table if not exists rma_faelle (
  id                    uuid default gen_random_uuid() primary key,
  titel                 text not null,
  typ                   text not null default 'intern',         -- 'intern' | 'extern'
  prioritaet            text not null default 'normal',         -- 'normal' | 'dringend'
  status                text not null default 'defekt_gemeldet',
  -- Gerätedaten
  geraet                text,
  marke                 text,
  artikelnummer         text,
  seriennummer          text,
  garantie              text default 'unbekannt',               -- 'ja' | 'nein' | 'unbekannt'
  -- Zuweisung
  fehlerbeschreibung    text,
  kunde                 text,
  projektnummer         text,
  zustaendig            text,
  datum_defekt          date,
  bemerkung             text,
  -- Extern / RMA
  lieferant             text,
  rma_nummer            text,
  datum_eingeschickt    date,
  datum_zurueck_erwartet date,
  versand_tracking      text,
  ruecksendungsart      text,                                   -- 'reparatur' | 'austausch' | 'gutschrift' | 'offen'
  reparaturkosten       numeric(10,2),
  transportkosten       numeric(10,2),
  -- Metadaten
  abgeschlossen         boolean default false,
  abgeschlossen_am      timestamptz,
  erstellt_am           timestamptz default now(),
  erstellt_von          text,
  geaendert_am          timestamptz,
  geaendert_von         text
);

-- Tabelle: Verlaufsprotokoll (Audit Trail)
create table if not exists rma_verlauf (
  id              uuid default gen_random_uuid() primary key,
  fall_id         uuid references rma_faelle(id) on delete cascade,
  zeitstempel     timestamptz default now(),
  benutzer_name   text,
  alter_status    text,
  neuer_status    text,
  bemerkung       text
);

-- Row Level Security deaktivieren (wie bestehende Tabellen — auth über App-Logik)
alter table rma_faelle disable row level security;
alter table rma_verlauf disable row level security;

-- Indexe für Performance
create index if not exists idx_rma_faelle_abgeschlossen on rma_faelle(abgeschlossen);
create index if not exists idx_rma_faelle_typ on rma_faelle(typ);
create index if not exists idx_rma_verlauf_fall_id on rma_verlauf(fall_id);
