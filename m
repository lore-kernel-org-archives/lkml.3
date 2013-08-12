Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3HLKX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:23:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48112 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab3HLKXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:23:22 -0400
Date: Mon, 12 Aug 2013 03:22:42 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-5lw5y15d7vv308xbpm8pqe4g@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Improve description of '?'
  hotkey
Git-Commit-ID: fcd9fef9a64b84520852e0247d6796893e28864c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:22:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fcd9fef9a64b84520852e0247d6796893e28864c
Gitweb:     http://git.kernel.org/tip/fcd9fef9a64b84520852e0247d6796893e28864c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 7 Aug 2013 15:55:48 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:36 -0300

perf annotate browser: Improve description of '?' hotkey

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
