Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaEEMeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:34:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbaEEMeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:34:08 -0400
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
Subject: [PATCH 05/10] perf tools: Remove PR_TASK_PERF_EVENTS_* from perf.h
Date: Mon,  5 May 2014 14:33:34 +0200
Message-Id: <1399293219-8732-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's defined in include/uapi/linux/prctl.h header.
Also it was never used in perf tool.

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
 tools/perf/perf.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 622949d..1bf9537 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -176,13 +176,6 @@
 #include <linux/types.h>
 #include <linux/perf_event.h>
 
-/*
- * prctl(PR_TASK_PERF_EVENTS_DISABLE) will (cheaply) disable all
- * counters in the current task.
- */
-#define PR_TASK_PERF_EVENTS_DISABLE   31
-#define PR_TASK_PERF_EVENTS_ENABLE    32
-
 #ifndef NSEC_PER_SEC
 # define NSEC_PER_SEC			1000000000ULL
 #endif
-- 
1.8.3.1

