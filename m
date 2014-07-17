Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935029AbaGQQPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:15:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:52775 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933922AbaGQQPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:15:14 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 32/33] perf tools: Remove needless getopt.h includes
Date: Thu, 17 Jul 2014 13:12:34 -0300
Message-Id: <1405613555-23380-33-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

We don't use getopt.h interfaces.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1405374411-29012-6-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.9.3

