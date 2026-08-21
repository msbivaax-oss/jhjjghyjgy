-- Bivaax Trade Enterprise Backup (Logical Fallback)
-- Generated at: 2026-08-21T09:14:12.343Z
-- Requested by: test_admin

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

-- Dumping data for table users (1 rows)
INSERT INTO "users" ("id", "uid", "email", "display_name", "nickname", "photo_url", "password_hash", "real_balance", "demo_balance", "currency", "tfa_enabled", "tfa_mode", "tfa_secret", "is_verified", "is_email_verified", "is_nid_verified", "nid_number", "is_admin", "phone", "country", "country_code", "first_name", "last_name", "gender", "dob", "status", "kyc_status", "referred_by_uid", "referral_code", "referral_sub_id", "referral_type", "affiliate_balance", "total_affiliate_earnings", "referral_count", "custom_affiliate_share", "withdrawal_otp", "withdrawal_otp_expires_at", "total_live_volume", "smart_mode_enabled", "smart_mode_strategy", "manipulation_mode", "updated_at", "created_at") VALUES (1, 'test_uid_123', 'test@example.com', 'Test User', NULL, NULL, NULL, 0, 10000, 'USD', 0, 'app', NULL, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Standard', 'unverified', NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, 0, 0, 'auto_25_percent', 'neutral', NULL, NULL) ON CONFLICT DO NOTHING;

--
-- Table structure for trades
--


--
-- Table structure for transactions
--


--
-- Table structure for audit_logs
--

-- Dumping data for table audit_logs (8 rows)
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (1, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787302296543', 'Database backup created successfully: backup_2026-08-21T08-51-36-543Z_1787302296543.sql (0.00 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787302296543) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (2, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787302402756', 'Database backup created successfully: backup_2026-08-21T08-53-22-756Z_1787302402756.sql (0.00 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787302402756) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (3, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787302969795', 'Database backup created successfully: backup_2026-08-21T09-02-49-795Z_1787302969795.sql (0.00 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787302969795) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (4, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303014920', 'Database backup created successfully: backup_2026-08-21T09-03-34-920Z_1787303014920.sql (0.00 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303014920) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (5, 'test_admin', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303382090', 'Database backup created successfully: backup_2026-08-21T09-09-42-090Z_1787303382090.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303382090) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (6, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303460474', 'Database backup created successfully: backup_2026-08-21T09-11-00-474Z_1787303460474.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303460474) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (7, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303466918', 'Database backup created successfully: backup_2026-08-21T09-11-06-918Z_1787303466918.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303466918) ON CONFLICT DO NOTHING;
INSERT INTO "audit_logs" ("id", "user_id", "action", "entity_type", "entity_id", "details", "ip_address", "created_at") VALUES (8, 'system_pre_boot', 'DATABASE_BACKUP', 'system_backup', 'bk_1787303603642', 'Database backup created successfully: backup_2026-08-21T09-13-23-642Z_1787303603642.sql (0.01 MB). Type: logical_dumper. Synced to secure off-site backup storage.', NULL, 1787303603642) ON CONFLICT DO NOTHING;

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

-- Dumping data for table system_backups (12 rows)
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
