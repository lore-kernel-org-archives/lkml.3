Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496Ab3HGVP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:15:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47104 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3HGVLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 37/47] perf annotate browser: Improve description of '?' hotkey
Date: Wed,  7 Aug 2013 18:11:04 -0300
Message-Id: <1375909874-22073-38-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The previous description: "Search previous string" is usually associated
with the 'N' following a '/string', the opposite of 'n', which is
'Search next string' in the direction established with '/' or '?'.

So change it to 'Search string backwards', to clarify that.

The 'N' hotkey remains to be implemented with the semantic described
above.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-5lw5y15d7vv308xbpm8pqe4g@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 0f88a77..7d75497 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -732,7 +732,7 @@ static int annotate_browser__run(struct annotate_browser *browser,
 		"s             Toggle source code view\n"
 		"/             Search string\n"
 		"r             Run available scripts\n"
-		"?             Search previous string\n");
+		"?             Search string backwards\n");
 			continue;
 		case 'r':
 			{
-- 
1.8.1.4

