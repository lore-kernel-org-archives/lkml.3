Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaEEMeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:34:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbaEEMeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:34:03 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/10] perf tools: Remove asmlinkage define from perf.h
Date: Mon,  5 May 2014 14:33:33 +0200
Message-Id: <1399293219-8732-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it's no longer used.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 50aa88d..622949d 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -198,11 +198,6 @@ static inline unsigned long long rdclock(void)
 	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
 }
 
-/*
- * Pick up some kernel type conventions:
- */
-#define asmlinkage
-
 extern bool test_attr__enabled;
 void test_attr__init(void);
 void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
-- 
1.8.3.1

