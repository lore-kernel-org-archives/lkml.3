Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab3JNUXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:23:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38992 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 137/161] perf timechart: Add example in the documentation
Date: Mon, 14 Oct 2013 17:02:06 -0300
Message-Id: <1381780950-25642-138-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

While at it, update the synopsis to show both forms.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Link: http://lkml.kernel.org/r/1380791716-10325-1-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-timechart.txt | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 1632b0efc757..3ff8bd4f0b4d 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -8,7 +8,8 @@ perf-timechart - Tool to visualize total system behavior during a workload
 SYNOPSIS
 --------
 [verse]
-'perf timechart' {record}
+'perf timechart' record <command>
+'perf timechart' [<options>]
 
 DESCRIPTION
 -----------
@@ -41,6 +42,18 @@ OPTIONS
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
 
+EXAMPLES
+--------
+
+$ perf timechart record git pull
+
+  [ perf record: Woken up 13 times to write data ]
+  [ perf record: Captured and wrote 4.253 MB perf.data (~185801 samples) ]
+
+$ perf timechart
+
+  Written 10.2 seconds of trace to output.svg.
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
-- 
1.8.1.4

