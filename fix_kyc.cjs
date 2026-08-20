const fs = require('fs');
let content = fs.readFileSync('src/api/routes.ts', 'utf-8');

content = content.replace(
  /router\.post\('\/api\/kyc', async \(req, res\) => \{\n\s*const \{ userId, kycData \} = req\.body;/g,
  `router.post('/api/kyc', requireAuth, async (req: AuthRequest, res) => {\n  let { userId, kycData } = req.body;\n  if (!req.user?.isAdmin) userId = req.user!.uid;\n  if (!userId) userId = req.user!.uid;`
);

fs.writeFileSync('src/api/routes.ts', content);
