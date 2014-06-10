Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaFJOqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:46:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:53774 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbaFJOqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:46:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/7] perf timechart: Reflow documentation
Date: Tue, 10 Jun 2014 11:46:04 -0300
Message-Id: <1402411564-3303-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402411564-3303-1-git-send-email-acme@infradead.org>
References: <1402411564-3303-1-git-send-email-acme@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

Move options away from examples.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>
Link: http://lkml.kernel.org/r/20140610095216.GO26511@stfomichev-desktop.yandex.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-timechart.txt | 41 ++++++++++++++---------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index bc5990c33dc0..5e0f986dff38 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -43,27 +43,6 @@ TIMECHART OPTIONS
 
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
-
-EXAMPLES
---------
-
-$ perf timechart record git pull
-
-  [ perf record: Woken up 13 times to write data ]
-  [ perf record: Captured and wrote 4.253 MB perf.data (~185801 samples) ]
-
-$ perf timechart
-
-  Written 10.2 seconds of trace to output.svg.
-
-Record system-wide timechart:
-
-  $ perf timechart record
-
-  then generate timechart and highlight 'gcc' tasks:
-
-  $ perf timechart --highlight gcc
-
 -n::
 --proc-num::
         Print task info for at least given number of tasks.
@@ -88,6 +67,26 @@ RECORD OPTIONS
 --callchain::
         Do call-graph (stack chain/backtrace) recording
 
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
+Record system-wide timechart:
+
+  $ perf timechart record
+
+  then generate timechart and highlight 'gcc' tasks:
+
+  $ perf timechart --highlight gcc
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
-- 
1.9.3

