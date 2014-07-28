Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaG1PBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:01:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaG1PB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:01:28 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] perf tools: Fix perf usage string leftover
Date: Mon, 28 Jul 2014 17:01:01 +0200
Message-Id: <1406559662-4376-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406559662-4376-1-git-send-email-jolsa@kernel.org>
References: <1406559662-4376-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index eed3fb2a3af0..2282d41879a2 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -18,7 +18,7 @@
 #include <pthread.h>
 
 const char perf_usage_string[] =
-	"perf [--version] [--debug variable[=VALUE]] [--help] COMMAND [ARGS]";
+	"perf [--version] [--help] [OPTIONS] COMMAND [ARGS]";
 
 const char perf_more_info_string[] =
 	"See 'perf help COMMAND' for more information on a specific command.";
-- 
1.8.3.1

