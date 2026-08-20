const fs = require('fs');

let content = fs.readFileSync('src/api/routes.ts', 'utf-8');

// Helper to replace route declarations
function secureRoute(routeMethod, routePath, paramName, paramSource) {
    const searchRegex = new RegExp(`(router\\.${routeMethod}\\('${routePath}', )async \\(req, res\\) => \\{\\s*const (\\{[^}]+\\}|uid|userId) = req\\.${paramSource};`);
    
    // We want to replace it with requireAuth and overriding the param
    content = content.replace(searchRegex, (match, p1) => {
        let replacement = `${p1}requireAuth, async (req: AuthRequest, res) => {\n  let ${paramName} = req.${paramSource}.${paramName};\n  if (!req.user?.isAdmin) ${paramName} = req.user?.uid;\n  if (!${paramName}) ${paramName} = req.user?.uid;`;
        return replacement;
    });
}

function secureAuthenticatedRoute(routeMethod, routePath, paramName, paramSource) {
    const searchRegex = new RegExp(`(router\\.${routeMethod}\\('${routePath}', requireAuth, async \\(req: AuthRequest, res\\) => \\{\\s*const \\{ ${paramName}.*?\\} = req\\.${paramSource};)`);
    content = content.replace(searchRegex, (match, p1) => {
        let replacement = `router.${routeMethod}('${routePath}', requireAuth, async (req: AuthRequest, res) => {\n  let { ${paramName} } = req.${paramSource};\n  if (!req.user?.isAdmin) ${paramName} = req.user?.uid;\n  if (!${paramName}) ${paramName} = req.user?.uid;`;
        return replacement;
    });
}

// 1. /user/details
content = content.replace(
  /router\.get\('\/user\/details', async \(req, res\) => \{\n\s*const \{ uid \} = req\.query;/g,
  `router.get('/user/details', requireAuth, async (req: AuthRequest, res) => {\n  let uid = req.query.uid as string;\n  if (!req.user?.isAdmin) uid = req.user!.uid;\n  if (!uid) uid = req.user!.uid;`
);

// 2. /user/sync
content = content.replace(
  /router\.post\('\/user\/sync', async \(req, res\) => \{\n\s*const \{ uid \} = req\.body;/g,
  `router.post('/user/sync', requireAuth, async (req: AuthRequest, res) => {\n  let uid = req.body.uid;\n  if (!req.user?.isAdmin) uid = req.user!.uid;\n  if (!uid) uid = req.user!.uid;`
);

// 3. /user/check-2fa
content = content.replace(
  /router\.get\('\/user\/check-2fa', async \(req, res\) => \{\n\s*const \{ uid \} = req\.query;/g,
  `router.get('/user/check-2fa', requireAuth, async (req: AuthRequest, res) => {\n  let uid = req.query.uid as string;\n  if (!req.user?.isAdmin) uid = req.user!.uid;\n  if (!uid) uid = req.user!.uid;`
);

// 4. /user-trades
content = content.replace(
  /router\.get\('\/user-trades', async \(req, res\) => \{\n\s*const \{ userId \} = req\.query;/g,
  `router.get('/user-trades', requireAuth, async (req: AuthRequest, res) => {\n  let userId = req.query.userId as string;\n  if (!req.user?.isAdmin) userId = req.user!.uid;\n  if (!userId) userId = req.user!.uid;`
);

// 5. /user-tickets
content = content.replace(
  /router\.get\('\/user-tickets', async \(req, res\) => \{\n\s*const \{ userId \} = req\.query;/g,
  `router.get('/user-tickets', requireAuth, async (req: AuthRequest, res) => {\n  let userId = req.query.userId as string;\n  if (!req.user?.isAdmin) userId = req.user!.uid;\n  if (!userId) userId = req.user!.uid;`
);

// 6. /user/kyc-status
content = content.replace(
  /router\.get\('\/user\/kyc-status', async \(req, res\) => \{\n\s*const \{ userId \} = req\.query;/g,
  `router.get('/user/kyc-status', requireAuth, async (req: AuthRequest, res) => {\n  let userId = req.query.userId as string;\n  if (!req.user?.isAdmin) userId = req.user!.uid;\n  if (!userId) userId = req.user!.uid;`
);

// 7. /kyc
content = content.replace(
  /router\.post\('\/kyc', requireAuth, async \(req: AuthRequest, res\) => \{\n\s*const \{ userId, kycData \} = req\.body;/g,
  `router.post('/kyc', requireAuth, async (req: AuthRequest, res) => {\n  let { userId, kycData } = req.body;\n  if (!req.user?.isAdmin) userId = req.user!.uid;\n  if (!userId) userId = req.user!.uid;`
);

// 8. /trade (unauthenticated! need to secure it)
content = content.replace(
  /router\.post\('\/trade', async \(req, res\) => \{\n\s*const \{ pair, amount, direction, accountType, userId, tournamentId, trade \} = req\.body;/g,
  `router.post('/trade', requireAuth, async (req: AuthRequest, res) => {\n  let { pair, amount, direction, accountType, userId, tournamentId, trade } = req.body;\n  if (!req.user?.isAdmin) userId = req.user!.uid;\n  if (!userId) userId = req.user!.uid;`
);

// 9. /support/tickets (GET)
content = content.replace(
  /router\.get\('\/support\/tickets', async \(req, res\) => \{\n\s*try \{\n\s*const \{ status, category, search, assignedAgentId, userId \} = req\.query as any;/g,
  `router.get('/support/tickets', requireAuth, async (req: AuthRequest, res) => {\n  try {\n    let { status, category, search, assignedAgentId, userId } = req.query as any;\n    if (!req.user?.isAdmin) userId = req.user!.uid;`
);

// 10. /tickets (GET)
content = content.replace(
  /router\.get\('\/tickets', async \(req, res\) => \{\n\s*try \{\n\s*const \{ status, category, search, assignedAgentId, userId \} = req\.query as any;/g,
  `router.get('/tickets', requireAuth, async (req: AuthRequest, res) => {\n  try {\n    let { status, category, search, assignedAgentId, userId } = req.query as any;\n    if (!req.user?.isAdmin) userId = req.user!.uid;`
);

// 11. /tickets/messages
content = content.replace(
  /router\.post\('\/tickets\/messages', async \(req, res\) => \{\n\s*const \{ ticketId, userId, message, isAdmin, senderName \} = req\.body;/g,
  `router.post('/tickets/messages', requireAuth, async (req: AuthRequest, res) => {\n  let { ticketId, userId, message, isAdmin, senderName } = req.body;\n  if (!req.user?.isAdmin) {\n    userId = req.user!.uid;\n    isAdmin = false;\n  }\n  if (!userId) userId = req.user!.uid;`
);

// 12. /support/reply
content = content.replace(
  /router\.post\('\/support\/reply', async \(req, res\) => \{\n\s*const \{ ticketId, message, agentId, agentName \} = req\.body;/g,
  `router.post('/support/reply', requireAuth, async (req: AuthRequest, res) => {\n  if (!req.user?.isAdmin) return res.status(403).json({ error: 'Admin only' });\n  const { ticketId, message, agentId, agentName } = req.body;`
);

fs.writeFileSync('src/api/routes.ts', content);
console.log('Routes secured.');
