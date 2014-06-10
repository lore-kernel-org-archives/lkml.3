Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaFJJwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:52:22 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:39115 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbaFJJwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:52:21 -0400
X-Yandex-Uniq: 17db2de1-14a0-4728-865f-bdacfcff944b
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 10 Jun 2014 13:52:16 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@gmail.com>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 v2] perf timechart: fix documentation
Message-ID: <20140610095216.GO26511@stfomichev-desktop.yandex.net>
References: <1402305672-2630-1-git-send-email-stfomichev@yandex-team.ru>
 <1402305672-2630-2-git-send-email-stfomichev@yandex-team.ru>
 <87bnu1b5hp.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bnu1b5hp.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move options away from examples.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
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
1.8.3.2

