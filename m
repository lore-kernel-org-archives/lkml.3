Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964941AbaFLMFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:05:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60693 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964920AbaFLMFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:05:12 -0400
Date: Thu, 12 Jun 2014 05:04:59 -0700
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-f48e00cead1f7574147e6bd0d203c8331714d35b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@gmail.com, jolsa@redhat.com,
        stfomichev@yandex-team.ru, tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@gmail.com, jolsa@redhat.com,
        stfomichev@yandex-team.ru, artagnon@gmail.com, tglx@linutronix.de
In-Reply-To: <20140610095216.GO26511@stfomichev-desktop.yandex.net>
References: <20140610095216.GO26511@stfomichev-desktop.yandex.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart: Reflow documentation
Git-Commit-ID: f48e00cead1f7574147e6bd0d203c8331714d35b
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

Commit-ID:  f48e00cead1f7574147e6bd0d203c8331714d35b
Gitweb:     http://git.kernel.org/tip/f48e00cead1f7574147e6bd0d203c8331714d35b
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Tue, 10 Jun 2014 13:52:16 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Jun 2014 10:03:18 -0300

perf timechart: Reflow documentation

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
index bc5990c..5e0f986 100644
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
