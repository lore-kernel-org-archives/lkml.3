Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaG3Mzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:55:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43950 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaG3Mzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:55:45 -0400
Date: Wed, 30 Jul 2014 05:55:11 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-vkcf53oultknsh3ue9fhin94@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix perf usage string leftover
Git-Commit-ID: 78a1b503c8d4115cc608208cc767f57c91381165
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

Commit-ID:  78a1b503c8d4115cc608208cc767f57c91381165
Gitweb:     http://git.kernel.org/tip/78a1b503c8d4115cc608208cc767f57c91381165
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 18 Jul 2014 09:11:30 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 28 Jul 2014 15:58:13 +0200

perf tools: Fix perf usage string leftover

Fixing perf usage string leftover pointed out by Namhyung.

Reported-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-vkcf53oultknsh3ue9fhin94@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index eed3fb2..2282d41 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -18,7 +18,7 @@
 #include <pthread.h>
 
 const char perf_usage_string[] =
-	"perf [--version] [--debug variable[=VALUE]] [--help] COMMAND [ARGS]";
+	"perf [--version] [--help] [OPTIONS] COMMAND [ARGS]";
 
 const char perf_more_info_string[] =
 	"See 'perf help COMMAND' for more information on a specific command.";
