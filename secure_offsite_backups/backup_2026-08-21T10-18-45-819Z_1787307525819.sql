-- Bivaax Trade Enterprise Backup (Logical Fallback)
-- Generated at: 2026-08-21T10:18:45.819Z
-- Requested by: system_pre_boot

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


--
-- Table structure for users
--

-- Dumping data for table users (3 rows)
INSERT INTO "users" ("id", "uid", "email", "display_name", "nickname", "photo_url", "password_hash", "real_balance", "demo_balance", "currency", "tfa_enabled", "tfa_mode", "tfa_secret", "is_verified", "is_email_verified", "is_nid_verified", "nid_number", "is_admin", "phone", "country", "country_code", "first_name", "last_name", "gender", "dob", "status", "kyc_status", "referred_by_uid", "referral_code", "referral_sub_id", "referral_type", "affiliate_balance", "total_affiliate_earnings", "referral_count", "custom_affiliate_share", "withdrawal_otp", "withdrawal_otp_expires_at", "total_live_volume", "smart_mode_enabled", "smart_mode_strategy", "manipulation_mode", "updated_at", "created_at") VALUES (1, 'test_uid_123', 'test@example.com', 'Test User', NULL, NULL, NULL, 0, 10000, 'USD', 0, 'app', NULL, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Standard', 'unverified', NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, 0, 0, 'auto_25_percent', 'neutral', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO "users" ("id", "uid", "email", "display_name", "nickname", "photo_url", "password_hash", "real_balance", "demo_balance", "currency", "tfa_enabled", "tfa_mode", "tfa_secret", "is_verified", "is_email_verified", "is_nid_verified", "nid_number", "is_admin", "phone", "country", "country_code", "first_name", "last_name", "gender", "dob", "status", "kyc_status", "referred_by_uid", "referral_code", "referral_sub_id", "referral_type", "affiliate_balance", "total_affiliate_earnings", "referral_count", "custom_affiliate_share", "withdrawal_otp", "withdrawal_otp_expires_at", "total_live_volume", "smart_mode_enabled", "smart_mode_strategy", "manipulation_mode", "updated_at", "created_at") VALUES (2, 'admin_seed_06ul4xm4', 'hamproosapport@gmail.com', 'Bivaax Super Admin', 'Admin', NULL, '$2b$10$mIh5Ua6p.s4wNRO2J6xXPOYUC23c0lqD9sZLcfrqXXmUYnMMCfd1K', 1000, 10000, 'USD', 0, 'app', NULL, 0, 0, 0, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Standard', 'unverified', NULL, 'JPGKOJ', NULL, NULL, 0, 0, 0, NULL, NULL, NULL, 0, 0, 'auto_25_percent', 'neutral', NULL, 1787304655983) ON CONFLICT DO NOTHING;
INSERT INTO "users" ("id", "uid", "email", "display_name", "nickname", "photo_url", "password_hash", "real_balance", "demo_balance", "currency", "tfa_enabled", "tfa_mode", "tfa_secret", "is_verified", "is_email_verified", "is_nid_verified", "nid_number", "is_admin", "phone", "country", "country_code", "first_name", "last_name", "gender", "dob", "status", "kyc_status", "referred_by_uid", "referral_code", "referral_sub_id", "referral_type", "affiliate_balance", "total_affiliate_earnings", "referral_count", "custom_affiliate_share", "withdrawal_otp", "withdrawal_otp_expires_at", "total_live_volume", "smart_mode_enabled", "smart_mode_strategy", "manipulation_mode", "updated_at", "created_at") VALUES (3, 'P0H1JYBZHJWlquOQ4yyfdjSy3Kc2', 'hasan1@gmail.com', 'hasan1', NULL, NULL, NULL, 0, 9998.9, 'USD', 0, 'app', NULL, 0, 0, 0, NULL, 0, NULL, 'Bangladesh', 'BD', NULL, NULL, NULL, NULL, 'Standard', 'unverified', NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, 0, 0, 'auto_25_percent', 'neutral', NULL, NULL) ON CONFLICT DO NOTHING;

--
-- Table structure for trades
--

-- Dumping data for table trades (3 rows)
INSERT INTO "trades" ("id", "firebase_id", "user_id", "market_id", "asset", "amount", "direction", "type", "entry_price", "exit_price", "duration", "time_left", "expiry_time", "expiration_time", "is_demo", "account_type", "tournament_id", "status", "payout_amount", "payout", "settled_at", "updated_at", "created_at") VALUES (1, NULL, 'P0H1JYBZHJWlquOQ4yyfdjSy3Kc2', 'AUD/USD (OTC)', NULL, 1, 'down', NULL, 0.6555858666103046, 0.65016, 88, NULL, 1787305920, NULL, 1, 'demo', NULL, 'won', 1.9, NULL, 1787305919, NULL, 1787305832295) ON CONFLICT DO NOTHING;
INSERT INTO "trades" ("id", "firebase_id", "user_id", "market_id", "asset", "amount", "direction", "type", "entry_price", "exit_price", "duration", "time_left", "expiry_time", "expiration_time", "is_demo", "account_type", "tournament_id", "status", "payout_amount", "payout", "settled_at", "updated_at", "created_at") VALUES (2, NULL, 'P0H1JYBZHJWlquOQ4yyfdjSy3Kc2', 'AUD/USD (OTC)', NULL, 1, 'up', NULL, 0.6551161033196482, 0.65016, 85, NULL, 1787305920, NULL, 1, 'demo', NULL, 'lost', 0, NULL, 1787305919, NULL, 1787305835168) ON CONFLICT DO NOTHING;
INSERT INTO "trades" ("id", "firebase_id", "user_id", "market_id", "asset", "amount", "direction", "type", "entry_price", "exit_price", "duration", "time_left", "expiry_time", "expiration_time", "is_demo", "account_type", "tournament_id", "status", "payout_amount", "payout", "settled_at", "updated_at", "created_at") VALUES (3, NULL, 'P0H1JYBZHJWlquOQ4yyfdjSy3Kc2', 'AUD/USD (OTC)', NULL, 1, 'up', NULL, 0.6557496763233405, 0.65016, 81, NULL, 1787305919, NULL, 1, 'demo', NULL, 'lost', 0, NULL, 1787305919, NULL, 1787305838595) ON CONFLICT DO NOTHING;

--
-- Table structure for transactions
--


--
-- Table structure for audit_logs
--

-- Dumping data for table audit_logs (16 rows)
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (1, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787302296543', 'Database backup created successfully: backup_2026-08-21T08-51-36-543Z_1787302296543.sql (0.00 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787302296543) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (2, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787302402756', 'Database backup created successfully: backup_2026-08-21T08-53-22-756Z_1787302402756.sql (0.00 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787302402756) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (3, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787302969795', 'Database backup created successfully: backup_2026-08-21T09-02-49-795Z_1787302969795.sql (0.00 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787302969795) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (4, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303014920', 'Database backup created successfully: backup_2026-08-21T09-03-34-920Z_1787303014920.sql (0.00 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303014920) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (5, 'test_admin', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303382090', 'Database backup created successfully: backup_2026-08-21T09-09-42-090Z_1787303382090.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303382090) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (6, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303460474', 'Database backup created successfully: backup_2026-08-21T09-11-00-474Z_1787303460474.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303460474) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (7, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303466918', 'Database backup created successfully: backup_2026-08-21T09-11-06-918Z_1787303466918.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303466918) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (8, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303603642', 'Database backup created successfully: backup_2026-08-21T09-13-23-642Z_1787303603642.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303603642) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (9, 'test_admin', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303652343', 'Database backup created successfully: backup_2026-08-21T09-14-12-343Z_1787303652343.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303652343) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (10, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303723631', 'Database backup created successfully: backup_2026-08-21T09-15-23-631Z_1787303723631.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303723631) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (11, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787304397712', 'Database backup created successfully: backup_2026-08-21T09-26-37-712Z_1787304397712.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787304397712) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (12, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787304667591', 'Database backup created successfully: backup_2026-08-21T09-31-07-591Z_1787304667591.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787304667591) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (13, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787305134797', 'Database backup created successfully: backup_2026-08-21T09-38-54-797Z_1787305134797.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787305134797) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (14, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787305504604', 'Database backup created successfully: backup_2026-08-21T09-45-04-604Z_1787305504604.sql (0.02 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787305504604) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (15, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787305793461', 'Database backup created successfully: backup_2026-08-21T09-49-53-461Z_1787305793461.sql (0.02 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787305793461) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (16, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787305807018', 'Database backup created successfully: backup_2026-08-21T09-50-07-018Z_1787305807018.sql (0.02 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787305807018) ON CONFLICT DO NOTHING;

--
-- Table structure for tickets
--


--
-- Table structure for ticket_messages
--


--
-- Table structure for active_copies
--


--
-- Table structure for candles
--


--
-- Table structure for system_backups
--

-- Dumping data for table system_backups (20 rows)
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_fail_1787301703084', 1787301703084, 'N/A', 0, 'failed', 0, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_fail_1787301708992', 1787301708992, 'N/A', 0, 'failed', 0, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787302150543', 1787302150543, 'backup_2026-08-21T08-49-10-543Z_1787302150543.sql', 1239, 'success', 10, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_fail_1787302150543', 1787302150543, 'N/A', 0, 'failed', 0, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787302296543', 1787302296543, 'backup_2026-08-21T08-51-36-543Z_1787302296543.sql', 1731, 'success', 10, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787302402756', 1787302402756, 'backup_2026-08-21T08-53-22-756Z_1787302402756.sql', 2463, 'success', 10, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787302969795', 1787302969795, 'backup_2026-08-21T09-02-49-795Z_1787302969795.sql', 3149, 'success', 10, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787303014920', 1787303014920, 'backup_2026-08-21T09-03-34-920Z_1787303014920.sql', 3835, 'success', 10, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787303382090', 1787303382090, 'backup_2026-08-21T09-09-42-090Z_1787303382090.sql', 5575, 'success', 10, 'test_admin') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787303460474', 1787303460474, 'backup_2026-08-21T09-11-00-474Z_1787303460474.sql', 6256, 'success', 10, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787303466918', 1787303466918, 'backup_2026-08-21T09-11-06-918Z_1787303466918.sql', 6943, 'success', 10, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787303603642', 1787303603642, 'backup_2026-08-21T09-13-23-642Z_1787303603642.sql', 7629, 'success', 10, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787303652343', 1787303652343, 'backup_2026-08-21T09-14-12-343Z_1787303652343.sql', 8310, 'success', 10, 'test_admin') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787303723631', 1787303723631, 'backup_2026-08-21T09-15-23-631Z_1787303723631.sql', 8991, 'success', 10, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787304397712', 1787304397712, 'backup_2026-08-21T09-26-37-712Z_1787304397712.sql', 9679, 'success', 10, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787304667591', 1787304667591, 'backup_2026-08-21T09-31-07-591Z_1787304667591.sql', 11485, 'success', 10, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787305134797', 1787305134797, 'backup_2026-08-21T09-38-54-797Z_1787305134797.sql', 12416, 'success', 15, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787305504604', 1787305504604, 'backup_2026-08-21T09-45-04-604Z_1787305504604.sql', 18569, 'success', 16, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787305793461', 1787305793461, 'backup_2026-08-21T09-49-53-461Z_1787305793461.sql', 19257, 'success', 16, 'system_pre_boot') ON CONFLICT DO NOTHING;
INSERT INTO "system_backups" ("id", "timestamp", "filename", "size", "status", "tables_count", "created_by") VALUES ('bk_1787305807018', 1787305807018, 'backup_2026-08-21T09-50-07-018Z_1787305807018.sql', 19945, 'success', 16, 'system_pre_boot') ON CONFLICT DO NOTHING;

--
-- Table structure for master_traders
--

-- Dumping data for table master_traders (6 rows)
INSERT INTO "master_traders" ("id", "name", "country", "win_rate", "profit", "followers") VALUES ('m1', 'CRISHTTRADER', '🇻🇪', 88, 45000, 6) ON CONFLICT DO NOTHING;
INSERT INTO "master_traders" ("id", "name", "country", "win_rate", "profit", "followers") VALUES ('m2', 'OBOROTEN', '🇺🇦', 81, 86000, 13) ON CONFLICT DO NOTHING;
INSERT INTO "master_traders" ("id", "name", "country", "win_rate", "profit", "followers") VALUES ('m3', 'GEOVANNY', '🇨🇴', 74, 12000, 5) ON CONFLICT DO NOTHING;
INSERT INTO "master_traders" ("id", "name", "country", "win_rate", "profit", "followers") VALUES ('m4', 'ALEX FOREX', '🇬🇧', 92, 125000, 38) ON CONFLICT DO NOTHING;
INSERT INTO "master_traders" ("id", "name", "country", "win_rate", "profit", "followers") VALUES ('m5', 'BINANCE WHALE', '🇸🇬', 85, 240000, 71) ON CONFLICT DO NOTHING;
INSERT INTO "master_traders" ("id", "name", "country", "win_rate", "profit", "followers") VALUES ('m6', 'TRADEMINATOR', '🇧🇩', 89, 155000, 42) ON CONFLICT DO NOTHING;

--
-- Table structure for tournaments
--

-- Dumping data for table tournaments (3 rows)
INSERT INTO "tournaments" ("id", "type", "title", "description", "banner_url", "prize_pool", "entry_fee", "min_players", "max_players", "start_time", "end_time", "status", "is_locked", "requirements", "created_at") VALUES ('t-daily-free', 'Daily Free', 'Daily Freebie Blast', 'Join the daily free tournament and win real cash prizes! No entry fee required.', 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&q=80&w=1000', 100, 0, 10, 1000, 1787308737555, 1787391537555, 'scheduled', 0, '{"minBalance":0}', 1787305137555) ON CONFLICT DO NOTHING;
INSERT INTO "tournaments" ("id", "type", "title", "description", "banner_url", "prize_pool", "entry_fee", "min_players", "max_players", "start_time", "end_time", "status", "is_locked", "requirements", "created_at") VALUES ('t-weekly-pro', 'Weekly', 'Weekly Pro Challenge', 'Compete with the best for a massive prize pool. Show your trading skills!', 'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?auto=format&fit=crop&q=80&w=1000', 5000, 10, 50, 5000, 1787477937555, 1788082737555, 'scheduled', 1, '{"minBalance":100,"kycRequired":true}', 1787305137555) ON CONFLICT DO NOTHING;
INSERT INTO "tournaments" ("id", "type", "title", "description", "banner_url", "prize_pool", "entry_fee", "min_players", "max_players", "start_time", "end_time", "status", "is_locked", "requirements", "created_at") VALUES ('t-prestige-elite', 'Prestige', 'Elite Prestige Cup', 'The ultimate tournament for our VIP traders. High stakes, higher rewards.', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&q=80&w=1000', 25000, 100, 10, 100, 1787909937555, 1788514737555, 'scheduled', 1, '{"minBalance":1000,"statusRequired":"VIP"}', 1787305137555) ON CONFLICT DO NOTHING;

--
-- Table structure for tournament_prizes
--

-- Dumping data for table tournament_prizes (9 rows)
INSERT INTO "tournament_prizes" ("id", "tournament_id", "rank_from", "rank_to", "prize_amount") VALUES (1, 't-daily-free', 1, 1, 50) ON CONFLICT DO NOTHING;
INSERT INTO "tournament_prizes" ("id", "tournament_id", "rank_from", "rank_to", "prize_amount") VALUES (2, 't-daily-free', 2, 2, 20) ON CONFLICT DO NOTHING;
INSERT INTO "tournament_prizes" ("id", "tournament_id", "rank_from", "rank_to", "prize_amount") VALUES (3, 't-daily-free', 3, 3, 10) ON CONFLICT DO NOTHING;
INSERT INTO "tournament_prizes" ("id", "tournament_id", "rank_from", "rank_to", "prize_amount") VALUES (4, 't-weekly-pro', 1, 1, 2500) ON CONFLICT DO NOTHING;
INSERT INTO "tournament_prizes" ("id", "tournament_id", "rank_from", "rank_to", "prize_amount") VALUES (5, 't-weekly-pro', 2, 2, 1000) ON CONFLICT DO NOTHING;
INSERT INTO "tournament_prizes" ("id", "tournament_id", "rank_from", "rank_to", "prize_amount") VALUES (6, 't-weekly-pro', 3, 3, 500) ON CONFLICT DO NOTHING;
INSERT INTO "tournament_prizes" ("id", "tournament_id", "rank_from", "rank_to", "prize_amount") VALUES (7, 't-prestige-elite', 1, 1, 12500) ON CONFLICT DO NOTHING;
INSERT INTO "tournament_prizes" ("id", "tournament_id", "rank_from", "rank_to", "prize_amount") VALUES (8, 't-prestige-elite', 2, 2, 5000) ON CONFLICT DO NOTHING;
INSERT INTO "tournament_prizes" ("id", "tournament_id", "rank_from", "rank_to", "prize_amount") VALUES (9, 't-prestige-elite', 3, 3, 2500) ON CONFLICT DO NOTHING;

--
-- Table structure for tournament_participants
--


--
-- Table structure for historical_candles
--


--
-- Table structure for leaderboard_stats
--

