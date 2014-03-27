Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbaC0Xtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 19:49:46 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:59133 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679AbaC0XtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 19:49:21 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf bench: Update manpage to mention numa and futex
Date: Thu, 27 Mar 2014 19:50:18 -0400
Message-Id: <1395964219-22173-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
In-Reply-To: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
References: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/Documentation/perf-bench.txt | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index 7065cd6..4464ad7 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -48,6 +48,12 @@ SUBSYSTEM
 'mem'::
 	Memory access performance.
 
+'numa'::
+	NUMA scheduling and MM benchmarks.
+
+'futex'::
+	Futex stressing benchmarks.
+
 'all'::
 	All benchmark subsystems.
 
@@ -187,6 +193,22 @@ Show only the result with page faults before memset.
 --no-prefault::
 Show only the result without page faults before memset.
 
+SUITES FOR 'numa'
+~~~~~~~~~~~~~~~~~
+*mem*::
+Suite for evaluating NUMA workloads.
+
+SUITES FOR 'futex'
+~~~~~~~~~~~~~~~~~~
+*hash*::
+Suite for evaluating hash tables.
+
+*wake*::
+Suite for evaluating wake calls.
+
+*requeue*::
+Suite for evaluating requeue calls.
+
 SEE ALSO
 --------
 linkperf:perf[1]
-- 
1.9.0.431.g014438b

