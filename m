Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbaFIJVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:21:32 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:47543 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933391AbaFIJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:21:28 -0400
X-Yandex-Uniq: 9b080a82-5abc-4dfd-97c4-f21ba6676d63
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com, jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf timechart: fix documentation
Date: Mon,  9 Jun 2014 13:21:11 +0400
Message-Id: <1402305672-2630-2-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402305672-2630-1-git-send-email-stfomichev@yandex-team.ru>
References: <1402305672-2630-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move options away from examples.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/Documentation/perf-timechart.txt | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index bc5990c33dc0..fab20d4504d2 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -43,6 +43,17 @@ TIMECHART OPTIONS
 
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
+-n::
+--proc-num::
+        Print task info for at least given number of tasks.
+-t::
+--topology::
+        Sort CPUs according to topology.
+--highlight=<duration_nsecs|task_name>::
+	Highlight tasks (using different color) that run more than given
+	duration or tasks with given name. If number is given it's interpreted
+	as number of nanoseconds. If non-numeric string is given it's
+	interpreted as task name.
 
 EXAMPLES
 --------
@@ -64,18 +75,6 @@ Record system-wide timechart:
 
   $ perf timechart --highlight gcc
 
--n::
---proc-num::
-        Print task info for at least given number of tasks.
--t::
---topology::
-        Sort CPUs according to topology.
---highlight=<duration_nsecs|task_name>::
-	Highlight tasks (using different color) that run more than given
-	duration or tasks with given name. If number is given it's interpreted
-	as number of nanoseconds. If non-numeric string is given it's
-	interpreted as task name.
-
 RECORD OPTIONS
 --------------
 -P::
-- 
1.8.3.2

