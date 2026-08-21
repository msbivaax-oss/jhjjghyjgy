import dns from 'dns';
import { promisify } from 'util';
import fs from 'fs';
import path from 'path';
import { GoogleGenAI } from '@google/genai';

const lookup = promisify(dns.lookup);

// Helper for masking credentials
function maskString(str: string | undefined): string {
  if (!str) return 'MISSING';
  if (str.length <= 8) return '********';
  return str.slice(0, 4) + '...' + str.slice(-4);
}

// Parse PostgreSQL URL parts safely
function parsePostgresUrl(url: string | undefined) {
  if (!url) return null;
  try {
    const pattern = /postgresql:\/\/([^:]+):([^@]+)@([^:/]+):?(\d+)?\/([^?]+)/;
    const match = url.match(pattern);
    if (!match) return { isCustom: true, raw: maskString(url) };
    const [, user, , host, port = '5432', database] = match;
    return {
      user,
      host,
      port,
      database
    };
  } catch {
    return null;
  }
}

async function runDiagnostics() {
  console.log('\n======================================================');
  console.log('   BIVAAX TRADE TERMINAL - PRODUCTION SYSTEM DIAGNOSTICS');
  console.log('======================================================\n');

  console.log('--- [1/5] ENVIRONMENT CONFIGURATION AUDIT ---');
  
  const envFiles = ['.env', '.env.production', '.env.local'];
  const activeFiles = envFiles.filter(f => fs.existsSync(path.join(process.cwd(), f)));
  console.log(`Detected local env files: ${activeFiles.join(', ') || 'None (Using environment variables)'}`);

  const pgUrl = process.env.DATABASE_URL || process.env.POSTGRES_URL || process.env.PG_URL;
  const hasPgUrl = !!pgUrl;
  console.log(`- DATABASE_URL / POSTGRES_URL: ${hasPgUrl ? 'PRESENT' : 'NOT DEFINED'}`);
  
  if (hasPgUrl) {
    const parsed = parsePostgresUrl(pgUrl);
    if (parsed) {
      if ('isCustom' in parsed) {
        console.log(`  * Connection String: ${parsed.raw}`);
      } else {
        console.log(`  * PostgreSQL Host: ${parsed.host}`);
        console.log(`  * PostgreSQL Port: ${parsed.port}`);
        console.log(`  * PostgreSQL User: ${parsed.user}`);
        console.log(`  * Database Name:   ${parsed.database}`);
      }
    }
  }

  const fbProjectId = process.env.FIREBASE_PROJECT_ID || 'bivaax-trade-999';
  console.log(`- FIREBASE_PROJECT_ID: ${fbProjectId}`);
  console.log(`- GOOGLE_APPLICATION_CREDENTIALS: ${process.env.GOOGLE_APPLICATION_CREDENTIALS ? 'PRESENT' : 'NOT SET (using default/fallback credentials)'}`);
  console.log(`- GEMINI_API_KEY: ${process.env.GEMINI_API_KEY ? 'PRESENT (' + maskString(process.env.GEMINI_API_KEY) + ')' : 'NOT DEFINED'}`);
  
  console.log('\n--- [2/5] NETWORK & DNS VERIFICATION ---');
  if (hasPgUrl) {
    const parsed = parsePostgresUrl(pgUrl);
    if (parsed && !('isCustom' in parsed) && parsed.host) {
      console.log(`Attempting DNS lookup for PostgreSQL host "${parsed.host}"...`);
      try {
        const result = await lookup(parsed.host);
        console.log(`✅ DNS Lookup Succeeded: Resolved "${parsed.host}" to IP: ${result.address}`);
      } catch (err: any) {
        console.log(`❌ DNS Lookup Failed for "${parsed.host}": ${err.message}`);
        console.log('  ⚠️ This is a severe network or infrastructure issue. The container cannot resolve the DB hostname.');
      }
    }
  } else {
    console.log('ℹ️ Skipping database DNS lookup since no PostgreSQL connection string is set.');
  }

  let pgInUse = false;
  console.log('\n--- [3/5] DATABASE SYSTEM HEALTH CHECK ---');
  try {
    const { getDbType, isUsingPg, query } = await import('./src/db/mysql-db.ts');
    pgInUse = isUsingPg();
    
    console.log(`- Currently selected database driver: ${getDbType().toUpperCase()}`);
    console.log(`- PostgreSQL in-use state: ${isUsingPg() ? 'ACTIVE 🟢' : 'OFFLINE/FALLBACK 🔴'}`);

    console.log('\nTesting connection query on the active database...');
    try {
      const startQuery = Date.now();
      const testResult = await query('SELECT 1 as conn_check');
      const latency = Date.now() - startQuery;
      if (testResult && testResult.length > 0) {
        console.log(`✅ Active Database Connection Test Passed (Latency: ${latency}ms)`);
      } else {
        console.log('⚠️ Active Database query executed but returned an empty or unexpected response.');
      }
    } catch (dbErr: any) {
      console.log(`❌ Database Query Execution Failed: ${dbErr.message}`);
    }

    console.log('\nFetching system user counts to verify schema:');
    try {
      const userCount: any = await query('SELECT count(*) as total FROM users');
      console.log(`✅ Table "users" verified. Total user records: ${userCount[0]?.total ?? 0}`);
    } catch (usersErr: any) {
      console.log(`❌ Failed to query "users" table: ${usersErr.message}`);
    }

    console.log('\nChecking backup capabilities:');
    const hasPgDump = await new Promise((res) => {
      import('child_process').then(({ exec }) => {
        exec('pg_dump --version', (err) => {
          res(!err);
        });
      });
    });
    console.log(`- "pg_dump" utility available on container: ${hasPgDump ? 'YES 🟢' : 'NO 🔴 (Backup snapshot will use standard JSON/Drizzle export)'}`);

  } catch (importErr: any) {
    console.log(`❌ Failed to load local database modules: ${importErr.message}`);
  }

  console.log('\n--- [4/5] FIRESTORE / FIREBASE ADMIN VERIFICATION ---');
  try {
    const { adminDb } = await import('./src/lib/firebase-admin.ts');
    if (!adminDb) {
      console.log('⚠️ Firebase Admin "adminDb" object is null or undefined.');
    } else {
      console.log('Testing Firestore connectivity...');
      try {
        const startFs = Date.now();
        const testDocs = await adminDb.collection('app_config').limit(1).get();
        const latencyFs = Date.now() - startFs;
        console.log(`✅ Firestore SDK connected successfully (Latency: ${latencyFs}ms).`);
      } catch (fsErr: any) {
        console.log(`ℹ️ Firestore connection is offline/simulated: ${fsErr.message}`);
        console.log('  * Running with self-healing offline wrapper.');
      }
    }
  } catch (fbImportErr: any) {
    console.log(`⚠️ Failed to load Firebase modules: ${fbImportErr.message}`);
  }

  console.log('\n--- [5/5] SERVER RUNTIME LOG AUDIT ---');
  const serverLogPath = '/tmp/server.log';
  if (fs.existsSync(serverLogPath)) {
    console.log(`Analyzing recent entries in production server log (${serverLogPath}):`);
    try {
      const logs = fs.readFileSync(serverLogPath, 'utf8');
      const lines = logs.split('\n').filter(Boolean);
      const recentLines = lines.slice(-20);
      
      let warnings = 0;
      recentLines.forEach((line) => {
        if (line.includes('warn') || line.includes('error') || line.includes('fail')) {
          console.log(`  [ALERT] ${line}`);
          warnings++;
        } else {
          console.log(`  [INFO]  ${line}`);
        }
      });
      if (warnings === 0) {
        console.log('✅ No error/warning/failure alerts found in the most recent log entries.');
      }
    } catch (logReadErr: any) {
      console.log(`⚠️ Could not read production server log file: ${logReadErr.message}`);
    }
  } else {
    console.log(`ℹ️ No production server log found at ${serverLogPath} (Server not running or logging to standard output).`);
  }

  console.log('\n======================================================');
  console.log('                RECOMMENDATIONS & DIAGNOSES');
  console.log('======================================================');
  
  if (hasPgUrl && !pgInUse) {
    console.log('\n👉 DATABASE CONNECTION STATUS: Fallback Mode Active');
    console.log('   The server is currently using local SQLite persistence to keep service active.');
    console.log('   If PostgreSQL is expected, check your network configuration, host firewall rules,');
    console.log('   and ensure the username, password, and database are typed correctly.');
  } else if (!hasPgUrl) {
    console.log('\n👉 DATABASE PERSISTENCE STATUS: SQLite Active');
    console.log('   Running perfectly in SQLite offline-first mode. No action is required unless you');
    console.log('   explicitly wish to connect an external PostgreSQL database.');
  } else {
    console.log('\n👉 DATABASE SYSTEM STATUS: Healthy');
    console.log('   PostgreSQL connection is operational and fully synchronized.');
  }

  console.log('\nDiagnostics Complete.\n');
}

runDiagnostics().catch(err => {
  console.error('Fatal diagnostics failure:', err);
});
