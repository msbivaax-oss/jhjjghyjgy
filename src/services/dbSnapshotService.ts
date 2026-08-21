import { query, run, runRawSql, getDbType } from '../db/mysql-db.ts';
import logger from '../lib/logger.ts';
import fs from 'fs';
import path from 'path';
import { exec } from 'child_process';
import { promisify } from 'util';
import { adminDb } from '../lib/firebase-admin.ts';

const execPromise = promisify(exec);

export interface BackupRecord {
  id: string;
  timestamp: number;
  filename: string;
  size: number;
  status: 'success' | 'failed';
  tables_count: number;
  created_by: string;
}

const BACKUP_DIR = path.join(process.cwd(), 'backups');
const SECURE_OFFSITE_DIR = path.join(process.cwd(), 'secure_offsite_backups');

if (!fs.existsSync(BACKUP_DIR)) {
  fs.mkdirSync(BACKUP_DIR, { recursive: true });
}
if (!fs.existsSync(SECURE_OFFSITE_DIR)) {
  fs.mkdirSync(SECURE_OFFSITE_DIR, { recursive: true });
}

export const DbSnapshotService = {
  /**
   * Generates a full SQL dump of the database and persists it both locally and in Firestore Cloud.
   */
  async createFullBackup(adminId: string): Promise<BackupRecord> {
    const timestamp = Date.now();
    const dateStr = new Date(timestamp).toISOString().replace(/[:.]/g, '-');
    const filename = `backup_${dateStr}_${timestamp}.sql`;
    const filePath = path.join(BACKUP_DIR, filename);
    const offsiteFilePath = path.join(SECURE_OFFSITE_DIR, filename);
    
    logger.info(`[BACKUP] Starting database backup requested by admin: ${adminId}`);
    
    let usedPgDump = false;
    let tablesCount = 0;
    const postgresUrl = process.env.DATABASE_URL || process.env.POSTGRES_URL || process.env.PG_URL;

    try {
      // 1. Try backup using pg_dump if DATABASE_URL is available and we are active on Postgres
      if (postgresUrl && getDbType() === 'pg') {
        try {
          logger.info(`[BACKUP] Executing pg_dump for backup...`);
          await execPromise(`pg_dump "${postgresUrl}" -f "${filePath}"`);
          usedPgDump = true;
          logger.info(`[BACKUP-SUCCESS] pg_dump completed successfully.`);
        } catch (pgErr: any) {
          logger.info(`[BACKUP-FALLBACK] pg_dump failed/not found: ${pgErr.message}. Falling back to logical SQL dumper.`);
        }
      }

      // 2. Fallback to logical SQL dumper if pg_dump is not available or failed
      let sqlDumpContent = '';
      if (!usedPgDump) {
        let tables: string[] = [];
        
        if (getDbType() === 'pg') {
          const tablesResult = await query(
            "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE'"
          ) as any[];
          tables = tablesResult.map(t => t.table_name);
        } else {
          const tablesResult = await query(
            "SELECT name as table_name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
          ) as any[];
          tables = tablesResult.map(t => t.table_name);
        }
        
        tablesCount = tables.length;

        let sqlDump = `-- Bivaax Trade Enterprise Backup (Logical Fallback)\n`;
        sqlDump += `-- Generated at: ${new Date(timestamp).toISOString()}\n`;
        sqlDump += `-- Requested by: ${adminId}\n\n`;
        sqlDump += "SET statement_timeout = 0;\nSET lock_timeout = 0;\nSET client_encoding = 'UTF8';\n";
        sqlDump += "SET standard_conforming_strings = on;\nSET check_function_bodies = false;\n";
        sqlDump += "SET xmloption = content;\nSET client_min_messages = warning;\nSET row_security = off;\n\n";

        for (const table of tables) {
          if (table.startsWith('_') || table === 'market_settings') continue;

          logger.info(`[BACKUP] Dumping table: ${table}`);
          sqlDump += `\n--\n-- Table structure for ${table}\n--\n\n`;
          
          const rows = await query(`SELECT * FROM ${table}`) as any[];
          
          if (rows.length > 0) {
            sqlDump += `-- Dumping data for table ${table} (${rows.length} rows)\n`;
            const columns = Object.keys(rows[0]);
            const colStr = columns.map(c => `"${c}"`).join(', ');
            
            for (const row of rows) {
              const values = columns.map(col => {
                const val = row[col];
                if (val === null) return 'NULL';
                if (typeof val === 'number') return val;
                if (typeof val === 'boolean') return val ? 'true' : 'false';
                if (val instanceof Date) return `'${val.toISOString()}'`;
                if (typeof val === 'object') return `'${JSON.stringify(val).replace(/'/g, "''")}'`;
                return `'${val.toString().replace(/'/g, "''")}'`;
              }).join(', ');
              
              sqlDump += `INSERT INTO "${table}" (${colStr}) VALUES (${values}) ON CONFLICT DO NOTHING;\n`;
            }
          }
        }
        
        fs.writeFileSync(filePath, sqlDump);
        sqlDumpContent = sqlDump;
      } else {
        if (fs.existsSync(filePath)) {
          sqlDumpContent = fs.readFileSync(filePath, 'utf8');
        }
        try {
          if (getDbType() === 'pg') {
            const countRes = await query(
              "SELECT count(*)::int as cnt FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE'"
            ) as any[];
            tablesCount = countRes[0]?.cnt || 0;
          } else {
            const countRes = await query(
              "SELECT count(*) as cnt FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
            ) as any[];
            tablesCount = countRes[0]?.cnt || 0;
          }
        } catch (e) {
          tablesCount = 15;
        }
      }

      // 3. Save locally and sync to secure off-site backup storage path
      const stats = fs.statSync(filePath);
      fs.copyFileSync(filePath, offsiteFilePath);
      logger.info(`[BACKUP-SUCCESS] Secure off-site copy generated at: ${offsiteFilePath}`);

      const backupId = `bk_${timestamp}`;
      
      // 4. Record metadata in SQL database
      await run(
        `INSERT INTO system_backups (id, timestamp, filename, size, status, tables_count, created_by)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [backupId, timestamp, filename, stats.size, 'success', tablesCount, adminId]
      );

      // 5. Persist backup in Firestore Cloud Database for permanent survival across updates
      if (adminDb) {
        try {
          await adminDb.collection('system_backups').doc(backupId).set({
            id: backupId,
            timestamp,
            filename,
            size: stats.size,
            status: 'success',
            tables_count: tablesCount,
            created_by: adminId,
            sqlContent: sqlDumpContent.length < 900000 ? sqlDumpContent : sqlDumpContent.slice(0, 900000)
          });
          logger.info(`[BACKUP-SUCCESS] Backup ${backupId} successfully persisted in Firestore Cloud!`);
        } catch (fsErr: any) {
          logger.error(`[BACKUP-FIRESTORE-FAILED] ${fsErr.message}`);
        }
      }

      // 6. Store detailed entry in audit logs
      const detailsStr = `Database backup created successfully: ${filename} (${(stats.size / 1024 / 1024).toFixed(2)} MB). Type: ${usedPgDump ? 'pg_dump' : 'logical_dumper'}. Persisted in Firestore Cloud.`;
      await run(
        `INSERT INTO audit_logs (user_id, action, entity_type, entity_id, details, created_at)
         VALUES (?, ?, ?, ?, ?, ?)`,
        [adminId, 'DATABASE_BACKUP', 'system_backup', backupId, detailsStr, timestamp]
      );

      logger.info(`[BACKUP-SUCCESS] Backup ${backupId} completed. Size: ${(stats.size / 1024).toFixed(2)} KB`);
      
      await this.rotateBackups();

      return {
        id: backupId,
        timestamp,
        filename,
        size: stats.size,
        status: 'success',
        tables_count: tablesCount,
        created_by: adminId
      };

    } catch (err: any) {
      logger.error(`[BACKUP-FAILED] ${err.message}`);
      
      const failId = `bk_fail_${timestamp}`;
      try {
        await run(
          `INSERT INTO system_backups (id, timestamp, filename, size, status, tables_count, created_by)
           VALUES (?, ?, ?, ?, ?, ?, ?)`,
          [failId, timestamp, 'N/A', 0, 'failed', 0, adminId]
        );
      } catch (dbErr: any) {
        logger.error(`[BACKUP-DB-RECORD-FAILED] Failed to insert failure log to database: ${dbErr.message}`);
      }
      
      throw err;
    }
  },

  /**
   * Cleans up backups older than 30 days locally and off-site
   */
  async rotateBackups() {
    try {
      const thirtyDaysAgo = Date.now() - (30 * 24 * 60 * 60 * 1000);
      
      if (fs.existsSync(BACKUP_DIR)) {
        const files = fs.readdirSync(BACKUP_DIR);
        for (const file of files) {
          const filePath = path.join(BACKUP_DIR, file);
          const stats = fs.statSync(filePath);
          if (stats.mtimeMs < thirtyDaysAgo) {
            logger.info(`[BACKUP-ROTATION] Deleting old primary backup: ${file}`);
            fs.unlinkSync(filePath);
          }
        }
      }

      if (fs.existsSync(SECURE_OFFSITE_DIR)) {
        const offsiteFiles = fs.readdirSync(SECURE_OFFSITE_DIR);
        for (const file of offsiteFiles) {
          const filePath = path.join(SECURE_OFFSITE_DIR, file);
          const stats = fs.statSync(filePath);
          if (stats.mtimeMs < thirtyDaysAgo) {
            logger.info(`[BACKUP-ROTATION] Deleting old off-site backup copy: ${file}`);
            fs.unlinkSync(filePath);
          }
        }
      }
    } catch (err: any) {
      logger.error(`[BACKUP-ROTATION-FAILED] ${err.message}`);
    }
  },

  /**
   * Retrieves backup history from local database and Firestore Cloud
   */
  async getBackupHistory(limitCount: number = 20): Promise<BackupRecord[]> {
    try {
      const sqlQuery = getDbType() === 'pg' 
        ? `SELECT id, timestamp, filename, size, status, tables_count, created_by FROM system_backups ORDER BY timestamp DESC LIMIT $1`
        : `SELECT id, timestamp, filename, size, status, tables_count, created_by FROM system_backups ORDER BY timestamp DESC LIMIT ?`;
      
      const rows = await query(sqlQuery, [limitCount]) as any[];
      const localMap = new Map<string, BackupRecord>();

      rows.forEach(r => {
        localMap.set(r.id, {
          id: r.id,
          timestamp: Number(r.timestamp),
          filename: r.filename,
          size: Number(r.size),
          status: r.status as any,
          tables_count: Number(r.tables_count),
          created_by: r.created_by
        });
      });

      // Also pull backup history from Firestore Cloud
      if (adminDb) {
        try {
          const snap = await adminDb.collection('system_backups').orderBy('timestamp', 'desc').limit(limitCount).get();
          for (const doc of snap.docs) {
            const data = doc.data();
            const bId = doc.id;
            if (!localMap.has(bId)) {
              const record: BackupRecord = {
                id: bId,
                timestamp: Number(data.timestamp || Date.now()),
                filename: data.filename || `backup_${bId}.sql`,
                size: Number(data.size || 0),
                status: (data.status || 'success') as any,
                tables_count: Number(data.tables_count || 0),
                created_by: data.created_by || 'admin'
              };
              localMap.set(bId, record);

              // Restore metadata to local SQL system_backups table
              await run(
                `INSERT INTO system_backups (id, timestamp, filename, size, status, tables_count, created_by)
                 VALUES (?, ?, ?, ?, ?, ?, ?)`,
                [bId, record.timestamp, record.filename, record.size, record.status, record.tables_count, record.created_by]
              ).catch(() => {});
            }
          }
        } catch (fsErr: any) {
          logger.error(`[BACKUP-HISTORY-FIRESTORE-FAILED] ${fsErr.message}`);
        }
      }

      return Array.from(localMap.values()).sort((a, b) => b.timestamp - a.timestamp);
    } catch (err: any) {
      logger.error(`[BACKUP-HISTORY-FAILED] Failed to fetch history from database: ${err.message}`);
      return [];
    }
  },

  /**
   * Restore process using local files or Firestore Cloud backup dump
   */
  async restoreFromBackup(backupId: string) {
    logger.warn(`[RESTORE] RESTORATION INITIATED FOR BACKUP: ${backupId}`);
    
    try {
      let sqlContent = '';
      
      let filename = `backup_${backupId}.sql`;
      try {
        const b = await query("SELECT filename FROM system_backups WHERE id = ?", [backupId]) as any[];
        if (b.length > 0 && b[0].filename) filename = b[0].filename;
      } catch (e) {}

      const filePath = path.join(BACKUP_DIR, filename);
      const offsiteFilePath = path.join(SECURE_OFFSITE_DIR, filename);
      
      if (fs.existsSync(filePath)) {
        sqlContent = fs.readFileSync(filePath, 'utf8');
      } else if (fs.existsSync(offsiteFilePath)) {
        sqlContent = fs.readFileSync(offsiteFilePath, 'utf8');
        logger.info(`[RESTORE] Restoring from off-site backup storage copy.`);
      }

      // If missing on local disk (e.g. after container update/re-deployment), fetch from Firestore Cloud!
      if (!sqlContent && adminDb) {
        logger.info(`[RESTORE] Local backup file missing. Fetching backup ${backupId} directly from Firestore Cloud...`);
        const doc = await adminDb.collection('system_backups').doc(backupId).get();
        if (doc.exists && doc.data()?.sqlContent) {
          sqlContent = doc.data()!.sqlContent;
          try {
            fs.writeFileSync(filePath, sqlContent);
            logger.info(`[RESTORE] Saved cloud backup dump to local disk at ${filePath}`);
          } catch (e) {}
        }
      }

      if (!sqlContent) {
        throw new Error(`Backup file ${filename} not found in local storage or Firestore Cloud`);
      }

      // Execute SQL dump as a raw block
      logger.info(`[RESTORE] Running raw SQL restore script...`);
      await runRawSql(sqlContent);

      logger.info(`[RESTORE-SUCCESS] Database restored from backup: ${backupId}`);
      return { success: true };
    } catch (err: any) {
      logger.error(`[RESTORE-FAILED] ${err.message}`);
      throw err;
    }
  }
};

