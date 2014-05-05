Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbaEERvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:51:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53092 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbaEERt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:49:26 -0400
Date: Mon, 5 May 2014 10:47:54 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-3dd422b4a5009e7654846534d535758d4cc985db@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de, bp@suse.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1399293219-8732-2-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove MAX_COUNTERS define from perf.h
Git-Commit-ID: 3dd422b4a5009e7654846534d535758d4cc985db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3dd422b4a5009e7654846534d535758d4cc985db
Gitweb:     http://git.kernel.org/tip/3dd422b4a5009e7654846534d535758d4cc985db
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 5 May 2014 12:26:14 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 5 May 2014 17:45:20 +0200

perf tools: Remove MAX_COUNTERS define from perf.h

As it's no longer used.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1399293219-8732-2-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 5aa8ac4..3bea2e6 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -231,7 +231,6 @@ sys_perf_event_open(struct perf_event_attr *attr,
 	return fd;
 }
 
-#define MAX_COUNTERS			256
 #define MAX_NR_CPUS			256
 
 struct ip_callchain {
