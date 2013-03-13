Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3CMLV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:21:29 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49264 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab3CMLTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:19:49 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-91-514060d2e4bb
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/6] perf util: Remove unused macro definitions
Date: Wed, 13 Mar 2013 20:19:43 +0900
Message-Id: <1363173585-9754-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363173585-9754-1-git-send-email-namhyung@kernel.org>
References: <1363173585-9754-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

They're never used and looks like leftovers from the porting of
trace-cmd code.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 783ab51e3ff7..3c452b587daa 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -43,13 +43,6 @@
 
 #define VERSION "0.5"
 
-#define TRACE_CTRL	"tracing_on"
-#define TRACE		"trace"
-#define AVAILABLE	"available_tracers"
-#define CURRENT		"current_tracer"
-#define ITER_CTRL	"trace_options"
-#define MAX_LATENCY	"tracing_max_latency"
-
 unsigned int page_size;
 
 static const char *output_file = "trace.info";
-- 
1.7.11.7

