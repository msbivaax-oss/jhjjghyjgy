const fs = require('fs');
let content = fs.readFileSync('src/api/routes.ts', 'utf-8');

content = content.replace(
  /router\.get\('\/support\/user-context\/:userId', async \(req, res\) => \{/g,
  `router.get('/support/user-context/:userId', requireAdmin, async (req: AuthRequest, res) => {`
);

fs.writeFileSync('src/api/routes.ts', content);
