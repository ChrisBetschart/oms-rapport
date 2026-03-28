-- ============================================================
-- Wareneingang-Modul — Supabase Migration
-- Ausführen im Supabase SQL Editor (Dashboard → SQL Editor)
-- ============================================================

-- Tabelle: Wareneingang (Lieferungskopf)
create table if not exists wareneingang (
  id               uuid default gen_random_uuid() primary key,
  projekt          text not null,
  kunde            text,
  lieferant        text,
  lieferschein_nr  text,
  datum            date,
  status           text not null default 'offen',  -- 'offen' | 'teillieferung' | 'vollstaendig' | 'problem'
  pos_total        int default 0,                   -- Anzahl Positionen total
  pos_erhalten     int default 0,                   -- Anzahl Positionen mit Status 'erhalten'
  bemerkung        text,
  erstellt_am      timestamptz default now(),
  erstellt_von     text,
  geaendert_am     timestamptz,
  geaendert_von    text
);

-- Tabelle: Wareneingang-Positionen (einzelne Artikel)
create table if not exists wareneingang_positionen (
  id               uuid default gen_random_uuid() primary key,
  eingang_id       uuid references wareneingang(id) on delete cascade,
  bezeichnung      text not null,
  artikelnummer    text,
  menge_bestellt   numeric(10,2),
  menge_erhalten   numeric(10,2),
  einheit          text default 'Stk',
  status           text not null default 'erhalten', -- 'erhalten' | 'teilweise' | 'fehlt' | 'beschaedigt'
  bemerkung        text,
  reihenfolge      int default 0
);

-- Row Level Security deaktivieren (wie bestehende Tabellen)
alter table wareneingang disable row level security;
alter table wareneingang_positionen disable row level security;

-- Indexe
create index if not exists idx_wareneingang_status  on wareneingang(status);
create index if not exists idx_wareneingang_datum   on wareneingang(datum desc);
create index if not exists idx_we_pos_eingang_id    on wareneingang_positionen(eingang_id);
