Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3LKLFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:05:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3LKLFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:05:06 -0500
Date: Wed, 11 Dec 2013 03:04:30 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-2bcab6c146fde0d0286b132068111f98b6217460@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1386595120-22978-2-git-send-email-adrian.hunter@intel.com>
References: <1386595120-22978-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Remove unnecessary parentheses
Git-Commit-ID: 2bcab6c146fde0d0286b132068111f98b6217460
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:04:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bcab6c146fde0d0286b132068111f98b6217460
Gitweb:     http://git.kernel.org/tip/2bcab6c146fde0d0286b132068111f98b6217460
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 9 Dec 2013 15:18:37 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:17:31 -0300

perf evlist: Remove unnecessary parentheses

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386595120-22978-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
