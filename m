Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaDNOx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:53:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46623 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaDNOxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:53:54 -0400
Date: Mon, 14 Apr 2014 07:53:41 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-95a2b3c0a9e2a8038edbf3f9776d5a3d76146459@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1395964219-22173-3-git-send-email-artagnon@gmail.com>
References: <1395964219-22173-3-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf bench:
  Update manpage to mention numa and futex
Git-Commit-ID: 95a2b3c0a9e2a8038edbf3f9776d5a3d76146459
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

Commit-ID:  95a2b3c0a9e2a8038edbf3f9776d5a3d76146459
Gitweb:     http://git.kernel.org/tip/95a2b3c0a9e2a8038edbf3f9776d5a3d76146459
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Thu, 27 Mar 2014 19:50:18 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Mon, 14 Apr 2014 12:55:41 +0200

perf bench: Update manpage to mention numa and futex

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
