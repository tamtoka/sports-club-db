PRAGMA foreign_keys = ON;
CREATE TABLE members (id INTEGER PRIMARY KEY, full_name TEXT NOT NULL, email TEXT NOT NULL UNIQUE, birth_date TEXT NOT NULL CHECK (date(birth_date) IS NOT NULL));
CREATE TABLE trainers (id INTEGER PRIMARY KEY, full_name TEXT NOT NULL, specialty TEXT NOT NULL);
CREATE TABLE classes (id INTEGER PRIMARY KEY, trainer_id INTEGER NOT NULL REFERENCES trainers(id), title TEXT NOT NULL, starts_at TEXT NOT NULL, ends_at TEXT NOT NULL, capacity INTEGER NOT NULL CHECK(capacity > 0), CHECK(datetime(starts_at) IS NOT NULL AND datetime(ends_at) IS NOT NULL AND ends_at > starts_at));
CREATE TABLE visits (id INTEGER PRIMARY KEY, member_id INTEGER NOT NULL REFERENCES members(id), class_id INTEGER NOT NULL REFERENCES classes(id), status TEXT NOT NULL CHECK(status IN ('booked','attended')), UNIQUE(member_id, class_id));
CREATE TABLE payments (id INTEGER PRIMARY KEY, member_id INTEGER NOT NULL REFERENCES members(id), membership_type TEXT NOT NULL, amount INTEGER NOT NULL CHECK(amount > 0), paid_on TEXT NOT NULL, valid_from TEXT NOT NULL, valid_until TEXT NOT NULL, CHECK(date(paid_on) IS NOT NULL AND date(valid_from) IS NOT NULL AND date(valid_until) IS NOT NULL AND valid_until >= valid_from));
CREATE INDEX idx_classes_trainer ON classes(trainer_id);
CREATE INDEX idx_visits_class ON visits(class_id);
CREATE INDEX idx_payments_member ON payments(member_id);
