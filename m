Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaDNOYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:24:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbaDNOSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:18:12 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/17] perf bench: Update manpage to mention numa and futex
Date: Mon, 14 Apr 2014 16:17:34 +0200
Message-Id: <1397485061-17215-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
References: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1395964219-22173-3-git-send-email-artagnon@gmail.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.8.3.1

