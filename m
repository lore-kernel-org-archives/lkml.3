Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab3JCJWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:22:21 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39690 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3JCJWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:22:20 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf tool: add example to perf-timechart documentation
Date: Thu,  3 Oct 2013 14:45:16 +0530
Message-Id: <1380791716-10325-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, update the synopsis to show both forms.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/Documentation/perf-timechart.txt | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 1632b0e..3ff8bd4 100644
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
1.8.4.477.g5d89aa9

