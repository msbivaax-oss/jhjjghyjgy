const fs = require('fs');
const content = fs.readFileSync('src/api/routes.ts', 'utf-8');

const routes = [...content.matchAll(/router\.(get|post|put|patch|delete)\(['`"]([^'`"]+)['`"]/g)];
routes.forEach(r => {
  const method = r[1];
  const path = r[2];
  const index = r.index;
  const block = content.slice(index, index + 500); // 500 chars should cover the signature
  const hasRequireAuth = block.includes('requireAuth');
  if (block.includes('req.query') || block.includes('req.body') || block.includes('req.params')) {
     const hasUid = block.includes('uid') || block.includes('userId') || block.includes('userId');
     if (hasUid && !hasRequireAuth) {
        console.log(`Vulnerable route (no auth): ${method} ${path}`);
     } else if (hasUid && hasRequireAuth) {
        // verify if it trusts client uid
        if (block.includes('req.query') || block.includes('req.body') || block.includes('req.params')) {
            console.log(`Needs inspection (has auth): ${method} ${path}`);
        }
     }
  }
});
