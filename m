Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaEERts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:49:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaEERtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:49:45 -0400
Date: Mon, 5 May 2014 10:48:47 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-36446f4bfe613ad1da00f06081d410d62c07d334@git.kernel.org>
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
In-Reply-To: <1399293219-8732-6-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-6-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove PR_TASK_PERF_EVENTS_* from perf.h
Git-Commit-ID: 36446f4bfe613ad1da00f06081d410d62c07d334
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

Commit-ID:  36446f4bfe613ad1da00f06081d410d62c07d334
Gitweb:     http://git.kernel.org/tip/36446f4bfe613ad1da00f06081d410d62c07d334
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 5 May 2014 12:37:05 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 5 May 2014 17:47:25 +0200

perf tools: Remove PR_TASK_PERF_EVENTS_* from perf.h

It's defined in include/uapi/linux/prctl.h header.
Also it was never used in perf tool.

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
Link: http://lkml.kernel.org/r/1399293219-8732-6-git-send-email-jolsa@kernel.org
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
