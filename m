Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbaGNVr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:47:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387AbaGNVrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:47:19 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/5] perf tools: Remove getopt.h includes
Date: Mon, 14 Jul 2014 23:46:51 +0200
Message-Id: <1405374411-29012-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405374411-29012-1-git-send-email-jolsa@kernel.org>
References: <1405374411-29012-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't use getopt.h interfaces.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/probe-finder.c     | 1 -
 tools/perf/util/trace-event-read.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 98e304766416..dca9145d704c 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -26,7 +26,6 @@
 #include <errno.h>
 #include <stdio.h>
 #include <unistd.h>
-#include <getopt.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdarg.h>
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index ea3fd7fc6f5c..54d9e9b548a8 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -22,7 +22,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <stdarg.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-- 
1.8.3.1

