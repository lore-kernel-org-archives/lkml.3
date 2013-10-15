Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab3JOFcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:32:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33680 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab3JOFcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:32:39 -0400
Date: Mon, 14 Oct 2013 22:32:27 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-d366c53e1d4fc9d7a5826fd82010b3cffaabe5f1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1380791716-10325-1-git-send-email-artagnon@gmail.com>
References: <1380791716-10325-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart: Add example in the documentation
Git-Commit-ID: d366c53e1d4fc9d7a5826fd82010b3cffaabe5f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:32:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d366c53e1d4fc9d7a5826fd82010b3cffaabe5f1
Gitweb:     http://git.kernel.org/tip/d366c53e1d4fc9d7a5826fd82010b3cffaabe5f1
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Thu, 3 Oct 2013 14:45:16 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:18:13 -0300

perf timechart: Add example in the documentation

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
