Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3CMLTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:19:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49264 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3CMLTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:19:49 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-8b-514060d2cf0b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/6] perf util: Remove unused struct definitions
Date: Wed, 13 Mar 2013 20:19:41 +0900
Message-Id: <1363173585-9754-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363173585-9754-1-git-send-email-namhyung@kernel.org>
References: <1363173585-9754-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

struct event_list and struct events are never used.
Just get rid of them.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 5c1509ab0c29..b0bbd76f4a56 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -55,18 +55,6 @@ unsigned int page_size;
 static const char *output_file = "trace.info";
 static int output_fd;
 
-struct event_list {
-	struct event_list *next;
-	const char *event;
-};
-
-struct events {
-	struct events *sibling;
-	struct events *children;
-	struct events *next;
-	char *name;
-};
-
 
 static void *malloc_or_die(unsigned int size)
 {
-- 
1.7.11.7

