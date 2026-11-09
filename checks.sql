-- 1. Активные абонементы на дату выполнения.
SELECT m.full_name, p.membership_type, p.valid_until FROM payments p JOIN members m ON m.id=p.member_id WHERE date('now','localtime') BETWEEN p.valid_from AND p.valid_until;
-- 2. Записи на каждое занятие по датам.
SELECT date(c.starts_at) AS class_date, c.title, COUNT(v.id) AS people FROM classes c LEFT JOIN visits v ON v.class_id=c.id GROUP BY c.id ORDER BY c.starts_at;
-- 3. Тренеры и их занятия.
SELECT t.full_name, c.title, c.starts_at FROM trainers t LEFT JOIN classes c ON c.trainer_id=t.id ORDER BY t.full_name, c.starts_at;
-- 4. Нет посещений за последние 30 дней, включая тех, кто ещё не посещал клуб.
SELECT m.full_name, MAX(CASE WHEN v.status='attended' THEN c.starts_at END) AS last_visit FROM members m LEFT JOIN visits v ON v.member_id=m.id LEFT JOIN classes c ON c.id=v.class_id GROUP BY m.id HAVING last_visit IS NULL OR datetime(last_visit) < datetime('now','localtime','-30 days');
-- 5. Три занятия с наибольшим числом записей.
SELECT c.title, c.starts_at, COUNT(v.id) AS people FROM classes c LEFT JOIN visits v ON v.class_id=c.id GROUP BY c.id ORDER BY people DESC, c.id LIMIT 3;
-- 6. Выручка по типам абонементов, в рублях.
SELECT membership_type, SUM(amount) AS revenue FROM payments GROUP BY membership_type;
-- 7. Пересечения занятий одного участника, граничащие занятия не пересекаются.
SELECT m.full_name, a.title AS class_1, a.starts_at AS start_1, b.title AS class_2, b.starts_at AS start_2 FROM visits va JOIN visits vb ON va.member_id=vb.member_id AND va.class_id<vb.class_id JOIN members m ON m.id=va.member_id JOIN classes a ON a.id=va.class_id JOIN classes b ON b.id=vb.class_id WHERE a.starts_at < b.ends_at AND b.starts_at < a.ends_at;
-- 8. Свободные места на занятиях.
SELECT c.title, c.starts_at, c.capacity-COUNT(v.id) AS free_places FROM classes c LEFT JOIN visits v ON v.class_id=c.id GROUP BY c.id ORDER BY c.starts_at;

