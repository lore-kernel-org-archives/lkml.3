Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab3LINKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:10:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:55833 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272Ab3LINKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:10:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,857,1378882800"; 
   d="scan'208";a="449172814"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/4] perf tools: Remove unnecessary parentheses
Date: Mon,  9 Dec 2013 15:18:37 +0200
Message-Id: <1386595120-22978-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
References: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary parentheses.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7bb6ee1..4d0945c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -732,7 +732,7 @@ static long parse_pages_arg(const char *str, unsigned long min,
 			return -EINVAL;
 	}
 
-	if ((pages == 0) && (min == 0)) {
+	if (pages == 0 && min == 0) {
 		/* leave number of pages at 0 */
 	} else if (pages < (1UL << 31) && !is_power_of_2(pages)) {
 		/* round pages up to next power of 2 */
-- 
1.7.11.7

